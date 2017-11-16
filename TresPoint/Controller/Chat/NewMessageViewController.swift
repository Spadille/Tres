//
//  NewMessageViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/5/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {
    
    let dataref = Database.database().reference()
    
    let cellId = "cellId"
    
    var users = [User]()
    
    var messageController: HomeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    func fetchUser(){
        dataref.child("users").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.name = dict["name"] as? String
                user.email = dict["email"] as? String
                user.phonenumber = dict["phonenumber"] as? String
                user.profileImage = dict["imageURL"] as? String
                user.id = snapshot.key
                self.users.append(user)
                //print(user.email,user.name)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            //print("dismissed")
            let user = self.users[indexPath.row]
            self.messageController?.showchatvc(user: user)
            //print(self.user.name)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        //cell.imageView?.image = UIImage(named: "messi")
        //cell.imageView?.contentMode = .scaleAspectFill
        
        if let profileImageUrl = user.profileImage {
            let url = URL(string: profileImageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    cell.profileImageView.image = UIImage(data: data!)
                    //cell.imageView?.image = UIImage(data: data!)
                }
                
            }).resume()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

}
