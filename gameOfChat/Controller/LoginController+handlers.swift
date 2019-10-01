//
//  LoginController+handlers.swift
//  gameOfChat
//
//  Created by 佐藤遥人 on 2019/09/01.
//  Copyright © 2019 Haruto Sato. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleRegister(){
    guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text
    else {
    print("Form is not valid")
    return
    }
        
    
    
    Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
    if let error = error as NSError?, let _  = AuthErrorCode(rawValue: error.code){
    print("Authentification failed 認証に失敗しました")
        
    }
    
        
    guard let uid = Auth.auth().currentUser?.uid else{
    return
    }
        
        
        let imageName = NSUUID().uuidString
    
        let storageRef = Storage.storage().reference().child("\(imageName).jpg")
        
        if let profileImage = self.profileImageView.image, let uploadData = UIImage.jpegData(self.profileImageView.image!)(compressionQuality: 0.1){
            
        //{
        //if let uploadData: Data = UIImage.pngData(self.profileImageView.image!)(){
            
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                storageRef.downloadURL(completion: { (url, error) in
                    
                    
                    if let downloadUrl = url {
                        
                        let directoryURL : NSURL = downloadUrl as NSURL
                        let profileImageUrl :String = directoryURL.absoluteString!
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl] as [String : Any]
                        
                        self.registerUserIntoFirebaseWithUID(uid: uid, values: values as [String : AnyObject])
                        
                    }
                    else {
                        print("couldn't get profile image url")
                        return
                    }
                })

            })
        }
        
    
    }
    
    }
    
    private func registerUserIntoFirebaseWithUID(uid: String, values: [String: AnyObject]){
        
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
      
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err ?? "")
                print("データをアップロードできませんでした")
                return
            }
            self.messsagesController?.navigationItem.title = values["name"] as? String
            //self.messsagesController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        })
        
        
    }
    
    
    
    
    @objc func handleSelectImageProfileView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage :UIImage = info[.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
            print(editedImage.size)
        }else if let originalImage: UIImage = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
            print(originalImage.size)
        }
        
        if let selectedImage = selectedImageFromPicker{
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled picker")
        dismiss(animated: true, completion: nil)
        }
    }




