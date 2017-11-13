//
//  LoginViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/3/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let inputsContainerView: UIView = {
        let input = UIView()
        input.backgroundColor = UIColor.white
        input.translatesAutoresizingMaskIntoConstraints = false
        input.layer.cornerRadius = 5
        input.layer.masksToBounds = true
        return input
    }()

    let loginButton: UIButton = {
        let login = UIButton()
        login.backgroundColor = UIColor(rgb: 0x7EBCDC)
        login.setTitle("Login", for: .normal)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.setTitleColor(UIColor.white, for: .normal)
        login.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        login.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return login
    }()
    
    let nameTextField: UITextField = {
        let nametext = UITextField()
        nametext.placeholder = "Email"
        nametext.translatesAutoresizingMaskIntoConstraints = false
        return nametext
    }()
    
    let nameSeperateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let nametext = UITextField()
        nametext.placeholder = "Password"
        nametext.isSecureTextEntry = true
        nametext.translatesAutoresizingMaskIntoConstraints = false
        return nametext
    }()
    
    let imageProfile: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "TresPointLogin")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    @objc func handleLogIn(){
        guard let email = nameTextField.text, let password = passwordTextField.text else {
            appDelegate.infoView(message: "pleas input correct infomation", color: infoColor.colorSmoothRed)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            UserDefaults.standard.set(email, forKey: "username")
            self.dismiss(animated: true, completion: nil)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: 0xE5E6E7)
        setupInputContainer()
        setupLoginButton()
        setupImageProfile()
    }
    
    func setupInputContainer() {
        view.addSubview(inputsContainerView)
        // Do any additional setup after loading the view.
        let constraints: [NSLayoutConstraint] = [
            inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(constraints)
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeperateView)
        inputsContainerView.addSubview(passwordTextField)
        let nameTextConstraints: [NSLayoutConstraint] = [
            nameTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2),
            nameSeperateView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor),
            nameSeperateView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSeperateView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            nameSeperateView.heightAnchor.constraint(equalToConstant: 1),
            passwordTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            passwordTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        ]
        NSLayoutConstraint.activate(nameTextConstraints)
    }
    
    

    func setupLoginButton() {
        view.addSubview(loginButton)
        let constraints:[NSLayoutConstraint] = [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12),
            loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupImageProfile(){
        view.addSubview(imageProfile)
        let constraints: [NSLayoutConstraint] = [
            imageProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageProfile.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12),
            imageProfile.widthAnchor.constraint(equalToConstant: 120),
            imageProfile.heightAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(constraints)
    }
        
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
