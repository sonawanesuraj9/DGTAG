//
//  EditProfileContainerVC.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 02/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class EditProfileContainerVC: UIViewController {
    
    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate

    
//TODO: - Controls
    
    @IBOutlet weak var btnSaveOutlet: UIButton!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    
    
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditProfileContainerVC.dismissMeNotifiction(_:)), name:"dismissEditProfile", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        self.btnSaveOutlet.setImage(UIImage(named: "img_save\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - Function
    
    func dismissMeNotifiction(notification: NSNotification){
        //Take Action on Notification
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnSaveClick(sender: AnyObject) {
        /*let vCtrl = self.storyboard?.instantiateViewControllerWithIdentifier("idEditProfileTableViewController") as! EditProfileTableViewController
         vCtrl.postData()*/
    }
}