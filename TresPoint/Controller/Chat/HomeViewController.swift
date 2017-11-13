//
//  ViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/3/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //let n = UINavigationController(rootViewController: self)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
        let image = UIImage(named: "add_pressed")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessages))
        // Do any additional setup after loading the view, typically from a nib.
        checkIfUserIsLoggedIn()
    }
    
    
    @objc func handleNewMessages(){
        let newMessageController = NewMessageViewController()
        let navigationVC = UINavigationController(rootViewController: newMessageController)
        present(navigationVC, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil || UserDefaults.standard.value(forKey: "username") as? String == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        }else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot)
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            })
        }
    }
    
    @objc func handleLogOut(){
        let loginVC = LoginViewController()
        do{
            try Auth.auth().signOut()
        }catch{
            print("error log out")
        }
        present(loginVC, animated: true, completion: nil)
        //let registerVC = RegisterViewController()
        //present(registerVC, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

