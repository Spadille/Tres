//
//  TempProfileViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/7/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase

class TempProfileViewController: UIViewController {
    
    lazy var imageProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "messi")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImage)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupImageView()
    }
    
    func findProfileImage(){
        let uid = Auth.auth().currentUser?.uid
        //let dataref = Database.database().reference().child("users").child(uid!)
//        dataref.observeSingleEvent(of: .value) { (snapshot) in
//            if let value = snapshot.value as? [String:AnyObject]{
//                if let imageURL = value["imageURL"] {
//                    
//                }
//            }
//        }
    }
    
    func setupImageView() {
        view.addSubview(imageProfile)
        let constraints: [NSLayoutConstraint] = [
            imageProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageProfile.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageProfile.heightAnchor.constraint(equalToConstant: 100),
            imageProfile.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
