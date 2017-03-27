//
//  OtherUserProfileContainerVC.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 10/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class OtherUserProfileContainerVC: UIViewController {
    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()

//TODO: - Controls
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    //3rd View
    @IBOutlet weak var btnInfoOutlet: UIButton!
    @IBOutlet weak var btnUpdatesOutlet: UIButton!
    
    //2nd View
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    
    @IBOutlet weak var btnEditOutlet: UIButton!
    //Common
    @IBOutlet weak var imgInfoTap: UIImageView!
    @IBOutlet weak var imgUpdateTap: UIImageView!
    @IBOutlet weak var imgDogTags: UIImageView!
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserPic: UIImageView!
//TODO: - Let's Code
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.imgInfoTap.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.imgUserPic.layer.cornerRadius = self.imgUserPic.frame.size.width/2
        self.imgUserPic.clipsToBounds = true
        
        self.imgDogTags.image = UIImage(named: "img_dogtagBG\(self.delObj.deviceName)")
       // self.btnEditOutlet.setImage(UIImage(named: "btn_edit\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        self.imgInfoTap.image = UIImage(named: "img_selected-tab\(self.delObj.deviceName)")
        self.imgUpdateTap.image = UIImage(named: "img_selected-tab\(self.delObj.deviceName)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - Function
    
    func selectViewController(segVal : Int){
        
        
        var viewControllerIdentifier = ["idOtherUserPostVC","idOtherUserInfoTableViewController"]
        var seg = segVal
        if(seg == 0){
            let newController = self.storyboard!.instantiateViewControllerWithIdentifier(viewControllerIdentifier[seg])
            
            let oldController = childViewControllers.last!
            newController.view.frame = oldController.view.frame
            oldController.willMoveToParentViewController(nil)
            addChildViewController(newController)
            
            transitionFromViewController(oldController, toViewController: newController, duration: 0.25, options: .TransitionCrossDissolve, animations:{ () -> Void in
                // nothing needed here
                }, completion: { (finished) -> Void in
                    oldController.removeFromParentViewController()
                    newController.didMoveToParentViewController(self)
            })
            self.imgUpdateTap.hidden = false
            self.imgInfoTap.hidden = true
            
        }else{
            seg = 1
            // println(seg2.selectedIndex)
            let newController = self.storyboard!.instantiateViewControllerWithIdentifier(viewControllerIdentifier[seg])
            
            let oldController = childViewControllers.last!
            newController.view.frame = oldController.view.frame
            oldController.willMoveToParentViewController(nil)
            addChildViewController(newController)
            
            transitionFromViewController(oldController, toViewController: newController, duration: 0.25, options: .TransitionCrossDissolve, animations:{ () -> Void in
                // nothing needed here
                }, completion: { (finished) -> Void in
                    oldController.removeFromParentViewController()
                    newController.didMoveToParentViewController(self)
            })
            
            self.imgUpdateTap.hidden = true
            self.imgInfoTap.hidden = false
            
        }
    }
    
    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //3rd View Click
    @IBAction func btnFollowersClick(sender: AnyObject) {
        let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navFollowers") as! UINavigationController
        self.presentViewController(noti, animated: true, completion: nil)
    }
    
    @IBAction func btnFollowingClick(sender: AnyObject) {
        let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navFollowing") as! UINavigationController
        self.presentViewController(noti, animated: true, completion: nil)
        
        
    }
    
    
    //2nd View Click
    
    @IBAction func btnUpdateClick(sender: AnyObject) {
        self.btnInfoOutlet.backgroundColor = cust.lightButtonBackgroundColor
        self.btnUpdatesOutlet.backgroundColor = cust.darkButtonBackgroundColor
        selectViewController(0)
    }
    @IBAction func btnInfoClick(sender: AnyObject) {
        self.btnInfoOutlet.backgroundColor = cust.darkButtonBackgroundColor
        self.btnUpdatesOutlet.backgroundColor = cust.lightButtonBackgroundColor
        selectViewController(1)
    }
}
