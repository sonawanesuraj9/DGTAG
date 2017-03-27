//
//  General.swift
//  DogTags
//
//  Created by vijay kumar on 02/09/16.
//  Copyright © 2016 Vijayakumar. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class General {
        
    static func reverseDate(date: String) -> String {
        
        if(date.characters.count > 1 && date.componentsSeparatedByString("-").count > 1) {
        return "\(date.componentsSeparatedByString("-")[2])-\(date.componentsSeparatedByString("-")[1])-\(date.componentsSeparatedByString("-")[0])"
        }
        return ""
    }
    
    static func goHOME(controller: UIViewController) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as UIViewController
        controller.presentViewController(viewController, animated: false, completion: nil)
    }
    
    
    static func getDate() -> String {
        
        let today = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        let defaultTimeZoneStr = formatter.stringFromDate(today)
        
        return defaultTimeZoneStr
    }
    
    
    func saveImage(image: UIImage, name: String) -> Bool{
        let path_folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        let result = jpgImageData!.writeToFile(path_folder + "/" + name, atomically: true)
        
        return result
        
    }
    
    func loadImageFromPath(name: String) -> UIImage? {
        let path_folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        var image = UIImage(contentsOfFile: path_folder + "/" + name)
        
        if image == nil {
            image = UIImage(named: "placeholder")
        }
        
        return image
    }
    
    static func convertDateToUserTimezone(dateFromServer:String)->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(dateFromServer)// create   date from string
        //let date = dateFormatter.dateFromString("2015-04-01T11:42:00")// create   date from string

        
        // change to a readable time format and change to local time zone
       // dateFormatter.dateFormat = "MMM d, yyyy - h:mm a"
         dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let timeStamp = dateFormatter.stringFromDate(date!)
        return timeStamp
    }
    
    static func saveData(data: String, name: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(data, forKey: name)
        defaults.synchronize()
    }
    
    static func loadSaved(name: String) -> String {
        var value = ""
        let defaults = NSUserDefaults.standardUserDefaults()
        if let stringOne = defaults.valueForKey(name) as? String {
            value = stringOne
        }
        return value
    }
    
    static func removeSaved(name: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(name)
    }
    
    static func calculateAge (birthday: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: birthday, toDate: NSDate(), options: []).year
    }
    
   
    
}

extension NSDate {
    var age: Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: self, toDate: NSDate(), options: []).year
    }
}
