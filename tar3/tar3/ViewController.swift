//
//  ViewController.swift
//  tar3
//
//  Created by admin on 3/4/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var selectImagesBt: UIButton!
    @IBOutlet weak var scoreBoardBt: UIButton!
    @IBOutlet var startbt: UIButton!
    @IBOutlet var collectionview: UICollectionView!
    @IBOutlet var countingLabel: UILabel!
    
   
    
    var array = Array<Array<String>>()
    var previous = NSIndexPath(forRow: -1, inSection: -1)
    var clickable = false
    let NumColumns = 4
    let NumRows = 4
    let signs = ["\u{1F442}","\u{1F440}","\u{1F439}","\u{1F438}","\u{1F437}","\u{1F436}","\u{1F425}","\u{1F496}"]
    var memoryGame = MemoryGame(numberOfSigns: 8)
    //var matchFound = 0
    var counter = 0
    var timer = NSTimer()
    var images = [Image]()
    var numOfImages = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        countingLabel.text = String(counter)
        
        numOfImages = Image.loadNumOfImages()!
        images = Image.loadImages()!
    
       
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
        let data = array[indexPath.row][indexPath.section]
        if(data.containsString("image_"))
        {
            celll!.image.image = loadImageFromPath((data as NSString).substringFromIndex(6))
            celll!.te.text = data as String
            celll!.type = "image"
            
        }
        else
        {
            celll!.te.text = array[indexPath.row][indexPath.section]
            celll!.type = "label"
        }
        celll!.image.hidden = true
        celll!.te.hidden = true
        celll!.clickable = true

        return celll!
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell2 = collectionView.cellForItemAtIndexPath(indexPath) as! cell
        if(clickable && cell2.clickable == true)
        {
            if(cell2.type == "label"){
                cell2.te.hidden = false
            }
            else{
                cell2.image.hidden = false
            }
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
    
    func makeToast(score:Int)
    {
        let alert = UIAlertController(title: "Game Over", message: "Score: " + String(score), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Restart Game", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
            let userName = (alert.textFields![0] as UITextField).text
            self.saveScore(userName!, score: score)
            self.restartGame()
        }))
        alert.addAction(UIAlertAction(title: "Finish", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
            let userName = (alert.textFields![0] as UITextField).text
            self.saveScore(userName!, score: score)
            self.backToMenu()
        }))
        alert.addTextFieldWithConfigurationHandler({(textField : UITextField!) -> Void in
            textField.placeholder = "Your name"
            }
        )

        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func saveScore(name: String, score: Int)
    {
        let sc = Score()
        sc.id = NSDate().timeIntervalSince1970
        sc.score = score
        sc.name = name
        sc.date = NSDate()
        sc.time = 0
        var scoreArray = Score.loadScores()
        if (scoreArray != nil)
        {
            scoreArray?.append(sc)
            Score.saveScoreArray(scoreArray!)
        }
        else
        {
            var scoreArray = [Score]()
            scoreArray.append(sc)
            Score.saveScoreArray(scoreArray)
        }
        
        //sc.saveScore()
    }
    
    func backToMenu()
    {
        scoreBoardBt.hidden = false
        selectImagesBt.hidden = false
        startbt.hidden = false
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
        
    }
    
    func restartGame()
    {
        backToMenu()
        startGame()

    }
    
    func check(preCell: cell, cell2: cell)
    {
        

        let compared = memoryGame.compare(preCell.te.text! ,str2: cell2.te.text! )
        if (compared){
            cell2.hidden = true
            preCell.hidden = true
        }
        if (memoryGame.endOfgame()){
            timer.invalidate()
            let score = Int((1.0 / Double(counter)) * 2000)
            makeToast(score)
        }
        clickable = true
        preCell.te.hidden = true
        cell2.te.hidden = true
        preCell.image.hidden = true
        cell2.image.hidden = true
    }
    
    func setSigns(var array:Array<Array<String>>, signs:Array<String>, numColumns: Int, numRows: Int) -> Array<Array<String>>{
        var indexarray = Array<Int>()
        
        for k in 0...(numRows*numColumns - 1)
        {
            indexarray.append(k)
        }
        //shuffle index array
        indexarray = memoryGame.shuffleArray(indexarray)
        var index = 0
        for _ in 1...(numColumns)
        {
            var colArray = Array<String>()
            for _ in 1...(numRows)
            {
                // dive by 2 so each sign appear twice
                if(numOfImages>indexarray[index]/2)
                {
                    colArray.append("image_" + images[indexarray[index]/2].imagePath.absoluteString)
                }
                else{
                    colArray.append(signs[indexarray[index]/2])
                }
                index++
            }
            array.append(colArray)
        }
        
        return array
    }
    
  
    
    
    @IBAction func startbt(sender: AnyObject) {
        memoryGame.startGame()
        startGame()
    }
    
    func startGame()
    {
        clickable = true
        counter = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
        startbt.hidden = true
        scoreBoardBt.hidden = true
        selectImagesBt.hidden = true
    }
    
    func updateCounter() {
        counter++
        let seconds = counter % 60
        let minutes = counter / 60
        if (counter % 60 < 10){
             countingLabel.text = String("\(minutes)" + ":0" + "\(seconds)")
        }else{
        countingLabel.text = String("\(minutes)" + ":" + "\(seconds)")
        }
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }

    @IBAction func exitApp(sender: AnyObject) {
        exit(0)
    }
}

