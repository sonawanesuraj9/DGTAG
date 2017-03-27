//
//  GeneralUI.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 29/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//
import UIKit
import Foundation
import JDropDownAlert
import AVFoundation


extension NSDate {
    func dateStringWithFormat(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}


class GeneralUI_UI {
    
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    internal func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func validateBasic(textField: UITextField, name: String, min: Int) -> Bool {
        
        let text: String = textField.text!
        let alert = JDropDownAlert()
        // alert.titleFont = UIFont(name: "Lato-Regular", size: 16)!
        
        if text.characters.count == 0 {
            alert.alertWith("Please enter \(name)!")
        } else if text.characters.count < min {
            alert.alertWith("\(name) should have least \(min) characters!")
        }
        
        if text.characters.count < min {
            textField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    static func validateEmail(textField: UITextField, name: String) -> Bool {
        
        let text: String = textField.text!
        let alert = JDropDownAlert()
        //alert.titleFont = UIFont(name: "Lato-Regular", size: 16)!
        
        if text.characters.count == 0 {
            textField.becomeFirstResponder()
            alert.alertWith("Please enter \(name)!")
            return false
        }
        
        if !validateEmailText(text) {
            alert.alertWith("Please enter valid \(name)!")
            textField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    static func validateCPassword(textField: UITextField, textField2: UITextField) -> Bool {
        
        let text: String = textField.text!
        let text2: String = textField2.text!
        let alert = JDropDownAlert()
        //alert.titleFont = UIFont(name: "Lato-Regular", size: 16)!
        
        if text != text2 {
            textField2.becomeFirstResponder()
            alert.alertWith("Password's not match!")
            return false
        }
        
        return true
    }
    
    static func alert(text: String) {        
        let alert = JDropDownAlert()
        //alert.titleFont = UIFont(name: "Lato-Regular", size: 16)!
        alert.alertWith(text)
    }
    
    static func validateEmailText(enteredEmail: String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
        
    }
    
    static func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        
        let asset = AVAsset(URL: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImageAtTime(time, actualTime: nil)
            let outImage =  UIImage(CGImage: imageRef)
            let cust : CustomClass_Dev = CustomClass_Dev()
            cust.rotateCameraImageToProperOrientation(outImage, maxResolution: 320)
            return outImage
        } catch {
            print("error")
            return nil
        }
    }
    
    static func generateRandomImageName()->String{
        var name : String = String()
        name = NSDate().dateStringWithFormat("yyyy-MM-dd HH:mm:ss")
        var newString = name.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        newString = newString.stringByReplacingOccurrencesOfString(":", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        newString = newString.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        newString = newString + (self.randomStringWithLength() as String)
        return newString
    }
    
    static func randomStringWithLength () -> NSString {
        let len = 8
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    
    static func generateVideoThumbnail(path:String)->UIImage{
        var outImage : UIImage = UIImage()
        do {
            let asset = AVURLAsset(URL: NSURL(fileURLWithPath: path), options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
            outImage = UIImage(CGImage: cgImage)
            
            // lay out this image view, or if it already exists, set its image property to uiImage
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }
        return outImage
    }
    
}
