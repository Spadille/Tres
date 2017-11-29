//
//  PViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/28/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase

class PViewController: UIViewController,UIGestureRecognizerDelegate {

    
    let min_header: CGFloat = 22
    let bar_offset: CGFloat = 110
    
    weak var tableView: UITableView?
    weak var imageHeaderView: UIImageView?
    weak var visualEffectView: UIVisualEffectView?
    //var customTitleView: UIView?
    var originalBackgroundImage: UIImage?
    var blurredImageCache:NSMutableDictionary?
    
    var headerHeight: CGFloat = 100.0
    var subHeaderHeight: CGFloat = 100.0
    var headerSwitchOffset: CGFloat?
    var avatarImageSize: CGFloat = 70
    var avatarImageCompressedSize: CGFloat = 44
    var barIsCollapsed: Bool = false
    var barAnimationComplete: Bool = false
    
    let databaseRef = Database.database().reference()
    let userauth = Auth.auth()
    
    var customTitleView: UIView?
    var user:User?
    var imagePicked:Int = 0
    var avatarImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileInfo()
        self.configureNavBar()
        
        let sharedApplication = UIApplication.shared
        let kStatusBarHeight: CGFloat = sharedApplication.statusBarFrame.size.height
        let kNavBarHeight:CGFloat = self.navigationController!.navigationBar.frame.size.height
        
        /* To compensate  the adjust scroll insets */
        headerSwitchOffset = headerHeight - (kStatusBarHeight + kNavBarHeight)  - kStatusBarHeight - kNavBarHeight
        
        var views = [String:UIView]()
        views["super"] = self.view
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.delegate = self
//        tableView.dataSource = self
        self.tableView = tableView
        self.view.addSubview(tableView)
        views["tableView"] = tableView
        
        let bgImage: UIImage = UIImage(named:"alpes")!
        if originalBackgroundImage == nil {
            originalBackgroundImage = bgImage
        }
        //print(originalBackgroundImage?.cgImage)
        
