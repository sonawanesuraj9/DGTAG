//
//  UpgradeMemberVC.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 01/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit


class UpgradeMemberVC: UIViewController,UIPopoverPresentationControllerDelegate,Dimmable {

    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    var isPremium : Bool = Bool()
    
    
//TODO: - Controls
    
    @IBOutlet weak var btnDummy: UIButton!
    @IBOutlet weak var btnPremiumRadio: UIButton!
    @IBOutlet weak var btnFreeRadio: UIButton!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnPurchaseOutlet: UIButton!
    
//TODO: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
       
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       
        
        let tmpStatus = General.loadSaved("is_paid")
        if(tmpStatus == "1"){
            isPremium = true
            self.btnDummy.hidden = false
            self.btnPremiumRadio.setImage(UIImage(named: "radio-selected"), forState: UIControlState.Normal)
            self.btnPurchaseOutlet.hidden = false
        }else{
            isPremium = false
            self.btnDummy.hidden = true
            self.btnFreeRadio.setImage(UIImage(named: "radio-selected"), forState: UIControlState.Normal)
            self.btnPurchaseOutlet.hidden = true
        }
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dim(.In, alpha: dimLevel, speed: dimSpeed)
    }
    
    @IBAction func unwindFromSecondary(segue: UIStoryboardSegue) {
        dim(.Out, speed: dimSpeed)
    }

    

//TODO: - UIButton Action
    
    @IBAction func btnFreeRadioClick(sender: AnyObject) {
         self.btnPremiumRadio.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
        self.btnFreeRadio.setImage(UIImage(named: "radio-selected"), forState: UIControlState.Normal)
        isPremium = false
        self.btnPurchaseOutlet.hidden = true
        self.btnDummy.hidden = true
    }
    
    
    @IBAction func btnPremiumRadioClick(sender: AnyObject) {
        let verify = General.loadSaved("verification_pending")
        
        //MARK: Check verification is done or not
        if(verify == "1"){
        
            self.btnFreeRadio.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
            self.btnPremiumRadio.setImage(UIImage(named: "radio-selected"), forState: UIControlState.Normal)
            isPremium = true
            self.btnPurchaseOutlet.hidden = false
            let ordPre = General.loadSaved("is_paid")
            if(ordPre == "1"){
                self.btnDummy.hidden = false
            }else{
                 self.btnDummy.hidden = true
            }
        }else{
           GeneralUI.alert(self.delObj.notApprovedMessage)
        }
    }
    
    
    @IBAction func btnDummyClick(sender: AnyObject) {
        let alreadyPremiumAlert = UIAlertController(title: "DogTags", message: "You already have Premium Membership", preferredStyle: UIAlertControllerStyle.Alert)
        alreadyPremiumAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (value:UIAlertAction) in
            //
            
        }))
        self.presentViewController(alreadyPremiumAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnPurchaseClick(sender: AnyObject) {
        
    }

}
