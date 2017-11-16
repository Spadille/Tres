//
//  UIImageView+Cache.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/7/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject,AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String){
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        //otherwise download it from internet
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    //cell.profileImageView.image = UIImage(data: data!)
                    if let downloaded_image = UIImage(data:data!) {
                        imageCache.setObject(downloaded_image, forKey: urlString as AnyObject)
                        self.image = downloaded_image
                    }
                    //cell.imageView?.image = UIImage(data: data!)
                }
            }).resume()
        }
    }
}
