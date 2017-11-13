//
//  FirebaseModel.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/3/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseModel {
    func upload(dataRef:DatabaseReference, rootRef:Auth,context:NSManagedObjectContext)
    func download(dataRef:DatabaseReference,rootRef:Auth,context:NSManagedObjectContext)
}
