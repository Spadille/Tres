//
//  BlogCell.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/14/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit

class BlogCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        imageView.backgroundColor = UIColor.red
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
        imageView.image = UIImage(named:"messi")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let likeCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "400Likes   100 Comments"
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
    
    let likeButton = BlogCell.buttonForTitle(title:"Like",imageName:"add_pressed")
    let commentButton = BlogCell.buttonForTitle(title: "Comment", imageName: "add_pressed")
    let shareButton = BlogCell.buttonForTitle(title: "Share", imageName: "add_pressed")
    
    func setupView(){
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImage)
        addSubview(likeCommentsLabel)
        addSubview(dividerLineView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView,nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImage)
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: likeCommentsLabel)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        addConstraintsWithFormat(format: "H:|[v0(v1)][v1(v2)][v2]|", views: likeButton,commentButton,shareButton)
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-4-[v4(0.4)]-4-[v5(44)]|", views: profileImageView,statusTextView,statusImage,likeCommentsLabel,dividerLineView,likeButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
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
