//
//  UserCell.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/9/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 56, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 56, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    var message: Messages? {
        didSet{
            setimageAndNameProfile()
        }
    }
    
    
    private func setimageAndNameProfile(){
        let chatPartnerId: String?
        
        if message?.fromId! == Auth.auth().currentUser?.uid {
            chatPartnerId = message?.toId
        }else {
            chatPartnerId = message?.fromId
        }
        
        if let id = chatPartnerId {
            Database.database().reference().child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject] {
                    self.textLabel?.text = dict["name"] as? String
                    if let profileImage = dict["imageURL"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImage)
                    }
                }
            })
        }
        detailTextLabel?.text = message?.text
        let ts = message?.timestamp
        if let seconds = Double(ts!) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            let time = Date(timeIntervalSince1970: seconds)
            timeLabel.text = dateFormatter.string(from: time)
        }
    }
    
    let timeLabel: UILabel = {
        let tl = UILabel()
        //tl.text = "HH:MM:SS"
        tl.font = UIFont.systemFont(ofSize: 12)
        tl.textColor = UIColor.darkGray
        tl.translatesAutoresizingMaskIntoConstraints = false
        return tl
    }()
    
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named:"messi")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
