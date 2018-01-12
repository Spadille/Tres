//
//  BlogCell.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/14/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit

class BlogCell: UICollectionViewCell {
    var id:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var post:Post? {
        didSet{
            setPostImage()
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        //label.text = "Sample Name"
        label.numberOfLines = 2
        let attributedText = NSMutableAttributedString(string: "SampleName", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "\nNovmber 18 • New Jersey ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.count))
        label.attributedText = attributedText
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named:"contact")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.text = "this is a text"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let statusImage: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named:"tempurl")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let likeCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "400Likes"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 155, green: 161, blue: 171)
        return label
    }()
    
    let CommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "100 Comments"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 155, green: 161, blue: 171)
        return label
    }()
    
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 226, green: 228, blue: 232)
        return view
    }()
    
    func setPostImage(){
        if let name = post?.name, let status = post?.statusText, let ts = post?.timeStamp {
            //cell.nameLabel.text = name
            statusTextView.text = status
            if let seconds = Double(ts) {
                //print(seconds)
                setNameTimeAndLocation(name: name, seconds: seconds)
            }
        }else {
            statusTextView.text = "???"
        }
        
        if let commentsCountNum = post?.numComments, let likeCount = post?.numLikes {
            likeCommentsLabel.text = "\(likeCount) Likes"
            CommentsLabel.text = "\(commentsCountNum) Comments"
        }
        
        //print(post.statusText)
        if let profileImageName = post?.profileImage {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageName)
        }
        
        if let imageurl = post?.statusImageView {
            resetBlogCell(imageurl: imageurl)
        }
    }
    
    private func setNameTimeAndLocation(name:String,seconds:Double){
        nameLabel.numberOfLines = 2
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        let time = Date(timeIntervalSince1970: seconds)
        let timestamp = "    \(dateFormatter.string(from: time))"
        //nameLabel.attributedText = NSAttributedString(string: timestamp)
        let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: timestamp, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.count))
        nameLabel.attributedText = attributedText
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private func resetBlogCell(imageurl: String){
        statusImage.loadImageUsingCacheWithUrlString(urlString: imageurl)
        addSubview(statusImage)
        removeConstraints(constraints)
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView,nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|-12-[v0]-6-[v1]|", views: likeCommentsLabel,CommentsLabel)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        addConstraintsWithFormat(format: "H:|[v0(v1)][v1(v2)][v2]|", views: likeButton,commentButton,shareButton)
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImage)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-4-[v4(0.4)]-4-[v5(44)]|", views: profileImageView,statusTextView,statusImage, likeCommentsLabel,dividerLineView,likeButton)
        //addConstraintsWithFormat(format: "V:[v0(24)]", views: likeCommentsLabel)
        addConstraintsWithFormat(format: "V:[v0]-8-[v1(24)]", views: statusImage,CommentsLabel)
    }
    

    
    static func buttonForTitle(title:String, imageName: String) ->UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 143, green: 150, blue: 163), for: .normal)
        let image = UIImage(named:imageName)
        button.setImage(image, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return button
    }
    
    static func buttonForTitles(title:String, imageName: String,firstSelector:(_ button:UIButton)->()) ->UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 143, green: 150, blue: 163), for: .normal)
        let image = UIImage(named:imageName)
        button.setImage(image, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        button.isUserInteractionEnabled = true
//        button.isEnabled = true
        firstSelector(button)
        return button
    }
    
//    lazy var likeButton = BlogCell.buttonForTitles(title: "Like", imageName: "add_pressed") { (bu) in
//        bu.addTarget(self, action: #selector(addLike), for: .touchUpInside)
//    }
    
    let likeButton = BlogCell.buttonForTitle(title:"Like",imageName:"like")
    let commentButton = BlogCell.buttonForTitle(title: "Comment", imageName: "talks")
    
//    lazy var commentButton = BlogCell.buttonForTitles(title: "Comment", imageName: "add_pressed"){ (bu) in
//        bu.addTarget(self, action: #selector(addComment), for: .touchUpInside)
//    }
    
    let shareButton = BlogCell.buttonForTitle(title: "Share", imageName: "shares")
    
    
    override func layoutIfNeeded() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    
    
    func setupView(){
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(likeCommentsLabel)
        addSubview(dividerLineView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        addSubview(CommentsLabel)
        
//        if statusImage.image != nil  {
//            //statusImage.loadImageUsingCacheWithUrlString(urlString: imageurl)
//            addSubview(statusImage)
//            let constraint_add = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-4-[v4(1)]-4-[v5(44)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":profileImageView,"v1":statusTextView,"v2":statusImage, "v3":likeCommentsLabel, "v4":dividerLineView, "v5":likeButton])
//            addConstraints(constraint_add)
//            addConstraintsWithFormat(format: "H:|[v0]|", views: statusImage)
//        }else {
//            statusImage.frame = CGRect.zero
//            statusImage.heightAnchor.constraint(equalToConstant: 0)
//            //willRemoveSubview(cell.statusImage)
//            let constraint_add = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(44)]-4-[v1]-4-[v2(24)]-4-[v3(0.4)]-4-[v4(44)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":profileImageView,"v1":statusTextView, "v2":likeCommentsLabel, "v3":dividerLineView, "v4":likeButton])
//            addConstraints(constraint_add)
//        }
//
        statusImage.frame = CGRect.zero
        statusImage.heightAnchor.constraint(equalToConstant: 0)
        //willRemoveSubview(cell.statusImage)
//        let constraint_add = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(44)]-4-[v1]-4-[v2(24)]-4-[v3(0.4)]-4-[v4(44)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":profileImageView,"v1":statusTextView, "v2":likeCommentsLabel, "v3":dividerLineView, "v4":likeButton])
//        addConstraints(constraint_add)
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView,nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|-12-[v0]-6-[v1]|", views: likeCommentsLabel,CommentsLabel)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        addConstraintsWithFormat(format: "H:|[v0(v1)][v1(v2)][v2]|", views: likeButton,commentButton,shareButton)
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(24)]-4-[v3(0.4)]-4-[v4(44)]|", views: profileImageView,statusTextView, likeCommentsLabel, dividerLineView, likeButton)
//        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-4-[v4(0.4)]-4-[v5(44)]|", views: profileImageView,statusTextView,statusImage,likeCommentsLabel,dividerLineView,likeButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
        addConstraintsWithFormat(format: "V:[v0]-4-[v1(24)]", views:statusTextView,CommentsLabel)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String,views:UIView...){
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

//class subclassUIButton:UIButton {
//    var isClicked: Bool?
//    var id: String?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}

