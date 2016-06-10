//
//  Score.swift
//  tar3
//
//  Created by admin on 4/15/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation

class Score: NSObject, NSCoding {
    var name: String!
    var score: Int!
    var date: NSDate!
    var time: Double!
    var id: Double!
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.name = decoder.decodeObjectForKey("name") as! String
        self.score = decoder.decodeObjectForKey("score") as! Int
        self.date = decoder.decodeObjectForKey("date") as! NSDate
        self.time = decoder.decodeObjectForKey("time") as! Double
        self.id = decoder.decodeObjectForKey("id") as! Double

    }
    convenience init(name: String, score: Int, date: NSDate, time: Double, id: Double) {
        self.init()
        self.name = name
        self.score = score
        self.date = date
        self.time = time
        self.id = id
    }
    func encodeWithCoder(coder: NSCoder) {
        if let name = name { coder.encodeObject(name, forKey: "name") }
        if let score = score { coder.encodeObject(score, forKey: "score") }
        if let date = date { coder.encodeObject(date, forKey: "date") }
        if let time = time { coder.encodeObject(time, forKey: "time") }
        if let id = id { coder.encodeObject(id, forKey: "id") }
        
    }
    
    
    static func saveScoreArray(scoreArray: [Score])
    {
        let preferences = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(scoreArray)
        preferences.setObject(data, forKey: "scores")
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            //  Couldn't save
        }
    }
    
    static func  loadScores() -> [Score]?
    {
        let preferences = NSUserDefaults.standardUserDefaults()
        
        if let loadedData = preferences.objectForKey("scores") as? NSData
        {
            
            if let loadedScore = NSKeyedUnarchiver.unarchiveObjectWithData(loadedData) as? [Score]
            {
                return loadedScore
            }
        }
        
        return nil
    }
}