//
//  User.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/5/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import Foundation

class User:NSObject {
    var email: String?
    var name: String?
    var phonenumber:String?
    var profileImage:String?
    var id:String?
    var headerImageView: String?
    
    init(dict:[String:AnyObject]) {
        super.init()
        self.profileImage = dict["imageURL"] as? String
        self.email = dict["email"] as? String
        self.name = dict["name"] as? String
        self.phonenumber = dict["phonenumber"] as? String
        self.headerImageView = dict["headerImage"] as? String
    }
    
    override init(){
        super.init()
    }
}
