//
//  ChatMessageCellCollectionViewCell.swift
//  gameOfChat
//
//  Created by 佐藤遥人 on 2019/09/18.
//  Copyright © 2019 Haruto Sato. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    let textView :UITextView = {
        let tv = UITextView()
        tv.text = "sample"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        addSubview(textView)
        
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    //        backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