        let headerImageView = UIImageView()
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        self.imageHeaderView = headerImageView
        imageHeaderView?.tag = 1
        imageHeaderView?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(modifyImageView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        imageHeaderView?.addGestureRecognizer(tapGesture)
        views["headerImageView"] = headerImageView
        
        let tableHeaderView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight - (kStatusBarHeight + kNavBarHeight)+subHeaderHeight))
        tableHeaderView.addSubview(headerImageView)
        
        let subHeaderPart: UIView = self.createSubHeaderView()
        subHeaderPart.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView.insertSubview(subHeaderPart, belowSubview: headerImageView)
        views["subHeaderPart"] = subHeaderPart
        tableView.tableHeaderView = tableHeaderView
        //tableHeaderView.bringSubview(toFront: imageHeaderView!)
        
        avatarImageView = self.createAvatarImage()
        avatarImageView!.tag = 2
        avatarImageView?.isUserInteractionEnabled = true
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(modifyImageView))
        avatarImageView!.addGestureRecognizer(tapGesture)
        avatarImageView!.translatesAutoresizingMaskIntoConstraints = false
        views["avatarImageView"] = avatarImageView
        tableHeaderView.addSubview(avatarImageView!)
        avatarImageView!.layer.zPosition = 5
        //imageHeaderView!.layer.zPosition = 4
        
        
        /*
         * At this point tableHeader views are ordered like this:
         * 0 : subHeaderPart
         * 1 : headerImageView
         * 2 : avatarImageView
         */
        
        /* This is important, or section header will 'overlaps' the navbar */
        //self.automaticallyAdjustsScrollViewInsets = true;
        
        var constraints:[NSLayoutConstraint] = [NSLayoutConstraint]()
        var constraint: NSLayoutConstraint = NSLayoutConstraint()
        var format: String = String()
        let metrics: [String:CGFloat] = [
            "headerHeight": headerHeight - (kStatusBarHeight + kNavBarHeight),
            "minHeaderHeight": kStatusBarHeight + kNavBarHeight,
            "avatarSize": (kStatusBarHeight + kNavBarHeight),
            "avatarCompressedSize": avatarImageCompressedSize,
            "subHeaderHeight": subHeaderHeight
        ]
        
        // ===== Table view should take all available space ========
        
        format = "|-0-[tableView]-0-|"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        self.view.addConstraints(constraints)
        
        format = "V:|-0-[tableView]-0-|"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        self.view.addConstraints(constraints)
        
        // ===== Header image view should take all available width ========
        
        format = "|-0-[headerImageView]-0-|"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        tableHeaderView.addConstraints(constraints)
        
        format = "|-0-[subHeaderPart]-0-|"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        tableHeaderView.addConstraints(constraints)
        
        // ===== Header image view should not be smaller than nav bar and stay below navbar ========
        
        format = "V:[headerImageView(>=minHeaderHeight)]-(subHeaderHeight@750)-|"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        self.view.addConstraints(constraints)
        
        format = "V:|-(headerHeight)-[subHeaderPart(subHeaderHeight)]"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        self.view.addConstraints(constraints)
        
        // ===== Header image view should stick to top of the 'screen'  ========
        
        let magicConstraint: NSLayoutConstraint = NSLayoutConstraint(item: headerImageView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(magicConstraint)
        
        
        // ===== avatar should stick to left with default margin spacing  ========
        format = "|-[avatarImageView]"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        self.view.addConstraints(constraints)
        
        
        // === avatar is square
        
        constraint = NSLayoutConstraint(item: avatarImageView!, attribute: .width, relatedBy: .equal, toItem: avatarImageView, attribute: .height, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(constraint)
        
        
        // ===== avatar size can be between avatarSize and avatarCompressedSize
        format = "V:[avatarImageView(<=avatarSize@760,>=avatarCompressedSize@800)]"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        self.view.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: avatarImageView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .top, multiplier: 1.0, constant: kStatusBarHeight + kNavBarHeight)
        constraint.priority = UILayoutPriority(rawValue: 790)
        self.view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: avatarImageView!, attribute: .bottom, relatedBy: .equal, toItem: subHeaderPart, attribute: .bottom, multiplier: 1.0, constant: -50)
        constraint.priority = UILayoutPriority(rawValue: 801)
        self.view.addConstraint(constraint)
        
        DispatchQueue.global(qos: .default).async {
            self.fillBlurredImageCache()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if self.isViewLoaded && (self.view.window != nil) {
            customTitleView = nil
        }
    }
    
    deinit {
        originalBackgroundImage = nil
        blurredImageCache?.removeAllObjects()
        blurredImageCache = nil
    }
    
    
    @objc func modifyImageView(_ sender:UITapGestureRecognizer){
        print(123)
        //let uid = userauth.currentUser?.uid
        //Storage.storage().reference().child("profileImage").child(uid!)
        //var ut:UITapGestureRecognizer = sender
        print((sender.view?.tag)!)
        imagePicked = (sender.view?.tag)!
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                picker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(picker, animated: true, completion: nil)
            } else {
                print("error no camera")
                let newalert = UIAlertController(title: "No Camera", message: "Please select photo library", preferredStyle: .alert)
                newalert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(newalert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            print("action come to here")
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createBgImage()->UIImageView{
        let bgImageView = UIImageView()
        if let bgimage = user?.headerImageView {
            bgImageView.loadImageUsingCacheWithUrlString(urlString: bgimage)
        }else{
            bgImageView.image = UIImage(named:"vegetation")!
        }
        return bgImageView
    }
    
    func getProfileInfo(){
        if let dict = UserDefaults.standard.object(forKey: "user") as? [String: AnyObject] {
            //print("i guess")
            user = User(dict: dict)
        } else {
            let uid = userauth.currentUser?.uid
            let data = databaseRef.child("users").child(uid!)
            data.observeSingleEvent(of: .value) { (snapshot) in
                if let dicts  = snapshot.value as? [String:AnyObject] {
                    print(dicts)
                    self.user = User(dict: dicts)
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "item \(indexPath.row+1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        let items:[String] = ["Posts", "Photos", "Favorites"]
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        var views = [String:UIView]()
        views["super"] = self.view
        sectionView.addSubview(segmentedControl)
        sectionView.backgroundColor = UIColor.white
        
        segmentedControl.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor).isActive = true
        sectionView.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: sectionView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
        sectionView.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: sectionView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.lightGray
        sectionView.addSubview(separator)
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[separator]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["separator": separator]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[separator(0.5)]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["separator": separator]))
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    func configureNavBar() {
        self.view.backgroundColor = UIColor.blue
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        self.switchToExpandedHeader()
    }
    
    func switchToExpandedHeader(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.titleView = nil;
        //    if(self.visualEffectView){
        //        [self.visualEffectView removeFromSuperview];
        //        self.visualEffectView = nil;
        //    }
        
        barAnimationComplete = false
        self.imageHeaderView?.image = self.originalBackgroundImage
        //        self.imageHeaderView = self.createBgImage()
        //        self.originalBackgroundImage = self.imageHeaderView?.image
        self.tableView?.tableHeaderView?.exchangeSubview(at: 1, withSubviewAt: 2)
    }
    
    func switchToMinifiedHeader(){
        barAnimationComplete = false
        //self.navigationItem.titleView = self.customTitleViewFunc()
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(60, for: .default)
        self.tableView?.tableHeaderView?.exchangeSubview(at: 1, withSubviewAt: 2)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPos: CGFloat = scrollView.contentOffset.y
        if yPos > headerSwitchOffset! && !barIsCollapsed {
            self.switchToMinifiedHeader()
            barIsCollapsed = true
        } else {
            self.switchToExpandedHeader()
            barIsCollapsed = false
        }
        
        if yPos > headerSwitchOffset! + 20 && yPos <= headerSwitchOffset! + 20 + 40 {
            let delta: CGFloat = 40 + 20 - (yPos - headerSwitchOffset!)
            self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(delta, for: .default)
            self.imageHeaderView?.image = self.blurWithImageAt(percent: (60-delta)/60.0)
        }
        
        if !barAnimationComplete && yPos > headerSwitchOffset! + 20 + 40 {
            self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
            self.imageHeaderView?.image = self.blurWithImageAt(percent: 1.0)
            barAnimationComplete = true
        }
    }
    
    
    func createAvatarImage() -> UIImageView {
        var avatarView = UIImageView()
        if let imageURL = user?.profileImage {
            avatarView.loadImageUsingCacheWithUrlString(urlString: imageURL)
        }else {
            avatarView = UIImageView(image: UIImage(named:"avatar"))
        }
        avatarView.contentMode = .scaleToFill
        avatarView.layer.cornerRadius = 8.0
        avatarView.layer.borderWidth = 3.0
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.clipsToBounds = true
        return avatarView
    }
    
    
    func customTitleViewFunc() -> UIView {
        if !(customTitleView != nil) {
            let myLabel:UILabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            if let name = user?.name {
                myLabel.text = name
            }else {
                myLabel.text = "My Name"
            }
            myLabel.numberOfLines = 1
            
            myLabel.textColor = UIColor.white
            myLabel.font = UIFont.boldSystemFont(ofSize: 15)
            
            //            let smallText = UILabel()
            //            smallText.translatesAutoresizingMaskIntoConstraints = false
            //            smallText.text = ""
            //            smallText.numberOfLines = 1
            //            smallText.textColor = UIColor.white
            //            smallText.font = UIFont.boldSystemFont(ofSize: 10)
            let wrapper = UIView()
            wrapper.addSubview(myLabel)
            //           wrapper.addSubview(smallText)
            //            wrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":myLabel,"v1":smallText]))
            //            wrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-2-[v1]-0-|", options: .alignAllCenterX, metrics: nil, views: ["v0":myLabel,"v1":smallText]))
            
            wrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":myLabel]))
            wrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: .alignAllCenterX, metrics: nil, views: ["v0":myLabel]))
            
            //            wrapper.frame = CGRect(x: 0, y: 0, width: max(myLabel.intrinsicContentSize.width+6,smallText.intrinsicContentSize.width+6), height: myLabel.intrinsicContentSize.height+smallText.intrinsicContentSize.height+2)
            wrapper.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
            
            wrapper.clipsToBounds = true
            
            customTitleView  = wrapper;
        }
        return customTitleView!
    }
    
    func createSubHeaderView()->UIView{
        let view = UIView()
        var views = [String: UIView]()
        views["super"] = self.view
        let followButton = UIButton(type: .roundedRect)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setTitle("Clock", for: .normal)
        followButton.addTarget(self, action: #selector(clockWorkingTime), for: .touchUpInside)
        followButton.layer.cornerRadius = 2
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.blue.cgColor
        views["followButton"] = followButton
        view.addSubview(followButton)
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = user?.name ?? "Undefined"
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        views["nameLabel"] = nameLabel
        view.addSubview(nameLabel)
        
        
        var constraints = [NSLayoutConstraint]()
        var format:String?
        //NSDictionary* metrics;
        
        format = "[followButton(80)]-|"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format!, options: NSLayoutFormatOptions(), metrics: nil, views: views)
        view.addConstraints(constraints)
        
        format = "|-12-[nameLabel]"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format!, options: NSLayoutFormatOptions(), metrics: nil, views: views)
        view.addConstraints(constraints)
        
        format = "V:|-[followButton]"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format!, options: NSLayoutFormatOptions(), metrics: nil, views: views)
        view.addConstraints(constraints)
        
        format = "V:|-60-[nameLabel]";
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format!, options: NSLayoutFormatOptions(), metrics: nil, views: views)
        view.addConstraints(constraints)
        
        return view;
    }
    
    @objc func clockWorkingTime(){
        
    }
    
    func blurWithImageAt(percent: CGFloat)-> UIImage {
        var keyNumber:NSNumber = 0
        if percent <= 0.1 {
            keyNumber = 1
        } else if percent <= 0.2 {
            keyNumber = 2
        } else if percent <= 0.3 {
            keyNumber = 3
        } else if percent <= 0.4 {
            keyNumber = 4
        } else if percent <= 0.5 {
            keyNumber = 5
        } else if percent <= 0.6 {
            keyNumber = 6
        } else if percent <= 0.7 {
            keyNumber = 7
        } else if percent <= 0.8 {
            keyNumber = 8
        } else if percent <= 0.9 {
            keyNumber = 9
        } else if percent <= 1 {
            keyNumber = 10
        }
        
        if let image = blurredImageCache?.object(forKey: keyNumber) as? UIImage {
            return image
        } else {
            return originalBackgroundImage!
        }
    }
    
    func blurWithImageEffects(image:UIImage, radius: CGFloat) -> UIImage {
        return image.applyBlur(withRadius: radius, tintColor: UIColor.init(white: 1, alpha: 0.2), saturationDeltaFactor: 1.5, maskImage: nil)
    }
    
    func fillBlurredImageCache(){
        let maxBlur:CGFloat = 30;
        self.blurredImageCache = NSMutableDictionary()
        //        self.blurredImageCache![NSNumber.init(value: 1)] = self.blurWithImageEffects(image: originalBackgroundImage!, radius: (maxBlur * CGFloat(1)/10.0))
        for i in 0...10 {
            self.blurredImageCache![NSNumber.init(value: i)] = self.blurWithImageEffects(image: originalBackgroundImage!, radius: (maxBlur * CGFloat(i)/10.0))
        }
    }

}

