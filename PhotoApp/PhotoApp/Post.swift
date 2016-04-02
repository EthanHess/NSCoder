//
//  Post.swift
//  PhotoApp
//
//  Created by Ethan Hess on 3/30/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit

class Post: NSObject, NSCoding {
    
    var caption : String?
    var imageData : NSData?
    
    init(caption: String?, imageData: NSData?) {
        
        self.caption = caption
        self.imageData = imageData
    }

    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.caption, forKey: "capKey")
        aCoder.encodeObject(self.imageData, forKey: "imageDataKey")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.caption = aDecoder.decodeObjectForKey("capKey") as? String
        self.imageData = aDecoder.decodeObjectForKey("imageDataKey") as? NSData
    }
}
