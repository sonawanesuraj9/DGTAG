//
//  CustomClass_Dev.swift
//  PopUpDeal
//
//  Created by Suraj MAC2 on 2/23/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Darwin

class CustomClass_Dev: NSObject {

    //Text color : 322e2d
    
    // defauls 
    
    let navigationBorderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)    
    let navigationBorderHeight : CGFloat = 1
    let RounderCornerRadious : CGFloat = 5
    let placeholderTextColor : UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
    
    let navBackgroundColor : UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    
    let mainBackgroundColor : UIColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1.0)
    
    //Light
     let lightButtonBackgroundColor : UIColor = UIColor(red: 62/255, green: 62/255, blue: 62/255, alpha: 1.0)
    //Dark
     let darkButtonBackgroundColor : UIColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    
    //Extra light
    let extraLightButtonBackgroundColor : UIColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
    
    //theme
    let themeButtonBackgroundColor : UIColor = UIColor(red: 1/255, green: 153/255, blue: 239/255, alpha: 1.0)
    
    
    let normalTextColor : UIColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1.0)
    
    
    /*let textBackground : UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    let textFieldTextColor : UIColor = UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1.0)
    
    let buttonTextColor : UIColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
    let redButtonBackground : UIColor = UIColor(red: 249/255, green: 64/255, blue: 82/255, alpha: 1.0)
    let redButtonTextColor : UIColor = UIColor.whiteColor()
    
    let gradientTopColor : UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    let gradientBottomColor : UIColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0)*/
    
    
//    let gradientTopColor : UIColor = UIColor(red: 35/255, green: 33/255, blue: 34/255, alpha: 1.0)
//    let gradientBottomColor : UIColor = UIColor(red: 15/255, green: 14/255, blue: 14/255, alpha: 1.0)
//    
    let FontName : String = "Swiss721BT-Light"
    let FontNameBold : String = "Quicksand-Bold"
    let FontNameItalic : String = "Swiss721BT-Italic"
    let FontSizeText : CGFloat = 15.0
    let FontSizeTitle : CGFloat = 16.0
    let FontSizeAttri : CGFloat = 17.0
    let textColor : UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    //let textColor : UIColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1.0)
    let textTintColor : UIColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    //Validate EmailID
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    //Trim String 
    func trimString(myString : String) -> String{
    let trimmedString = myString.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        return trimmedString
    }
    
    
    func displayAlert(tit:String,msg:String){
        let alert = UIAlertController(title: tit, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.delObj.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
   
    //Custom Loading
    var CustomLoading : MZLoadingCircle = MZLoadingCircle()
    var isLoading : Bool = Bool()
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func showLoadingCircle(){
        if(!isLoading){
            CustomLoading = MZLoadingCircle(nibName: nil, bundle: nil)
            CustomLoading.view.backgroundColor = UIColor.clearColor()
            
          /*  let color : UIColor = UIColor(red: 249/255, green: 64/255, blue: 82/255, alpha: 0.6)
            let color1 : UIColor = UIColor(red: 249/255, green: 64/255, blue: 82/255, alpha: 0.4)*/
            let color : UIColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.6)
            let color1 : UIColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.4)
            
            CustomLoading.colorCustomLayer = color
            CustomLoading.colorCustomLayer2 = color1
            let CircleSize : CGFloat = 95.0
            var frameView : CGRect = CustomLoading.view.frame
            frameView.size.width = CircleSize
            frameView.size.height = CircleSize
            frameView.origin.x = delObj.screenWidth / 2 - frameView.size.width / 2
            frameView.origin.y = delObj.screenHeight / 2 - frameView.size.height / 2
            CustomLoading.view.frame = frameView
            CustomLoading.view.layer.zPosition = CGFloat(MAXFLOAT)
            UIApplication.sharedApplication().keyWindow?.userInteractionEnabled = false
            UIApplication.sharedApplication().keyWindow?.addSubview(CustomLoading.view)
           // self.addSubview(CustomLoading.view)
            isLoading = true
        }
        
    }
    
    func hideLoadingCircle(){
        if(isLoading){
            isLoading = false
             UIApplication.sharedApplication().keyWindow?.userInteractionEnabled = true
            CustomLoading.view.removeFromSuperview()
        }
        //  CustomLoading = nil
    }

    func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat) -> UIImage {
        
        let imgRef = imageSource.CGImage;
        
        let width = CGFloat(CGImageGetWidth(imgRef));
        let height = CGFloat(CGImageGetHeight(imgRef));
        
        var bounds = CGRectMake(0, 0, width, height)
        
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
            
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        
        var transform = CGAffineTransformIdentity
        let orient = imageSource.imageOrientation
        let imageSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)))
        
        
        switch(imageSource.imageOrientation) {
        case .Up :
            transform = CGAffineTransformIdentity
            
        case .UpMirrored :
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
        case .Down :
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
            
        case .DownMirrored :
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            
        case .Left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
            
        case .LeftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);
            
        case .Right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
            
        case .RightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);
            
        default : ()
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if orient == .Right || orient == .Left {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio);
            CGContextTranslateCTM(context, -height, 0);
        } else {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio);
            CGContextTranslateCTM(context, 0, -height);
        }
        
        CGContextConcatCTM(context, transform);
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return imageCopy;
    }
    
}
