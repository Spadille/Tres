//
//  LoginViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/3/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase
import Pastel

class LoginViewController: UIViewController {
    
    let BackgroundView: PastelView = {
        let pastelView = PastelView()
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3.0
        
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        
        return pastelView
    }()
    
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
        login.backgroundColor = UIColor(rgb: 0x7EBCDC).withAlphaComponent(0.36)
        login.setTitle("Login", for: .normal)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.setTitleColor(UIColor.white, for: .normal)
        login.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        login.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return login
    }()
    
    let createAccount: UIButton = {
        let tf = UIButton()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.setTitle("Want to register an account for your company?", for: .normal)
        tf.setTitleColor(UIColor.white, for: .normal)
        tf.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        tf.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        return tf
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
        imageView.alpha = 0.64
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
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot)
                if let dict = snapshot.value as? [String:AnyObject] {
                    UserDefaults.standard.set(dict, forKey: "user")
                }
            })
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func goToRegister(){
        let vc = RegisterViewController()
        present(vc, animated: true, completion: nil)
    }
    
    func handleTap(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleSingleTap(recognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(rgb: 0xE5E6E7)
        setupBackground()
        setupInputContainer()
        setupLoginButton()
        setupImageProfile()
        handleTap()
    }
    
    func setupBackground(){
        BackgroundView.frame = view.bounds
        view.insertSubview(BackgroundView, at: 0)
    }
    
    func setupInputContainer() {
        view.addSubview(inputsContainerView)
        // Do any additional setup after loading the view.
        let constraints: [NSLayoutConstraint] = [
            inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            inputsContainerView.heightAnchor.constraint(equalToConstant: 100),
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
        view.addSubview(createAccount)
        let constraints:[NSLayoutConstraint] = [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12),
            loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            createAccount.topAnchor.constraint(equalTo: loginButton.bottomAnchor),
            createAccount.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 0),
            createAccount.heightAnchor.constraint(equalToConstant: 48)
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
    
}
