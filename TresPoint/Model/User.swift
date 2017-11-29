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
    var isWorking: String?
    var startWorkingTime:String?
    var totalWorkingTime:String?
    var workingTimeTotal:[String:String]?
    
    init(dict:[String:AnyObject]) {
        super.init()
        self.profileImage = dict["imageURL"] as? String
        self.email = dict["email"] as? String
        self.name = dict["name"] as? String
        self.phonenumber = dict["phonenumber"] as? String
        self.headerImageView = dict["headerImage"] as? String
        self.isWorking = dict["isWorking"] as? String
        self.startWorkingTime = dict["startWorkingTime"] as? String
        self.totalWorkingTime = dict["totalWorkingTime"] as? String
        self.workingTimeTotal = dict["workingTimeTotal"] as? [String:String]
    }
    
    override init(){
        super.init()
    }
}
