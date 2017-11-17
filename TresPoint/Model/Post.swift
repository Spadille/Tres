//
//  Posts.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/14/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import Foundation


class Post: NSObject{
    var name:String?
    var statusText: String?
    var profileImage: String?
    var statusImageView: String?
    var numLikes: String?
    var numComments: String?
    var comments:[String]?
    var timeStamp: String?
    var id: String?
    var isLiked: String?
    
    init(dict:[String:String]) {
        super.init()
        self.name = dict["name"]
        self.statusText = dict["statusText"]
        self.statusImageView = dict["statusImage"]
        self.numLikes = dict["numLikes"]
        self.numComments = dict["numComments"]
        self.timeStamp = dict["timestamp"]
        self.profileImage = dict["profileImage"]
        self.id = dict["id"]
        self.isLiked = dict["isLiked"]
    }
    
    override init(){
        super.init()
    }
}
