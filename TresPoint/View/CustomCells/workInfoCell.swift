//
//  workInfo.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/30/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import Foundation
import Firebase

class workInfoCell:UITableViewCell{
    
    var work: WorkInfo? {
        didSet {
            setWorkInfo()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 56, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 56, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
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
        imageView.backgroundColor = UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.layer.cornerRadius = 20
        //imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(timeLabel)
        addSubview(profileImageView)
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
    
    
    func setWorkInfo(){
        
        if let timestamp = work?.timestamp {
            let ts = work?.timestamp
            if let seconds = Double(ts!) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                let time = Date(timeIntervalSince1970: seconds)
                timeLabel.text = dateFormatter.string(from: time)
            }
        }
        
        if let isworking = work?.isworking, let totalTime = work?.totalTime {
            if isworking == "true" {
                textLabel?.text = "Start Working"
            } else {
                if let tempTime = Int(totalTime) {
                    let finalString = timeString(time: TimeInterval(tempTime))
                    textLabel?.text = "End Working, worked \(finalString)"
                }else {
                    textLabel?.text = "End Working"
                }
            }
        }
        
        if let workdetail = work?.workDetail {
            detailTextLabel?.text = workdetail
        }
    }
    
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
}
