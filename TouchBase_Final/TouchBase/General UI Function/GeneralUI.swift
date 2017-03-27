//
//  GeneralUI.swift
//  ICE Events
//
//  Created by vijay kumar on 01/09/16.
//  Copyright © 2016 Vijayakumar. All rights reserved.
//
import UIKit
import Foundation
import JDropDownAlert

class GeneralUI {
    
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
            alert.alertWith("Password doesn't match")
            return false
        }
        
        return true
    }
    
    static func validateCEmail(textField: UITextField, textField2: UITextField) -> Bool {
        
        let text: String = textField.text!
        let text2: String = textField2.text!
        let alert = JDropDownAlert()
        //alert.titleFont = UIFont(name: "Lato-Regular", size: 16)!
        
        if text != text2 {
            textField2.becomeFirstResponder()
            alert.alertWith("Email Address doesn't match")
            return false
        }
        
        return true
    }
    
    static func validateAgree(value: Bool) -> Bool {
          let alert = JDropDownAlert()
        if !value{
            alert.alertWith("Please agree to the Terms of Service")
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
    
}
