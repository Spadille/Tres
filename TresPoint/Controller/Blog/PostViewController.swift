//
//  PostViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/15/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
//import MobileCoreServices
import Firebase

class PostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb:0xE5E6E7)
        setUpPost()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var textTxt: UITextView = {
        let tt = UITextView()
        tt.backgroundColor = UIColor.white
        tt.translatesAutoresizingMaskIntoConstraints = false
        //tt.placeholder = "This is a placeholder"
        tt.layer.cornerRadius = 10
        tt.layer.masksToBounds = true
        tt.delegate = self
        return tt
    }()
    
    let countLbl: UILabel = {
        let cl = UILabel()
        cl.translatesAutoresizingMaskIntoConstraints = false
        cl.textAlignment = .right
        //cl.textColor = infoColor.colorSmoothGray
        cl.textColor = UIColor.white
        cl.font = UIFont.systemFont(ofSize: 12)
        cl.text = "140"
        return cl
    }()
    
    lazy var selectBtn: UIButton = {
        let sb = UIButton()
        sb.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named:"add_pressed")
        sb.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        sb.setImage(image, for: .normal)
        sb.contentMode = .scaleAspectFit
        sb.setTitleColor(infoColor.colorBrandBlue, for: UIControlState())
        return sb
    }()
    
    lazy var pictureImg: UIImageView = {
        let tt = UIImageView()
        tt.contentMode = .scaleAspectFill
        tt.translatesAutoresizingMaskIntoConstraints = false
        return tt
    }()
    
    lazy var postBtn: UIButton = {
        let tt = UIButton()
        tt.translatesAutoresizingMaskIntoConstraints = false
        //let image = UIImage(named:"add_pressed")
        //tt.setImage(image, for: .normal)
        tt.setTitle("Post", for: .normal)
        tt.backgroundColor = infoColor.colorBrandBlue
        // disable button from the begining
        tt.isEnabled = false
        tt.alpha = 0.4
        tt.layer.cornerRadius = 10
        tt.layer.masksToBounds = true
        tt.addTarget(self, action: #selector(uploadToFirebase), for: .touchUpInside)
        return tt
    }()
    
    lazy var deleteImageButton:UIButton = {
        let tt = UIButton()
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.setTitle("del", for: .normal)
        // disable button from the begining
        tt.isEnabled = false
        tt.alpha = 0
        tt.layer.cornerRadius = 10
        tt.layer.masksToBounds = true
        tt.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        return tt
    }()
    
    func setUpPost(){
        view.addSubview(textTxt)
        view.addSubview(countLbl)
        view.addSubview(selectBtn)
        view.addSubview(pictureImg)
        view.addSubview(postBtn)
        view.addSubview(deleteImageButton)
        
        let constraints:[NSLayoutConstraint] = [
            textTxt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:4),
            textTxt.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-4),
            textTxt.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            textTxt.heightAnchor.constraint(equalToConstant: 200),
            countLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-6),
            countLbl.widthAnchor.constraint(equalToConstant:40),
            countLbl.topAnchor.constraint(equalTo: textTxt.bottomAnchor, constant:4),
            countLbl.heightAnchor.constraint(equalToConstant: 24),
            selectBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectBtn.widthAnchor.constraint(equalToConstant:40),
            selectBtn.topAnchor.constraint(equalTo: textTxt.bottomAnchor, constant:4),
            selectBtn.heightAnchor.constraint(equalToConstant: 40),
            pictureImg.leadingAnchor.constraint(equalTo: selectBtn.trailingAnchor, constant: 10),
            pictureImg.topAnchor.constraint(equalTo: textTxt.bottomAnchor, constant:4),
            pictureImg.heightAnchor.constraint(equalToConstant: 64),
            pictureImg.widthAnchor.constraint(equalToConstant: 64),
            postBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            postBtn.topAnchor.constraint(equalTo: textTxt.bottomAnchor, constant:100),
            postBtn.heightAnchor.constraint(equalToConstant: 30),
            postBtn.widthAnchor.constraint(equalToConstant: 80),
            deleteImageButton.leadingAnchor.constraint(equalTo: pictureImg.trailingAnchor, constant: 10),
            deleteImageButton.topAnchor.constraint(equalTo: textTxt.bottomAnchor, constant:4),
            deleteImageButton.heightAnchor.constraint(equalToConstant: 20),
            deleteImageButton.widthAnchor.constraint(equalToConstant: 40),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        //picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                picker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(picker, animated: true, completion: nil)
            } else {
                //print("error no camera")
                let newalert = UIAlertController(title: "No Camera", message: "Please select photo library", preferredStyle: .alert)
                newalert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(newalert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            //print("action come to here")
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    @objc func deleteImage(){
        pictureImg.image = nil
        deleteImageButton.isEnabled = false
        deleteImageButton.alpha = 0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
//        } else {
//            handleImageSelectedForInfo(info: info)
//        }
        handleImageSelectedForInfo(info: info)
        dismiss(animated: true, completion: nil)
    }
    
    private func handleImageSelectedForInfo(info:[String:Any]){
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originImage
        }
        
        if let selectedImage = selectedImageFromPicker {
//            uploadToFirebaseStorageUsingImage(image: selectedImage, completion: { (imageURL) in
//                self.sendMessageWithImageUrl(imageUrl: imageURL, image: selectedImage)
//            })
            pictureImg.image = selectedImage
            deleteImageButton.isEnabled = true
            deleteImageButton.alpha = 1
        }
        
        //dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func uploadToFirebase(){
        let uid = Auth.auth().currentUser?.uid
        let dataRef = Database.database().reference().child("Posts").childByAutoId()
        let post = Post()
        let temp = UserDefaults.standard.value(forKey: "user") as? [String:Any]
        post.name = temp?["name"] as? String
        post.profileImage = temp?["imageURL"] as? String
        post.statusText = textTxt.text
        post.statusImageView = "tempurl"
        post.timeStamp = String(Date().timeIntervalSince1970)
        post.numComments = "0"
        post.numLikes = "0"
        post.id = dataRef.key
        post.isLiked = "false"
        let value: [String:Any]=[
            "name":post.name! ,"profileImage":post.profileImage ?? "" , "statusText":post.statusText!,"statusImage":post.statusImageView!,
            "numComments":"\(post.numComments!)"  ,"numLikes":"\(post.numLikes!)" ,"timestamp":post.timeStamp!,"id":post.id!,"isLiked":post.isLiked!]
        dataRef.updateChildValues(value) { (error, datarefer) in
            let key = dataRef.key
            if let error = error {
                print(error)
                return
            }
            let ref = Database.database().reference().child("User-Posts").child(uid!)
            let val:[String:Any] = [key:1]
            ref.childByAutoId().updateChildValues(val)
            if let pic = self.pictureImg.image {
                self.uploadToFirebaseStorageUsingImage(image: pic, completion: { (imageUrl) in
                    let properties: [String:Any] = ["statusImage":imageUrl]
                    dataRef.updateChildValues(properties)
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadToFirebaseStorageUsingImage(image:UIImage, completion:@escaping (_ imageUrl:String)->()){
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("post_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2){
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                
                if let imageURL = metadata?.downloadURL()?.absoluteString {
                    //self.sendMessageWithImageUrl(imageUrl: imageURL,image:image)
                    completion(imageURL)
                }
            })
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // numb of characters in textView
        let chars = textView.text.count
        // white spacing in text
        let spacing = CharacterSet.whitespacesAndNewlines
        // calculate string's length and convert to String
        countLbl.text = String(140 - chars)
        // if number of chars more than 140
        if chars > 140 {
            countLbl.textColor = UIColor.red
            postBtn.isEnabled = false
            postBtn.alpha = 0.4
            // if entered only spaces and new lines
        } else if textView.text.trimmingCharacters(in: spacing).isEmpty {
            postBtn.isEnabled = false
            postBtn.alpha = 0.4
            // everything is correct
        } else {
            countLbl.textColor = UIColor.black
            postBtn.isEnabled = true
            postBtn.alpha = 1
        }
    }
}
