//
//  MainContainerVC.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 02/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Mixpanel

class MainContainerVC: UIViewController,SSASideMenuDelegate {

    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    var lastIndex : Int  = Int()
    let blueBG = UIColor(red: 1/255, green: 153/255, blue: 239/255, alpha: 1.0)
    let blackBG = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1.0)
   
    
//TODO: - Controls
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imgBadge: UIImageView!
    @IBOutlet weak var btnProfileOutlet: UIButton!
    @IBOutlet weak var btnSearchOutlet: UIButton!
    @IBOutlet weak var btnHomeOutlet: UIButton!
    @IBOutlet weak var btnMenuOutlet: UIButton!
    var btn : UIButton = UIButton()
//TODO: - Let's Code
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.sideMenuViewController?.panGestureLeftEnabled = false
     //   btnMenuOutlet.addTarget(self, action: #selector(SSASideMenu.presentRightMenuViewController), forControlEvents: UIControlEvents.TouchUpInside)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainContainerVC.methodOfReceivedNotification(_:)), name:"PostBottomBadgeCounter", object: nil)
        
       
        
        selectColor(0)
    }

    func methodOfReceivedNotification(notification: NSNotification){
        //Take Action on Notification
        //MARK: Web service / API to fetch followers request
        let ct = Int(self.delObj.likeBadgeCount)! + Int(self.delObj.commentBadgeCount)! + Int(self.delObj.referenceBadgeCount)! + Int(self.delObj.followrequestBadgeCount)!
        
        if(ct == 0){
            self.imgBadge.hidden = true
            self.lblCount.hidden = true
        }else{
            self.imgBadge.hidden = false
            self.lblCount.hidden = false
            self.lblCount.text = String(ct)
        }

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        let ct = Int(self.delObj.likeBadgeCount)! + Int(self.delObj.commentBadgeCount)! + Int(self.delObj.referenceBadgeCount)! + Int(self.delObj.followrequestBadgeCount)!
        
        if(ct == 0){
            self.imgBadge.hidden = true
            self.lblCount.hidden = true
        }else{
            self.imgBadge.hidden = false
            self.lblCount.hidden = false
            self.lblCount.text = String(ct)
        }
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - Function
    
    func selectViewController(segVal : Int){
        
        
        var viewControllerIdentifier = ["idHomeTabViewController","idSearchTabViewController","id ProfileTabViewController"]
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
            
            
        }else if(seg == 1){
            seg = 1
            // println(seg2.selectedIndex)
            let newController = self.storyboard!.instantiateViewControllerWithIdentifier(viewControllerIdentifier[seg])
            
            let oldController = childViewControllers.last!
            newController.view.frame = oldController.view.frame
            oldController.willMoveToParentViewController(nil)
            addChildViewController(newController)
            
            let uid = General.loadSaved("user_id")
            Mixpanel.mainInstance().identify(distinctId: uid)
            Mixpanel.mainInstance().track(event: "Search Button Tap",
                                          properties: ["Search Button Tap" : "Search Button Tap"])

            transitionFromViewController(oldController, toViewController: newController, duration: 0.25, options: .TransitionCrossDissolve, animations:{ () -> Void in
                // nothing needed here
                }, completion: { (finished) -> Void in
                    oldController.removeFromParentViewController()
                    newController.didMoveToParentViewController(self)
            })
            
            
            
        }else if(seg == 2){
            seg = 2
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
            
            
            
        }
        selectColor(seg)
        clearSearchPreference()
    }
    
    
    func selectColor(seg:Int){
        if(seg == 0){
            self.btnHomeOutlet.backgroundColor = blueBG
            self.btnSearchOutlet.backgroundColor = blackBG
            self.btnProfileOutlet.backgroundColor = blackBG
            self.btnMenuOutlet.backgroundColor = blackBG
            
            self.btnHomeOutlet.setImage(UIImage(named: "img_home\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            self.btnSearchOutlet.setImage(UIImage(named: "img_search-hover\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            self.btnProfileOutlet.setImage(UIImage(named: "img_profile-hover\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            self.btnMenuOutlet.setImage(UIImage(named: "img_menu-hover\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            
        }else if(seg == 1){
            self.btnHomeOutlet.backgroundColor = blackBG
            self.btnSearchOutlet.backgroundColor = blueBG
            self.btnProfileOutlet.backgroundColor = blackBG
            self.btnMenuOutlet.backgroundColor = blackBG
            
            self.btnHomeOutlet.setImage(UIImage(named: "img_home-hover\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            self.btnSearchOutlet.setImage(UIImage(named: "img_search\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            self.btnProfileOutlet.setImage(UIImage(named: "img_profile-hover\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            self.btnMenuOutlet.setImage(UIImage(named: "img_menu-hover\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            
        }else if(seg == 2){
            self.btnHomeOutlet.backgroundColor = blackBG
            self.btnSearchOutlet.backgroundColor = blackBG
            self.btnProfileOutlet.backgroundColor = blueBG
            self.btnMenuOutlet.backgroundColor = blackBG
            
            self.btnHomeOutlet.setImage(UIImage(named: "img_home-hover\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            self.btnSearchOutlet.setImage(UIImage(named: "img_search-hover\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            self.btnProfileOutlet.setImage(UIImage(named: "img_profile\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            self.btnMenuOutlet.setImage(UIImage(named: "img_menu-hover\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            
        }
    }
   
    func clearSearchPreference(){
        //MARK: Clear all filter value
        General.removeSaved("search_user_type")
        General.removeSaved("search_home_country")
        General.removeSaved("search_home_state")
        General.removeSaved("search_home_city")
        General.removeSaved("search_age")
        General.removeSaved("search_ethnicity")
        General.removeSaved("search_language")
        General.removeSaved("search_gender")
        General.removeSaved("search_children")
        General.removeSaved("search_interest")
        General.removeSaved("search_relationship")
        General.removeSaved("search_branch_name")
        General.removeSaved("search_military_base")
        General.removeSaved("search_rank")
        General.removeSaved("search_job")
        General.removeSaved("search_paygrade")
        General.removeSaved("search_dependent")
        General.removeSaved("search_loc_country")
        General.removeSaved("search_loc_state")
        General.removeSaved("search_loc_city")
        
        General.removeSaved("search_loc_latitude")
        General.removeSaved("search_loc_longitude")
        General.removeSaved("search_radius")
        //MARK: Clear filter
        General.saveData("0", name: "isFilterApplied")
    }
//TODO: - UIButton Action
    
    
    @IBAction func btnHomeClick(sender: AnyObject) {
        selectViewController(0)
    }
    
    
    @IBAction func btnSearchClick(sender: AnyObject) {
         selectViewController(1)
    }
    
    @IBAction func btnMenuClick(sender: AnyObject) {
      //  self.sideMenuViewController?.presentRightMenuViewController()
       // self.SSASideMenu.presentRightMenuViewController(self)
       self.presentRightMenuViewController()
      // SSASideMenu._presentRightMenuViewController(self)
    }
    @IBAction func btnProfileClick(sender: AnyObject) {
         selectViewController(2)
    }
}
