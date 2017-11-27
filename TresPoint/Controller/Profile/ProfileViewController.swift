//
//  ProfileViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/6/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let min_header: CGFloat = 22
    let bar_offset: CGFloat = 110
    
    weak var tableView: UITableView?
    weak var imageHeaderView: UIImageView?
    weak var visualEffectView: UIVisualEffectView?
    var customTitleView: UIView?
    var originalBackgroundImage: UIImage?
    var blurredImageCache: NSMutableDictionary?
    
    var headerHeight: CGFloat = 100.0
    var subHeaderHeight: CGFloat = 100.0
    var headerSwitchOffset: CGFloat?
    var avatarImageSize: CGFloat = 70
    var avatarImageCompressedSize: CGFloat = 44
    var barIsCollapsed: Bool = false
    var barAnimationComplete: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
        self.view.addSubview(tableView)
        views["tableView"] = tableView
        
        let bgImage: UIImage = UIImage(named:"vegetation")!
        originalBackgroundImage = bgImage
        //print(originalBackgroundImage?.cgImage)
        
        let headerImageView = UIImageView()
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        self.imageHeaderView = headerImageView
        views["headerImageView"] = headerImageView
        
        let tableHeaderView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight - (kStatusBarHeight + kNavBarHeight)+subHeaderHeight))
        tableHeaderView.addSubview(headerImageView)
        
        let subHeaderPart: UIView = self.createSubHeaderView()
        subHeaderPart.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView.insertSubview(subHeaderPart, belowSubview: headerImageView)
        views["subHeaderPart"] = subHeaderPart
        tableView.tableHeaderView = tableHeaderView
        
        let avatarImageView: UIImageView = self.createAvatarImage()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        views["avatarImageView"] = avatarImageView
        tableHeaderView.addSubview(avatarImageView)
        
        
        
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
        
        constraint = NSLayoutConstraint(item: avatarImageView, attribute: .width, relatedBy: .equal, toItem: avatarImageView, attribute: .height, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(constraint)
        
        
        // ===== avatar size can be between avatarSize and avatarCompressedSize
        format = "V:[avatarImageView(<=avatarSize@760,>=avatarCompressedSize@800)]"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        self.view.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: avatarImageView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .top, multiplier: 1.0, constant: kStatusBarHeight + kNavBarHeight)
        constraint.priority = UILayoutPriority(rawValue: 790)
        self.view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: avatarImageView, attribute: .bottom, relatedBy: .equal, toItem: subHeaderPart, attribute: .bottom, multiplier: 1.0, constant: -50)
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
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 25
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "item \(indexPath.row+1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        let items:[String] = ["Tweets", "Photos", "Favorites"]
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        var views = [String:UIView]()
        views["super"] = self.view
        sectionView.addSubview(segmentedControl)
        sectionView.backgroundColor = UIColor.white
        
        segmentedControl.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor)
        segmentedControl.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor)
        
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
        
        barAnimationComplete = false;
        self.imageHeaderView?.image = self.originalBackgroundImage
        self.tableView?.tableHeaderView?.exchangeSubview(at: 1, withSubviewAt: 2)
    }
    
    func switchToMinifiedHeader(){
        barAnimationComplete = false
        self.navigationItem.titleView = self.customTitleView
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
            
            //self.imageHeaderView.image = [self blurWithImageAt:((60-delta)/60.0)];
        }
        
        if !barAnimationComplete && yPos > headerSwitchOffset! + 20 + 40 {
            self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
            //self.imageHeaderView.image = [self blurWithImageAt:1.0];
            barAnimationComplete = true;
        }
    }
    
    
    func createAvatarImage() -> UIImageView {
        let avatarView: UIImageView = UIImageView(image: UIImage(named:"avatar"))
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
            myLabel.text = "My handle"
            myLabel.numberOfLines = 1
            
            myLabel.textColor = UIColor.white
            myLabel.font = UIFont.boldSystemFont(ofSize: 15)
            
            let smallText = UILabel()
            smallText.translatesAutoresizingMaskIntoConstraints = false
            smallText.text = "2 666 Tweets"
            smallText.numberOfLines = 1
            smallText.textColor = UIColor.white
            smallText.font = UIFont.boldSystemFont(ofSize: 10)
            let wrapper = UIView()
            wrapper.addSubview(myLabel)
            wrapper.addSubview(smallText)
            wrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[myLabel]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["smallText":smallText]))
            wrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[myLabel]-2-[smallText]-0-|", options: .alignAllCenterX, metrics: nil, views: ["smallText":smallText]))
            
            wrapper.frame =             CGRect(x: 0, y: 0, width: max(myLabel.intrinsicContentSize.width,smallText.intrinsicContentSize.width), height: myLabel.intrinsicContentSize.height+smallText.intrinsicContentSize.height+2)
            
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
        followButton.setTitle("Follow", for: .normal)
        followButton.layer.cornerRadius = 2
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.blue.cgColor
        views["followButton"] = followButton
        view.addSubview(followButton)
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "My Display Name"
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        views["nameLabel"] = nameLabel
        view.addSubview(nameLabel)
        
        
        var constraints = [NSLayoutConstraint]()
        var format:String?
        //NSDictionary* metrics;
        
        format = "[followButton]-|"
        constraints = NSLayoutConstraint.constraints(withVisualFormat: format!, options: NSLayoutFormatOptions(), metrics: nil, views: views)
        view.addConstraints(constraints)
        
        format = "|-[nameLabel]"
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
        self.blurredImageCache = [NSNumber:UIImage]() as? NSMutableDictionary
//        self.blurredImageCache![NSNumber.init(value: 1)] = self.blurWithImageEffects(image: originalBackgroundImage!, radius: maxBlur * CGFloat(1)/10.0))
//        for i in 1...10 {
//            self.blurredImageCache![NSNumber.init(value: i)] = self.blurWithImageEffects(image: originalBackgroundImage!, radius: maxBlur * CGFloat(i)/10.0)
//        }
    }
}

