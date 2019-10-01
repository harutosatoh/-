//
//  ViewController.swift
//  gameOfChat
//
//  Created by 佐藤遥人 on 2019/08/27.
//  Copyright © 2019 Haruto Sato. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class MessagesController: UITableViewController  {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellId = "cellId"
        
     
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "message-icon-png-23")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        
//        observeMessages()
        
    
        
    }
    
    var messages = [Message]() // == var messages: Message = []
    var messagesDictionary = [String: Message]()// メッセージクラスのストリング型オブジェクトが格納される
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid    else {
            return
        }
       
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                                if let dictionary = snapshot.value as? [String:AnyObject]{
                                    let message = Message()
                                    message.text = dictionary["text"] as? String
                                    message.toId = dictionary["toId"] as? String
                                    message.fromId = dictionary["fromId"] as? String
                                    message.timestamp = dictionary["timestamp"] as? NSNumber
                                    print(message.text ?? "")
                                    if let toId = message.toId{
                
                                        self.messagesDictionary[toId] = message
                
                                        self.messages = Array(self.messagesDictionary.values)
                                        self.messages.sorted(by: { (message1, message2) -> Bool in
                                            if message1.timestamp != nil && message2.timestamp != nil {
                                                return message1.timestamp!.intValue > message2.timestamp!.intValue
                                            }
                                            return false
                                        })
                                    }
                
                                    DispatchQueue.main.async { self.tableView.reloadData() }
                
                                }
            }, withCancel: nil)
        }, withCancel: nil)
    
    }
//    func observeMessages(){
//        let ref = Database.database().reference().child("messages")
//        ref.observe(.childAdded) { (snapshot) in
//
//
//            print(snapshot)
//        }
//    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? UserCell
        
        let message = messages[indexPath.row]
      
        cell?.message = message
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId()else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print("スナップショット悲哀")
            print(snapshot)
            guard let dictionary = snapshot.value as? [String:AnyObject]
                else{
                    return
            }
            
            let user = User()
            user.id = chatPartnerId
            user.email = dictionary["email"] as? String
            user.name = dictionary["name"] as? String
            user.profileImageUrl = dictionary["profileImageUrl"] as? String
             self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
        
        
//        print(message.text, message.toId, message.fromId)
//
    }
    
    
    
    @objc func handleNewMessage(){
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
        func checkIfUserIsLoggedIn(){
            if Auth.auth().currentUser?.uid == nil{
                handleLogout()
            }else{
                fetchUserAndSetupNavBarTitle()
            }
            
        }
       
    
    
    func fetchUserAndSetupNavBarTitle(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        Database.database().reference().child("users").child(uid).observe(.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.navigationItem.title = dictionary["name"] as? String
                
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
                
            }
            
        }
            , withCancel: nil)
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
    }
    
    
    
    
    @objc func showChatControllerForUser(user: User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
        
        
    }
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
           
        }catch let logoutError{
            print(logoutError)
            print("ログアウト失敗!!!!!!!!!!!!!!!!!!!!!!")
        }
        
        let loginController = LoginController()
        loginController .messsagesController = self
        present(loginController, animated: true, completion: nil)
        
        
    }


}

