//
//  ViewController.swift
//  tar3
//
//  Created by admin on 3/4/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet var startbt: UIButton!
    @IBOutlet var collectionview: UICollectionView!
    @IBOutlet var countingLabel: UILabel!
    var array = Array<Array<String>>()
    var previous = NSIndexPath(forRow: -1, inSection: -1)
    var clickable = false
    let NumColumns = 4
    let NumRows = 4
    let signs = ["\u{1F442}","\u{1F440}","\u{1F439}","\u{1F438}","\u{1F437}","\u{1F436}","\u{1F425}","\u{1F496}"]
    var matchFound = 0
    var counter = 0
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        countingLabel.text = String(counter)
        array = setSigns(array, signs: signs, numColumns: NumColumns, numRows: NumRows)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let celll = collectionView.dequeueReusableCellWithReuseIdentifier("ido", forIndexPath: indexPath) as? cell
        celll!.te.text = array[indexPath.row][indexPath.section]
        celll!.te.hidden = true
        celll!.clickable = true

        return celll!
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell2 = collectionView.cellForItemAtIndexPath(indexPath) as! cell
        if(clickable && cell2.clickable == true)
        {
            cell2.te.hidden = false
        
            if(previous.section != -1)
            {
                let preCell = collectionView.cellForItemAtIndexPath(previous) as! cell
                //if user click the same cell dont do anything
                if(preCell.isEqual(cell2)){
                    return
                }
               
                clickable = false
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC))), dispatch_get_main_queue()){()-> Void in
                    self.check(preCell, cell2: cell2)
                }
                previous = NSIndexPath(forRow: -1, inSection: -1)
                
            }
            else
            {
                previous = indexPath
            }
        }
        
        
        
    }
    
    func makeToast(message:String)
    {
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Restart Game", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
            self.restartGame()
        }))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func restartGame()
    {
        // generate new sign matrix
        array.removeAll()
        array = setSigns(array, signs: signs, numColumns: NumColumns, numRows: NumRows)
        // show all cells again
        for i in 0...(NumColumns-1)
        {
            for j in 0...(NumRows-1)
            {
                let indexpath = NSIndexPath(forRow: i, inSection: j)
                let tempCell = collectionview.cellForItemAtIndexPath(indexpath) as! cell
                tempCell.hidden = false
                tempCell.te.text = array[indexpath.row][indexpath.section]
            }
        }
        startGame()

    }
    
    func check(preCell: cell, cell2: cell)
    {
        if(preCell.te.text == cell2.te.text)
        {
            //if  the two lable text equal disable them
            cell2.hidden = true
            preCell.hidden = true
            matchFound++
            if(matchFound == signs.count)
            {
                timer.invalidate()
                let score = Int((1.0 / Double(counter)) * 2000)
                makeToast("Score: \(score)")
                
            }

        }
        clickable = true
        preCell.te.hidden = true
        cell2.te.hidden = true
    }
    
    func setSigns(var array:Array<Array<String>>, signs:Array<String>, numColumns: Int, numRows: Int) -> Array<Array<String>>{
        var indexarray = Array<Int>()
        
        for k in 0...(numRows*numColumns - 1)
        {
            indexarray.append(k)
        }
        //shuffle index array
        indexarray = shuffleArray(indexarray)
        var index = 0
        for _ in 1...(numColumns)
        {
            var colArray = Array<String>()
            for _ in 1...(numRows)
            {
                // dive by 2 so each sign appear twice
                colArray.append(signs[indexarray[index]/2])
                index++
            }
            array.append(colArray)
        }
        
        return array
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
    
    
    @IBAction func startbt(sender: AnyObject) {
        startGame()
    }
    
    func startGame()
    {
        clickable = true
        matchFound = 0
        counter = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
        startbt.hidden = true
    }
    
    func updateCounter() {
        counter++
        countingLabel.text = String("\(counter / 60)" + ":" + "\(counter % 60)")
    }

}

