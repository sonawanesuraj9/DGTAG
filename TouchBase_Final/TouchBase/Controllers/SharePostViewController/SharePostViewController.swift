//
//  SharePostViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 12/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit



class SharePostViewController: UIViewController {
    
    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
//TODO: - Controls
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgDogTags: UIImageView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var btnMoreOutlet: UIButton!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
//TODO: - Let's Code
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
         self.btnMoreOutlet.setImage(UIImage(named: "img_inner-menu\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        self.imgDogTags.image = UIImage(named: "img_dogtagBG\(self.delObj.deviceName)")
        
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width/2
        self.imgProfilePic.clipsToBounds = true
        
        self.shareView.hidden = true
        self.shareView.transform = CGAffineTransformMakeTranslation(0, self.shareView.frame.size.height)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SharePostViewController.methodOfReceivedNotification(_:)), name:"hideShareView", object: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - Function
    
    /**
     NsNotification method raised from child to hide parent
     
     - parameter notification: notification raised from child view
     */
    func methodOfReceivedNotification(notification: NSNotification){
        //Take Action on Notification
        hideWithAnimation()
    }
    
    /**
     Display share view with animation
     */
    func displayWithAnimation(){
        
        UIView.animateWithDuration(0.3, animations: {
            //Animation code
            self.shareView.hidden = false
            self.shareView.transform = CGAffineTransformMakeTranslation(0, 0)
        }) { (value:Bool) in
                //Completion code
            print("Done animaiton")
        }
    }
    
    
    /**
     Hide share view with animation
     */
    func hideWithAnimation(){
        UIView.animateWithDuration(0.3, animations: {
            //Animation code
           
            self.shareView.transform = CGAffineTransformMakeTranslation(0, (self.shareView.frame.size.height))
        }) { (value:Bool) in
            //Completion code
             self.shareView.hidden = true
            print("Done animaiton")
        }
    }
    
    

//TODO: - UIButton Action
    
    @IBAction func btnSharePostClick(sender: AnyObject) {
       displayWithAnimation()
    }
    @IBAction func btnMoreAction(sender: AnyObject) {
        print("More BUtton CLick")
    }
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
