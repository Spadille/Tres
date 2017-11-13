//
//  FirebaseStore.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/3/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirebaseStore {
    private let context: NSManagedObjectContext
    private var dataRef: DatabaseReference = Database.database().reference()
    private var rootRef = Auth.auth()
    
    init(context:NSManagedObjectContext){
        self.context = context
    }
    
    func hasAuth() -> Bool {
        return rootRef.currentUser != nil
    }
    
    fileprivate func upload(model: NSManagedObject){
        guard let model = model as? FirebaseModel else {return}
        model.upload(dataRef: dataRef,rootRef: rootRef, context: context)
    }
    
}


//extension FirebaseStore: RemoteStore {
//
//    func startSyncing() {
//        context.perform {
//            self.observeStatus()
//        }
//    }
//
//    func signin(email: String, password: String, success: @escaping () -> (), error errorCallBack: @escaping (_ errorMessage: String) -> ()) {
//        rootRef.signIn(withEmail: email, password: password) { (user, error) in
//            if error != nil {
//                errorCallBack(error.debugDescription)
//            }else{
//                success()
//            }
//        }
//    }
//
//    func store(inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
//        inserted.forEach(upload)
//        do{
//            try context.save()
//        } catch {
//            print("error saving")
//        }
//    }
//
//    func signUp(username: String, phoneNumber: String, email: String, password: String, success: @escaping () -> (), error errorCallback: @escaping (_ errorMessage: String) -> ()) {
//        rootRef.createUser(withEmail: email, password: password) { (user, error) in
//            if error != nil {
//                errorCallback(error.debugDescription)
//            }else {
//                let newUser = ["phoneNumber":phoneNumber, "username": username, "email": email]
//                FirebaseStore.currentPhoneNumber = phoneNumber
//                let uid = user?.uid
//                self.dataRef.child("users").child(uid!).setValue(newUser)
//                self.rootRef.signIn(withEmail: email, password: password, completion: { (user, error) in
//                    if error != nil {
//                        errorCallback(error.debugDescription)
//                    }else {
//                        success()
//                    }
//                })
//            }
//        }
//    }
//}

