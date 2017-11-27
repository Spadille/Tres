//
//  TabBarViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/5/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController, CustomTabBarDelegate,CustomTabBarDataSource,UITabBarControllerDelegate {

    var customTabBar: CustomTabBar?
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfUserIsLoggedIn()
        
        // Do any additional setup after loading the view.
        self.tabBar.isHidden = true
        self.selectedIndex = 1
        self.delegate = self
        
        let hvc = HomeViewController()
        hvc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named:"chat"), tag: 0)
        let navih = UINavigationController(rootViewController: hvc)
        let bvc = BlogPostViewController()
        bvc.tabBarItem = UITabBarItem(title: "Blog", image: UIImage(named:"triangle"), tag: 1)
        let navib = UINavigationController(rootViewController: bvc)
        let cvc = CalendarViewController()
        cvc.tabBarItem = UITabBarItem(title: "Date", image: UIImage(named:"calendar"), tag: 2)
        let navic = UINavigationController(rootViewController: cvc)
        let pvc = ProfileViewController()
        pvc.tabBarItem = UITabBarItem(title: "User", image: UIImage(named:"contact_icon"), tag: 3)
        //pvc.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 3)
        let viewControllerList = [ navih,navib,navic,pvc ]
        //let viewControllerList = [hvc,bvc,cvc,pvc]
        viewControllers = viewControllerList
        //viewControllers = viewControllerList.map{UINavigationController(rootViewController: $0)}
        self.selectedViewController = navib
        customTabBar = CustomTabBar(frame: self.tabBar.frame)
        customTabBar!.datasource = self
        customTabBar!.delegate = self
        customTabBar!.setup()
        self.view.addSubview(customTabBar!)
        // Do any additional setup after loading the view.
    }

    func setUpTabBar(){
    }
    
    func checkIfUserIsLoggedIn(){
        if UserDefaults.standard.value(forKey: "user") == nil || Auth.auth().currentUser?.uid == nil  {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        }else {
            fetchUserAndSetUpNaviBar()
        }
    }
    
    func fetchUserAndSetUpNaviBar() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot)
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
        })
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
    
    
    func tabBarItemsInCustomTabBar(_ tabBarView: CustomTabBar) -> [UITabBarItem] {
        return tabBar.items!
    }
    
    // MARK: - CustomTabBarDelegate
    
    func didSelectViewController(_ tabBarView: CustomTabBar, atIndex index: Int) {
        self.selectedIndex = index
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CustomTabAnimatedTransitioning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
