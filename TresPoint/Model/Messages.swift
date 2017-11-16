//
//  Messages.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/9/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import FirebaseAuth

class Messages:NSObject {
    var fromId: String?
    var text: String?
    var timestamp: String?
    var toId: String?
    var imageUrl:String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    var videoUrl:String?
    
    func chatPartnerId() -> String? {
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        }else {
            return fromId
        }
    }
    
    init(dict:[String:AnyObject]){
        super.init()
        self.fromId = dict["fromId"] as? String
        self.text = dict["text"] as? String
        self.timestamp = dict["timeStamp"] as? String
        self.toId = dict["toId"] as? String
        self.imageWidth = dict["imageWidth"] as? NSNumber
        self.imageHeight = dict["imageHeight"] as? NSNumber
        self.imageUrl = dict["imageUrl"] as? String
        self.videoUrl = dict["videoUrl"] as? String
    }
}
