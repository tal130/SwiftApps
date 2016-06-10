//
//  Image.swift
//  tar3
//
//  Created by admin on 5/13/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
class Image: NSObject, NSCoding {
    var source: NSString!
    var imagePath: NSURL!
    var location: NSIndexPath! //cell index
    
    convenience init(source: NSString, imagePath: NSURL, location: NSIndexPath) {
        self.init()
        self.source = source
        self.imagePath = imagePath
        self.location = location
        
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.source = decoder.decodeObjectForKey("source") as! NSString
        self.imagePath = decoder.decodeObjectForKey("imagePath") as! NSURL
        self.location = decoder.decodeObjectForKey("location") as! NSIndexPath
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        if let source = source { coder.encodeObject(source, forKey: "source") }
        if let imagePath = imagePath { coder.encodeObject(imagePath, forKey: "imagePath") }
        if let location = location { coder.encodeObject(location, forKey: "location") }
        
    }
    
    
    static func saveImages(imagesArray: [Image])
    {
        let preferences = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(imagesArray)
        preferences.setObject(data, forKey: "images")
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            //  Couldn't save
        }
    }
    
    
    
    static func saveNumOfImages(num: Int)
    {
        let preferences = NSUserDefaults.standardUserDefaults()
        preferences.setInteger(num, forKey: "numberOfImages")
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            //  Couldn't save
            print("could not save")
        }
    }
    
    
    
    
    static func  loadNumOfImages() -> Int?
    {
        let preferences = NSUserDefaults.standardUserDefaults()
        
        if let num = preferences.valueForKey("numberOfImages") as? Int
        {
            return num
        }
        
        return 0
    }
    
    static func  loadImages() -> [Image]?
    {
        let preferences = NSUserDefaults.standardUserDefaults()
        
        if let loadedData = preferences.objectForKey("images") as? NSData
        {
            
            if let loadedImages = NSKeyedUnarchiver.unarchiveObjectWithData(loadedData) as? [Image]
            {
                return loadedImages
            }
        }
        
        return [Image]()
    }

}