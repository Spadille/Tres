////
////  GlobalUser.swift
////  TresPoint
////
////  Created by Shiyu Zhang on 11/27/17.
////  Copyright © 2017 Shiyu Zhang. All rights reserved.
////
//
//import Foundation
//
//class GlobalUser:NSObject {
//    static var user = User()
//    
//    static let sharedSingleton : GlobalUser = {
//        let instance = GlobalUser()
//        return instance
//    }()
//    
//    override private init() {
//        
//        super.init()
//        
//    }
//    
//    func saveSettings()
//    {
//        let userDefaults = UserDefaults.standard
//        
//        if((GlobalUser.user) != nil)
//        {
//            userDefaults.set(GlobalUser.user, forKey: "user")
//        }
//        userDefaults.synchronize()
//    }
//}

