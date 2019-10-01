//
//  Messages.swift
//  gameOfChat
//
//  Created by 佐藤遥人 on 2019/09/07.
//  Copyright © 2019 Haruto Sato. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    func chatPartnerId() -> String?{
        
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        }else{
            return fromId
        }
        
    }
}