extension PViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            if imagePicked == 1 {
                imageHeaderView?.image = selectedImage
                originalBackgroundImage = selectedImage
            }else if imagePicked == 2 {
                avatarImageView?.image = selectedImage
            }
            uploadImage(upImage: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(upImage:UIImage){
        let preref = Storage.storage().reference(forURL: "gs://trestest-925a4.appspot.com")
        var ref: StorageReference?
        if imagePicked == 1 {
            ref = preref.child("headerImageView")
        }else if imagePicked == 2 {
            ref = preref.child("profileImage")
        }
        let uid = Auth.auth().currentUser?.uid
        let dataref = Database.database().reference()
        let userRef = dataref.child("users").child(uid!)
        let imagename = NSUUID().uuidString
        if let uploadData = UIImageJPEGRepresentation(upImage, 0.1) {
            ref?.child(uid!).child("\(imagename).jpg").putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                if let s = metadata?.downloadURL()?.absoluteString{
                    var keyval = [String:String]()
                    if var dict = UserDefaults.standard.object(forKey: "user") as? [String: AnyObject]{
                        if self.imagePicked == 1 {
                            keyval = ["headerImage": s]
                            dict["headerImage"] = s as AnyObject
                        } else if self.imagePicked == 2 {
                            keyval = ["imageURL": s]
                            dict["imageURL"] = s as AnyObject
                        }
                        UserDefaults.standard.set(dict, forKey: "user")
                    }
                    userRef.updateChildValues(keyval)
                }
            })
        }
    }
}

