//
//  RemoteStore.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/3/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import Foundation
import CoreData

protocol RemoteStore {
    func signUp(username:String,phoneNumber: String, email:String, password:String, success:@escaping ()->(),  error errorCallback: @escaping(_ errorMessage:String)->())
    func startSyncing()
    func store(inserted: [NSManagedObject], updated: [NSManagedObject],deleted:[NSManagedObject])
    func signin(email:String,password:String,success:@escaping ()->(), error errorCallBack: @escaping (_ errorMessage:String)->())
}
