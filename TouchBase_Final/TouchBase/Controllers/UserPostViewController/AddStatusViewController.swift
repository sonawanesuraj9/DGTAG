//
//  AddStatusViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 31/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

import TwitterKit
import Fabric

import Mixpanel
import FBSDKShareKit


class AddStatusViewController: UIViewController,FBSDKSharingDelegate,UITextViewDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let placeholderTextColor : UIColor = UIColor.lightGrayColor()
    var is_textEdited : Bool = Bool()
    let cust : CustomClass_Dev = CustomClass_Dev()
    
//TODO: - Controls
    
    @IBOutlet weak var btnDoneOutlet: UIButton!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtPost: UITextView!
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var imgDogTags: UIImageView!
    
    
    
    
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initialization()
        initPlaceholderForTextView()
        
        //MARK: Display user info
        initLoginUserInfo()
        
        //MARK: user come across this step from edit post
        if(self.delObj.isPostEditEnable){
            initEditPost()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - Function
    
    /**
     Placeholder text for UITextView is set
     
     - returns: nothing is return
     */
    func initPlaceholderForTextView(){
        txtPost.text = "What's on your mind? "
        txtPost.textColor = placeholderTextColor
        is_textEdited = false
        self.btnDoneOutlet.hidden = true
        txtPost.delegate = self
        self.txtPost.layer.borderWidth = 0.5
        self.txtPost.autocorrectionType = .Yes
        self.txtPost.layer.borderColor = self.placeholderTextColor.CGColor
         self.btnBack.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    func initEditPost(){
        self.txtPost.textColor = UIColor.blackColor()
        is_textEdited = true
        self.btnDoneOutlet.hidden = false
        self.txtPost.text = postContainerSingleton.postData.postContent
    }
    /**
     General Initialization of controls
     
     - returns: nothing is return
     */
    func initialization(){
        self.imgProfile.image = UIImage(named: "profilepic.jpg")
       self.imgProfile.layer.cornerRadius =  self.imgProfile.frame.size.width/2
        self.imgProfile.clipsToBounds = true
        
        self.imgDogTags.image = UIImage(named: "img_dogtagBG\(self.delObj.deviceName)")
       
        
        self.btnFacebook.setImage(UIImage(named: "img_shareon-facebook\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        self.btnTwitter.setImage(UIImage(named: "img_shareon-twitter\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        self.btnPost.setImage(UIImage(named: "img_post-message\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    /**
     Display user details
     
     - returns: Nothing to Return
     */
    
    func initLoginUserInfo(){
        //name
        self.lblUserName.text = user_dictonary["user_fullname"] as? String
        
        //address
        self.lblLocation.text = user_dictonary["user_loc_city_state"] as? String
        
        //country
        self.lblCountry.text = user_dictonary["user_loc_country"] as? String
        
        //status
        self.lblSection.text = user_dictonary["user_branch"] as? String
        
        self.btnDoneOutlet.setTitle("Ok", forState: UIControlState.Normal)
        
        //DogTag design
        var dogTagID = user_dictonary["dogtag_batch"] as? String
        if(dogTagID == ""){
            dogTagID = "19"
        }
        if(dogTagID == "19"){
            self.lblUserName.textColor = UIColor.blackColor()
            self.lblLocation.textColor = UIColor.blackColor()
            self.lblCountry.textColor = UIColor.blackColor()
            self.lblSection.textColor = UIColor.blackColor()
        }else{
            self.lblUserName.textColor = UIColor.whiteColor()
            self.lblLocation.textColor = UIColor.whiteColor()
            self.lblCountry.textColor = UIColor.whiteColor()
            self.lblSection.textColor = UIColor.whiteColor()
        }
        self.imgDogTags.image = UIImage(named: "\(dogTagID!)\(self.delObj.deviceName)")

        
        
        //User profile
        let pic = user_dictonary["user_profile_pic"] as? String
        let ur = NSURL(string: Urls.ProfilePic_Base_URL + pic!)
        self.imgProfile.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "avatar_thumbnail.jpg"), options: SDWebImageOptions.RefreshCached)
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        self.imgProfile.clipsToBounds = true
    }
    
    
//TODO: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == placeholderTextColor{
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            is_textEdited = true
            self.btnDoneOutlet.hidden = false
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == txtPost{
            if textView.text.isEmpty{
                
                txtPost.text = "What's on your mind?"
                txtPost.textColor = placeholderTextColor
                is_textEdited = false
                self.btnDoneOutlet.hidden = true
            }
            
        }
    }

//TODO: - UIButton Action
    
    @IBAction func btnTwitterClick(sender: AnyObject) {
        // Use the TwitterKit to create a Tweet composer.
        let composer = TWTRComposer()
        
        // Prepare the Tweet with the poem and image.
        if(!is_textEdited){
            
        }else{
           let trimText = self.cust.trimString(self.txtPost.text!)
            composer.setText(trimText)
        }
        // Present the composer to the user.
        composer.showFromViewController(self) { result in
            if result == .Done {
                print("Tweet composition completed.")
            } else if result == .Cancelled {
                print("Tweet composition cancelled.")
            }
        }
    }
    
    @IBAction func btnFacebookClick(sender: AnyObject) {
        
        let trimString = self.cust.trimString(self.txtPost.text!)
        if(trimString != ""){
            let content = FBSDKShareLinkContent()
        
       
            content.contentURL = NSURL(string: "https://dogtagsapp.com")
            content.imageURL = NSURL(string: "http://milpeeps.com/dt-mobresources/appicon.png")
            content.contentTitle = "DogTags App"
            content.contentDescription = trimString
            let dialog = FBSDKShareDialog()
            dialog.shareContent = content
            dialog.fromViewController = self
            dialog.delegate = self
            dialog.mode = .Native
        
            if(!dialog.canShow())
            {
                print("within if")
                dialog.mode = .FeedBrowser
            
            }
            dialog.show()
        }
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        if(self.navigationController != nil){
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    @IBAction func btnPostClick(sender: AnyObject) {
        // 1. Add user post
        
        let trimmedString = self.txtPost.text.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if(self.delObj.isPostEditEnable){
            //MARK: Edit post
            if(is_textEdited && trimmedString.characters.count>0){
                let uID = General.loadSaved("user_id")
                let userToken = General.loadSaved("user_token")
                
                let postID = postContainerSingleton.postData.postID
                
                let params: [String: AnyObject] = ["userid": uID, "token_id": userToken,"type":"message","content":trimmedString,"photo_video":"","caption":"","post_id":postID! ]
                
                editPost(params)
                self.view.endEditing(true)
            }
        }else{
            //MARK: New post
            
            if(is_textEdited && trimmedString.characters.count>0){
                let uID = General.loadSaved("user_id")
                let userToken = General.loadSaved("user_token")
            
                let params: [String: AnyObject] = ["userid": uID, "token_id": userToken,"type":"message","content":trimmedString,"photo_video":"","caption":"" ]
                addNewPost(params)
                self.view.endEditing(true)
            }
        }
        
        
    }
    
    @IBAction func btnDoneClick(sender: AnyObject) {
        self.view.endEditing(true)
        self.btnDoneOutlet.hidden = true
        
    }
    
    
//MARK: - FBSDKSharingDelegate (Response After Facebook Sharing)
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        print("User Canceled")
        
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("user shared successfully result \(results)")
        
    }
    
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print("facebook error \(error)")
    }
    

    
//TODO: - Web service / API implementation
    
    func addNewPost(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.CREATE_NEW_POST, multipartFormData: {
            multipartFormData in
            
            for (key, value) in params {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            }, encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON {
                        response in
                        self.view.userInteractionEnabled = true
                        self.cust.hideLoadingCircle()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                print("JSON: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].string!)
                                    } else {
                                        GeneralUI_UI.alert(json["message"].string!)
                                        print("\(json["message"].string)")
                                        self.txtPost.resignFirstResponder()
                                       
                                        //MARK: Mixpanel
                                        let uid = General.loadSaved("user_id")
                                        Mixpanel.mainInstance().identify(distinctId: uid)
                                        Mixpanel.mainInstance().track(event: "Status Post",
                                            properties: ["Status Post" : "Status Post"])

                                        
                                        
                                        
                                        //MARK: User is on notification list screen, reload data
                                        NSNotificationCenter.defaultCenter().postNotificationName("PostReloadHomePage", object: nil)
                                        
                                        if(self.navigationController != nil){
                                            self.navigationController?.popViewControllerAnimated(true)
                                        }else{
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                        }
                                    }
                                }else{
                                    GeneralUI_UI.alert("\(json["message"].string)")
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
    func editPost(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.EDIT_POST, multipartFormData: {
            multipartFormData in
            
            for (key, value) in params {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            }, encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON {
                        response in
                        self.view.userInteractionEnabled = true
                        self.cust.hideLoadingCircle()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                print("JSON: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].string!)
                                    } else {
                                        GeneralUI_UI.alert(json["message"].string!)
                                        print("\(json["message"].string)")
                                        self.delObj.isPostEditEnable = false
                                        
                                        self.txtPost.resignFirstResponder()
                                        self.initPlaceholderForTextView()
                                        //MARK: User is on notification list screen, reload data
                                        NSNotificationCenter.defaultCenter().postNotificationName("PostReloadHomePage", object: nil)
                                        self.btnBack.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                                    }
                                }else{
                                    GeneralUI_UI.alert("\(json["message"].string)")
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                            self.cust.hideLoadingCircle()
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    self.cust.hideLoadingCircle()
                    print(encodingError)
                }
        })
    }
    

}
