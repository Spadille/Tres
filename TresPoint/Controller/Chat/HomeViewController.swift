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

    var messageArr = [Messages]()
    var messageDict = [String:Messages]()
    
    var cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let n = UINavigationController(rootViewController: self)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
        let image = UIImage(named: "add_pressed")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessages))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        getUserName()
        messageArr.removeAll()
        messageDict.removeAll()
        tableView.reloadData()
        observeUserMessages()
        //observeMessage()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getUserName(){
        let uid = Auth.auth().currentUser?.uid
        let dataRef = Database.database().reference().child("users").child(uid!)
        dataRef.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String:String]{
                let name = value["name"]
                self.navigationItem.title = name
            }
        }
    }
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        //print("???")
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let userId = snapshot.key
            //print("\(messageId) message id")
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messagesReference = Database.database().reference().child("messages").child(messageId)
                messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    //print("\(snapshot.key) snapshot value")
                    if let value = snapshot.value as? [String:AnyObject] {
                        //print(value)
                        let messages = Messages(dict: value)
//                        messages.fromId = value["fromId"] as? String
//                        messages.text = value["text"] as? String
//                        messages.timestamp = value["timeStamp"] as? String
//                        messages.toId = value["toId"] as? String
                        //self.messageArr.append(messages)
                        if let toId = messages.toId {
                            if toId == uid {
                                self.messageDict[messages.fromId!] = messages
                            }else {
                                self.messageDict[toId] = messages
                            }
                            self.messageArr = Array(self.messageDict.values)
                            self.messageArr.sort(by: { (messages1, messages2) -> Bool in
                                let m1 = messages1.timestamp
                                let m2 = messages2.timestamp
                                return Double(m1!)! > Double(m2!)!
                            })
                        }
                        
                        self.timer?.invalidate()
                        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    }
                })
            })
            return
        }
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func observeMessage(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String:AnyObject] {
                let messages = Messages(dict: value)
//                messages.fromId = value["fromId"] as? String
//                messages.text = value["text"] as? String
//                messages.timestamp = value["timeStamp"] as? String
//                messages.toId = value["toId"] as? String
                //self.messageArr.append(messages)
                if let toId = messages.toId {
                    self.messageDict[toId] = messages
                    self.messageArr = Array(self.messageDict.values)
                    self.messageArr.sort(by: { (messages1, messages2) -> Bool in
                        return Int(messages1.timestamp!)! > Int(messages2.timestamp!)!
                    })
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func showchatvc(user:User) {
        let vc = ChatLogViewController(collectionViewLayout: UICollectionViewLayout())
        vc.user = user
        //present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messageArr[indexPath.row]
        guard let partnerId = message.chatPartnerId() else {
            return
        }
        let ref = Database.database().reference().child("users").child(partnerId)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String:AnyObject] else {
                return
            }
            let user = User()
            user.id = partnerId
            user.email = dict["email"] as? String
            user.name = dict["name"] as? String
            user.phonenumber = dict["phonenumber"] as? String
            user.profileImage = dict["imageURL"] as? String
            self.showchatvc(user: user)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messageArr[indexPath.row]
        //cell.textLabel?.text = message.text
        cell.message = message
        return cell
    }
    
    @objc func handleNewMessages(){
        let newMessageController = NewMessageViewController()
        newMessageController.messageController = self
        let navigationVC = UINavigationController(rootViewController: newMessageController)
        present(navigationVC, animated: true, completion: nil)
    }
    
    @objc func handleLogOut(){
        //let loginVC = LoginViewController()
        do{
            try Auth.auth().signOut()
            let buddleId = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: buddleId)
            UserDefaults.standard.synchronize()
        }catch{
            print("error log out")
        }
        //present(loginVC, animated: true, completion: nil)
        let registerVC = RegisterViewController()
        present(registerVC, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

