//
//  Extensions.swift
//  gameOfChat
//
//  Created by 佐藤遥人 on 2019/09/03.
//  Copyright © 2019 Haruto Sato. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    
    func loadImagaUsingCasheWithUrlString(urlString: String){
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "")
                print("画像の取得に失敗しました")
                return
            }
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!){
                //cell.imageView?.image =
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            }
            
        }).resume()
        
    }
}
