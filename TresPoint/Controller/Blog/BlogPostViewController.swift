//
//  BlogPostViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/6/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase

class BlogPostViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: 0xE5E6E7)
        navigationItem.title = "TresPoint News"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"add_pressed"), style: .plain, target: self, action: #selector(goToPost))
        setupIcon()
        setupTabView()
        observeDataFromFirebase()
    }
    
    @objc func goToPost(){
        let pv = PostViewController()
        self.present(pv, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh),for: .valueChanged)
        refreshControl.tintColor = infoColor.colorSmoothRed
        return refreshControl
    }()
    
    @objc func handleRefresh(){
        posts.removeAll()
        tabView.reloadData()
        observeDataFromFirebase()
        //self.tabView.reloadData()
        refreshControl.endRefreshing()
    }
    
    let cellId = "BlogCell"
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let statusText = posts[indexPath.item].statusText {
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: tabView.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)], context: nil)
            let image = posts[indexPath.item].statusImageView
            var knownheight:CGFloat = 8+44+4+4+200+8+24+8+44+32
            if image == nil {
                knownheight -= 200
            }
            return CGSize(width: tabView.frame.width, height: rect.height + knownheight)
        }
        return CGSize(width: tabView.frame.width, height: 500)
    }
    
    let icon:UIImageView = {
        let ic = UIImageView()
        ic.image = UIImage(named:"TresPointLogin")
        ic.contentMode = .scaleAspectFill
        ic.translatesAutoresizingMaskIntoConstraints = false
        return ic
    }()
    
    let tabView: UICollectionView = {
        let tab = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.backgroundColor = UIColor(rgb: 0xE5E6E7)
        //tab.layer.borderColor = UIColor.white.cgColor
        //tab.layer.borderWidth = 1
        //tab.layer.cornerRadius = 16
        //tab.layer.masksToBounds = true
        return tab
    }()
    
    func setupIcon(){
        self.view.addSubview(icon)
        let constraints: [NSLayoutConstraint] = [
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            icon.widthAnchor.constraint(equalToConstant: 100),
            icon.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupTabView(){
        self.view.addSubview(tabView)
        tabView.alwaysBounceVertical = true
        tabView.register(BlogCell.self, forCellWithReuseIdentifier: cellId)
        tabView.delegate = self
        tabView.dataSource = self
        tabView.showsVerticalScrollIndicator = false
        tabView.addSubview(refreshControl)
        let constraints:[NSLayoutConstraint] = [
            tabView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            tabView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            //tabView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabView.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension BlogPostViewController: UICollectionViewDelegate{
    
}

extension BlogPostViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tabView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BlogCell
        let post = posts[indexPath.row]
        cell.post = post
//        if let bt = cell.likeButton as? subclassUIButton {
//            bt.id =
//        }
//        cell.likeButton.addTarget(self, action: #selector(addLike), for: .touchUpInside)
//        cell.commentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        return cell
    }
    
//    @objc func addLike(_ sender: subclassUIButton){
//        if let id = sender.id{
//            let dataref = Database.database().reference().child("Posts").child(id)
//            dataref.observeSingleEvent(of: .value, with: { (snapshot) in
//                if let dict = snapshot.value as? [String:String] {
//                    var likeCount = Int(dict["numLikes"]!)!
//                    likeCount += 1
//                    let properties:[String:String] = ["numLikes":"\(likeCount)"]
//                    dataref.updateChildValues(properties, withCompletionBlock: { (error, dataref) in
//                        if error != nil {
//                            print(error.debugDescription)
//                        }
//                    })
//                }
//            })
//        }
//    }

    @objc func addComment(){
       // print(456)
    }
    

    
    private func setNameTimeAndLocation(cell:BlogCell,name:String,seconds:Double){
        cell.nameLabel.numberOfLines = 2
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let time = Date(timeIntervalSince1970: seconds)
        let timestamp = dateFormatter.string(from: time)
        //cell.nameLabel.attributedText = NSAttributedString(string: timestamp)
        let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: timestamp, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.count))
        cell.nameLabel.attributedText = attributedText
        cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private func resetBlogCell(cell:BlogCell, imageurl: String){
        cell.statusImage.loadImageUsingCacheWithUrlString(urlString: imageurl)
        cell.addSubview(cell.statusImage)
        cell.removeConstraints(cell.constraints)
        cell.addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: cell.profileImageView,cell.nameLabel)
        cell.addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: cell.statusTextView)
        cell.addConstraintsWithFormat(format: "H:|-12-[v0]|", views: cell.likeCommentsLabel)
        cell.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: cell.dividerLineView)
        cell.addConstraintsWithFormat(format: "H:|[v0(v1)][v1(v2)][v2]|", views: cell.likeButton,cell.commentButton,cell.shareButton)
        cell.addConstraintsWithFormat(format: "V:|-12-[v0]", views: cell.nameLabel)
        cell.addConstraintsWithFormat(format: "V:[v0(44)]|", views: cell.commentButton)
        cell.addConstraintsWithFormat(format: "V:[v0(44)]|", views: cell.shareButton)
        cell.addConstraintsWithFormat(format: "H:|[v0]|", views: cell.statusImage)
        cell.addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-4-[v4(0.4)]-4-[v5(44)]|", views: cell.profileImageView,cell.statusTextView,cell.statusImage,cell.likeCommentsLabel,cell.dividerLineView,cell.likeButton)
    }
    
    private func observeDataFromFirebase(){
        posts.removeAll()
        let dataRef = Database.database().reference().child("Posts").queryLimited(toFirst: 20)
        dataRef.observeSingleEvent(of: .value) { (snapshot) in
            if let val = snapshot.value as? [String:[String:String]]{
                for value in val.values {
                    //print(value)
                    let post = Post(dict: value)
                    if post.statusImageView == "tempurl" {
                        post.statusImageView = nil
                    }
                    //print(post.statusImageView)
                    self.posts.append(post)
                    self.posts.sort(by: { (post1, post2) -> Bool in
                        let p1 = post1.timeStamp
                        let p2 = post2.timeStamp
                        return Double(p1!)! > Double(p2!)!
                    })
                    DispatchQueue.main.async {
                        self.tabView.reloadData()
                    }
                }
            }
        }
    }
    
}
