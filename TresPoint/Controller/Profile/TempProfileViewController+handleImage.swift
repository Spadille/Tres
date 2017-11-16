//
//  TempProfileViewController+handleImage.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/7/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import Firebase

extension TempProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                picker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(picker, animated: true, completion: nil)
            } else {
                print("error no camera")
                let newalert = UIAlertController(title: "No Camera", message: "Please select photo library", preferredStyle: .alert)
                newalert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(newalert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            print("action come to here")
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imageProfile.image = selectedImage
        }
        uploadImage()
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(){
        let ref = Storage.storage().reference(forURL: "gs://trestest-925a4.appspot.com").child("profileImage")
        let uid = Auth.auth().currentUser?.uid
        let dataref = Database.database().reference()
        let userRef = dataref.child("users").child(uid!)
        let imagename = NSUUID().uuidString
        if let uploadData = UIImageJPEGRepresentation(self.imageProfile.image!, 0.1) {
            ref.child(uid!).child("\(imagename).jpg").putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                if let s = metadata?.downloadURL()?.absoluteString{
                    let keyval = ["imageURL": s]
                    userRef.updateChildValues(keyval)
                }
            })
        }
    }
    
}
