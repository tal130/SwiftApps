//
//  SelectImagesController.swift
//  tar3
//
//  Created by admin on 5/6/16.
//  Copyright © 2016 admin. All rights reserved.
///Users/admin/Desktop/tar3/tar3/imageCell.swift

import Foundation
import UIKit
import SystemConfiguration


class SelectImagesController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet var collectionView: UICollectionView!
    let imagePicker = UIImagePickerController()
    let alert = UIAlertController(title: "Pick image source", message: "Pick image source", preferredStyle: .Alert)
    var cell: imageCell!
    var images = [Image]()
    var numOfImages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        //configure alert
        alert.addTextFieldWithConfigurationHandler({(textField : UITextField!) -> Void in
            textField.placeholder = "Enter URL"
            }
        )
        alert.addAction(UIAlertAction(title: "From URL", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            
       //     let urlText = (self.alert.textFields![0] as UITextField).text
//            self.cell.imageView.contentMode = .ScaleToFill
//            let data = NSData(contentsOfURL: NSURL(string: (urlText)!)!)
//            self.cell.imageView.image = UIImage(data: data!)
//            
//            let image = Image(source: "device", imagePath: NSURL(string: (urlText)!)!, location: self.collectionView.indexPathForCell(self.cell)!)
//            self.images.append(image)
            
//            
//            let url = NSURL(string: urlText!)
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
//                dispatch_async(dispatch_get_main_queue(), {
//                        self.cell.imageView.contentMode = .ScaleToFill
//                        self.cell.imageView.image = UIImage(data: data!)
//                        let image = Image(source: "device", imagePath: NSURL(string: (urlText)!)!, location: self.collectionView.indexPathForCell(self.cell)!)
//                        self.images.append(image)
//                });
//            }

            if (Reachability.isConnectedToNetwork())
            {
            let urlText = (self.alert.textFields![0] as UITextField).text
            self.cell.imageView.contentMode = .ScaleToFill
            let data = NSData(contentsOfURL: NSURL(string: urlText!)!)
            self.cell.imageView.image = UIImage(data: data!)
            
            let fullPath = self.uiImageToFile(UIImage(data: data!)!)
            
            
            let cellIndex = self.collectionView.indexPathForCell(self.cell)!
            let image = Image(source: "device", imagePath: NSURL(string: fullPath)!, location: cellIndex)
            if (self.numOfImages > (cellIndex.section * 2) + cellIndex.row)
            {
                self.images[(cellIndex.section * 2) + cellIndex.row] = image
            }
            else
            {
                self.images.append(image)
            }
            }
            self.numOfImages += 1

        }))
        alert.addAction(UIAlertAction(title: "From device", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }))
        
        numOfImages = Image.loadNumOfImages()!
        images = Image.loadImages()!
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell2 = collectionView.dequeueReusableCellWithReuseIdentifier("imageid", forIndexPath: indexPath) as? imageCell
        
        //if let image = Image.loadImage(indexPath.row*2 + indexPath.section)
        //{
        //    let url = image.imagePath.absoluteString
        //    var data: NSData
        //
        //    if(image.source == "URL")
        //    {
        //        data = NSData(contentsOfURL: image.imagePath)!
        //        cell2!.imageView.image = UIImage(data: data)
        //    }
        //    else
        //    {
        //        cell2?.imageView.image = loadImageFromPath(url)
        //    }
            
        //}
        let index = indexPath.section*2 + indexPath.row
        if(numOfImages > index)
        {
            cell2?.imageView.image =  loadImageFromPath(self.images[index].imagePath.absoluteString)
        }
        return cell2!
    }
    
    class Reachability {
        class func isConnectedToNetwork() -> Bool {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
                SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        cell = collectionView.cellForItemAtIndexPath(indexPath) as! imageCell
        
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            imagePicker.sourceType = .Camera
        }
        (self.alert.textFields![0] as UITextField).text = "Enter URL"
        self.presentViewController(alert, animated: true, completion: nil)
        
        //presentViewController(imagePicker, animated: true, completion: nil)

        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: 150, height: 150)
    }

    
    


    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cell.imageView.contentMode = .ScaleToFill
            cell.imageView.image = pickedImage
            
        
            let fullPath = uiImageToFile(pickedImage)
            //info[UIImagePickerControllerReferenceURL] as! NSURL
            let cellIndex = collectionView.indexPathForCell(cell)!
            let image = Image(source: "device", imagePath: NSURL(string: fullPath)!, location: cellIndex)
            if (self.numOfImages > (cellIndex.section * 2) + cellIndex.row)
            {
                images[(cellIndex.section * 2) + cellIndex.row] = image
            }
            else
            {
                images.append(image)
            }
            self.numOfImages += 1
        }


        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uiImageToFile(pickedImage: UIImage) -> String
    {
        let imageData = NSData(data:UIImagePNGRepresentation(pickedImage)!)
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docs: String = paths[0]
        let id = (collectionView.indexPathForCell(cell)!.row*2) + collectionView.indexPathForCell(cell)!.section
        let fullPath = docs.stringByAppendingString(String(id) + ".jpg")
        imageData.writeToFile(fullPath, atomically: true)
        return fullPath
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func doneButtonClick(sender: AnyObject) {
        Image.saveImages(images)
        Image.saveNumOfImages(images.count)
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
}