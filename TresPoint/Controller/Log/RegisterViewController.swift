//
//  RegisterViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/3/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    let inputsContainerView: UIView = {
        let input = UIView()
        input.backgroundColor = UIColor.white
        input.translatesAutoresizingMaskIntoConstraints = false
        input.layer.cornerRadius = 5
        input.layer.masksToBounds = true
        return input
    }()
    
    let registerButton: UIButton = {
        let register = UIButton()
        register.backgroundColor = UIColor(rgb: 0x7EBCDC)
        register.setTitle("Register", for: .normal)
        register.translatesAutoresizingMaskIntoConstraints = false
        register.setTitleColor(UIColor.white, for: .normal)
        register.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        register.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return register
    }()
    
    let nameTextField: UITextField = {
        let nametext = UITextField()
        nametext.placeholder = "Full Name"
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
    
    let phoneNumberSeperateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let phoneNumberField: UITextField = {
        let nametext = UITextField()
        nametext.placeholder = "Phone number"
        nametext.translatesAutoresizingMaskIntoConstraints = false
        return nametext
    }()
    
    let emailSeperateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let nametext = UITextField()
        nametext.placeholder = "Email"
        nametext.translatesAutoresizingMaskIntoConstraints = false
        return nametext
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: 0xE5E6E7)
        setupInputContainer()
        setupLoginButton()
        setupImageProfile()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @objc func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let fullname = nameTextField.text,
        let phoneNumber = phoneNumberField.text else{
            //print("field empty")
            appDelegate.infoView(message: "input field is empty", color: infoColor.colorSmoothRed)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                appDelegate.infoView(message: "Register Error", color: infoColor.colorSmoothRed)
                return
            }
            let uid = user?.uid
            let newUser = ["name":fullname,"email":email,"phonenumber":phoneNumber]
            let dataRef = Database.database().reference().child("users").child(uid!)
            dataRef.setValue(newUser)
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    appDelegate.infoView(message: "error sign in", color: infoColor.colorSmoothRed)
                }
                UserDefaults.standard.set(email, forKey: "username")
            })
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupInputContainer() {
        view.addSubview(inputsContainerView)
        // Do any additional setup after loading the view.
        let constraints: [NSLayoutConstraint] = [
            inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            inputsContainerView.heightAnchor.constraint(equalToConstant: 160)
        ]
        NSLayoutConstraint.activate(constraints)
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeperateView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(emailSeperateView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(phoneNumberSeperateView)
        inputsContainerView.addSubview(phoneNumberField)
        let nameTextConstraints: [NSLayoutConstraint] = [
            nameTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4),
            nameSeperateView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor),
            nameSeperateView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSeperateView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            nameSeperateView.heightAnchor.constraint(equalToConstant: 1),
            passwordTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            passwordTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4),
            emailSeperateView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor),
            emailSeperateView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            emailSeperateView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            emailSeperateView.heightAnchor.constraint(equalToConstant: 1),
            emailTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            emailTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4),
            phoneNumberSeperateView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor),
            phoneNumberSeperateView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            phoneNumberSeperateView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            phoneNumberSeperateView.heightAnchor.constraint(equalToConstant: 1),
            phoneNumberField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            phoneNumberField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            phoneNumberField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            phoneNumberField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4),
        ]
        NSLayoutConstraint.activate(nameTextConstraints)
    }
    
    
    
    func setupLoginButton() {
        view.addSubview(registerButton)
        let constraints:[NSLayoutConstraint] = [
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12),
            registerButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
