//
//  ViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 18/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Mixpanel

/******************************/
extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}

/*********************************/


class ViewController: UIViewController {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    
//TODO: - Controls
    var backButton : UIBarButtonItem = UIBarButtonItem()
    
    @IBOutlet weak var btnSignInOutlet: UIButton!
    @IBOutlet weak var imgDummyLaunch: UIImageView!
    @IBOutlet weak var imgBg: UIImageView!
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
            initializeNaviagation()
        self.navigationController?.navigationBarHidden = true
       /* for familyName in UIFont.familyNames() {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNamesForFamilyName(familyName) {
                print(fontName)
            }
        }*/
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       // self.imgBg.image = UIImage(named: "bg-image\(self.delObj.deviceName)")
        
        let autoLogin =  General.loadSaved("autologin")
        if(autoLogin == "1"){
            self.imgDummyLaunch.hidden = false
            self.btnSignInOutlet.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }else{
            self.imgDummyLaunch.hidden = true
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
//TODO: - Function
    
    func initializeNaviagation(){
        //Back Button
        backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.BackButtonClick(_:)))
        self.navigationController?.navigationBar.topItem?.title = "DogTags"
        self.navigationController?.navigationBar.setBottomBorderColor(cust.navigationBorderColor, height: cust.navigationBorderHeight)
    }
    
    
//TODO: - UIButton Action
    @IBAction func BackButtonClick(sender:AnyObject){
        print("backClick")
    }
    @IBAction func btnSignInClick(sender: AnyObject) {
        
        //MARK: Track First impressions
        let needsToTrackFirstImpression = General.loadSaved("needsToTrackFirstImpression")
        if(needsToTrackFirstImpression == "1"){
            
        }else{
            Mixpanel.mainInstance().track(event: "Acquired",
                                          properties: ["Acquired" : "Acquired"])
            General.saveData("1", name: "needsToTrackFirstImpression")
        }
        
        
        let signinVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(signinVC, animated: true)
    }

    @IBAction func btnSignupClick(sender: AnyObject) {
        //MARK: Track First impressions
        let needsToTrackFirstImpression = General.loadSaved("needsToTrackFirstImpression")
        if(needsToTrackFirstImpression == "1"){
            
        }else{
            Mixpanel.mainInstance().track(event: "Acquired",
                                          properties: ["Acquired" : "Acquired"])
            General.saveData("1", name: "needsToTrackFirstImpression")
        }
        
        
        let signpVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupFirstStepViewController") as! SignupFirstStepViewController
        self.navigationController?.pushViewController(signpVC, animated: true)
    }
}

