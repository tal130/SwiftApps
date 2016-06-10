//
//  MemoryGame.swift
//  tar3
//
//  Created by admin on 6/10/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation

public class MemoryGame{
    
 
    var numberOfsigns = 8
    var matchFound = 0

    init(numberOfSigns : Int){
        self.numberOfsigns = numberOfSigns
    }
    
    func compare(str1: String, str2: String) -> Bool
    {
        if (str1 == str2){
        //if  the two lable text equal disable them
           
            matchFound++
            return true
            
    
        }
        return false
    }
    func endOfgame()->Bool{
        if(matchFound == numberOfsigns)
        {
            
            
            return true
    
        }
        return false
    }
 
    
    
    func shuffleArray(var array:Array<Int>) -> Array<Int>
    {
        for var index = array.count-1; index>0; index--
        {
            let j = Int(arc4random_uniform(UInt32(index-1)))
            swap(&array[index], &array[j])
        }
        return array
    }
    
    
    func startGame()
    {
        matchFound = 0
       
    }

}