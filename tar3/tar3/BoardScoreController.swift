//
//  BoardScoreController.swift
//  tar3
//
//  Created by admin on 4/15/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
import UIKit

class BoardScoreController : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var scoreTableView: UITableView!
    let SCORETOSHOW = 10
    var array : [Score]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.array = [Score]()
        readScores()
    }

    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return SCORETOSHOW
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell") as! BoardScoreCell
        if (self.array?.count > indexPath.row){
            cell.nameLabel.text = self.array?[indexPath.row].name
            cell.scoreLabel.text = String((self.array![indexPath.row].score))
        }
        
        
        //        cell.text = "Row #\(indexPath.row)"
        //        cell.detailTextLabel.text = "Subtitle #\(indexPath.row)"
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func readScores(){
//        for i in 0...SCORETOSHOW{
//            if let tempScore = Score.loadScore(i+1){
//                self.array?.append(tempScore)
//            }
//        }
        self.array = Score.loadScores()
        self.array = self.array?.sort({ $0.score > $1.score })
    }
    

    
}

