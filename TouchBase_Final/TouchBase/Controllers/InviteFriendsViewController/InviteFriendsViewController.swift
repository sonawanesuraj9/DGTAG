//
//  InviteFriendsViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 06/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import FBSDKShareKit
import MessageUI
import Mixpanel

class InviteFriendsViewController: UIViewController,FBSDKAppInviteDialogDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
//TODO: - Controls
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    
//TODO: - Let's Code    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func btnFacebookInviteClick(sender: AnyObject) {
        //Mixpanel:
        let uid = General.loadSaved("user_id")
        Mixpanel.mainInstance().identify(distinctId: uid)
        Mixpanel.mainInstance().track(event: "Facebook Invite Tap",
                                      properties: ["Facebook Invite Tap" : "Facebook Invite Tap"])

        
        
        let content : FBSDKAppInviteContent = FBSDKAppInviteContent()
        
       content.appLinkURL = NSURL(string: "https://fb.me/1146219458791094")
        //content.appLinkURL = NSURL(string: "https://fb.me/1146219458791094")
        content.appInvitePreviewImageURL = NSURL(string: "http://milpeeps.com/dt-mobresources/appicon.png")
        //FBSDKAppInviteDialog.showWithContent(content, delegate: self)
        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
    }
    
    @IBAction func btnEmailInviteClick(sender: AnyObject) {
        
        //Mixpanel:
        let uid = General.loadSaved("user_id")
        Mixpanel.mainInstance().identify(distinctId: uid)
        Mixpanel.mainInstance().track(event: "Email Invite Tap",
                                      properties: ["Email Invite Tap" : "Email Invite Tap"])

        
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("DogTags App Invitation")
        mailComposerVC.setMessageBody("Download the DogTags app from: \n https://itunes.apple.com/us/app/dogtags-app/id1156363437?ls=1&mt=8  \n", isHTML: false)
        self.presentViewController(mailComposerVC, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnTextInviteClick(sender: AnyObject) {
        if(!MFMessageComposeViewController.canSendText()){
            let alert = UIAlertController(title: "DogTags App", message: "Your device doesn't support SMS!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (value:UIAlertAction) in
                //
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else{
            
            //Mixpanel:
            let uid = General.loadSaved("user_id")
            Mixpanel.mainInstance().identify(distinctId: uid)
            Mixpanel.mainInstance().track(event: "Text Invite Tap",
                                          properties: ["Text Invite Tap" : "Text Invite Tap"])

           
            let message : String = "Download the DogTags app from: \n https://itunes.apple.com/us/app/dogtags-app/id1156363437?ls=1&mt=8"
            let messageController : MFMessageComposeViewController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            messageController.body = message
            self.presentViewController(messageController, animated: true, completion: nil)
            
        }
      
    }
    
//TODO: Message client delegate method implementation
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
//TODO: Email Client Delegate method implementation
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?){
       dismissViewControllerAnimated(true, completion: nil)
    }
    
//TODO: Facebook delegate method
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!){
        print("-*****\(results)")
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!){
         print("-*****-\(error)")
    }
}
