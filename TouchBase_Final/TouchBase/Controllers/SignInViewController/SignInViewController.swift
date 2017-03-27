//
//  SignInViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 29/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Crashlytics
import Mixpanel


//Gloabl Variable
var user_dictonary : [String:AnyObject] = [:]


class SignInViewController: UIViewController {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    var deviceName : String = String()
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var leftImageFrame = CGRect()
    var returnKeyHandler : IQKeyboardReturnKeyHandler = IQKeyboardReturnKeyHandler()
    

    
//TODO: - Controls
    
    @IBOutlet weak var btnClearPassword: UIButton!
    @IBOutlet weak var btnClearEmail: UIButton!
    @IBOutlet weak var btnBacK: UIButton!
    @IBOutlet weak var txtEmailAddress: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //IQKeyboardReturnKeyHandler Method
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        
         //Crashlytics.sharedInstance().crash()

        
        
        //Uncomment below line
      // self.txtPassword.text = "test123"
      // self.txtEmailAddress.text = "test@gmail.com"
        
        // self.txtPassword.text = "SuperMan17!"
        //self.txtEmailAddress.text = "jody@dogtagsapp.com"
        
        
        //MARK: Print all fonts in projects
       /* for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }*/
    }

    @IBAction func crashButtonTapped(sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        deviceName = self.delObj.deviceName
        self.btnBacK.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        self.navigationController?.navigationBarHidden = true
        let autoVal = General.loadSaved("autologin")
        let signupAutoVal = General.loadSaved("NavToSignin")
        if(signupAutoVal == "1"){
            //Perform autologin for sigup user
            performAutoLoginAfterSignup()
            General.saveData("0", name: "NavToSignin")
        }else if( autoVal != "0"){
            //Perform Autologin for user
            performAutoLogin()
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initialization()
        initializeTextView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - Function
    func initializeTextView(){
        
        leftImageFrame = CGRectMake(0, 0, 30, 20)
        
        //3
        txtEmailAddress.leftViewMode = UITextFieldViewMode.Always
        let emailImageView = UIImageView(frame: leftImageFrame)
        var emailImage = UIImage()
        emailImageView.contentMode = .Center
        
        emailImage = UIImage(named: "img_email-id-input\(self.deviceName)")!
        emailImageView.image = emailImage
        txtEmailAddress.leftView = emailImageView
        txtEmailAddress.keyboardType = .EmailAddress
        
        //4
        txtPassword.leftViewMode = UITextFieldViewMode.Always
        let passImageView = UIImageView(frame: leftImageFrame)
        var passImage = UIImage()
        passImageView.contentMode = .Center
        
        passImage = UIImage(named: "img_password-input\(self.delObj.deviceName)")!
        passImageView.image = passImage
        txtPassword.leftView = passImageView
        
    }
    
    func initialization(){
        
        self.txtEmailAddress.attributedPlaceholder = NSAttributedString(string:"Email Address",
                                                                      attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                        attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        
        self.txtEmailAddress.tintColor = cust.textTintColor
        self.txtPassword.tintColor = cust.textTintColor
    }
    
    func performAutoLogin(){
        //autologin
        
        // 1. Login API
        self.txtPassword.text = General.loadSaved("login_password")
        self.txtEmailAddress.text = General.loadSaved("login_username")
        let email = self.txtEmailAddress.text
        let password = self.txtPassword.text
        
        
        if(self.txtPassword.text != "" && self.txtEmailAddress.text != ""){
            if  GeneralUI_UI.validateEmail(txtEmailAddress, name: "Email") &&
            GeneralUI_UI.validateBasic(txtPassword, name: "Password", min: 5)
            {
            
                let params: [String: AnyObject] = ["uemail": email!, "upwd": password! ]
                doLogin(params)
                self.view.endEditing(true)
            }
        }
    }
    
    
    func performAutoLoginAfterSignup(){
        //autologin
        
        // 1. Login API
        self.txtPassword.text = General.loadSaved("upwd")
        self.txtEmailAddress.text = General.loadSaved("uemail")
        let email = self.txtEmailAddress.text
        let password = self.txtPassword.text
        
         if(self.txtPassword.text != "" && self.txtEmailAddress.text != ""){
        
            if  GeneralUI_UI.validateEmail(txtEmailAddress, name: "Email") &&
                GeneralUI_UI.validateBasic(txtPassword, name: "Password", min: 5)
            {
            
                let params: [String: AnyObject] = ["uemail": email!, "upwd": password! ]
                doLogin(params)
                self.view.endEditing(true)
            }
        }
    }

 
//TODO: - UIButton Action
    
    
    @IBAction func btnBackClick(sender: AnyObject) {
        General.saveData("0", name: "autologin")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnSignInClick(sender: AnyObject) {
        
        
        // 1. Login API
        let email = txtEmailAddress.text
        let password = txtPassword.text
        
        if  GeneralUI_UI.validateEmail(txtEmailAddress, name: "Email") &&
            GeneralUI_UI.validateBasic(txtPassword, name: "Password", min: 5)
            {
        
            let params: [String: AnyObject] = ["uemail": email!, "upwd": password! ]
            doLogin(params)
            self.view.endEditing(true)
        }

        
        
    }
    
    @IBAction func btnForgotPasswordClick(sender: AnyObject) {
        let forgotVC = self.storyboard?.instantiateViewControllerWithIdentifier("idForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    @IBAction func btnClearEmailClick(sender: AnyObject) {
        self.txtEmailAddress.text = ""
        self.txtEmailAddress.becomeFirstResponder()
    }
    
    
    
    @IBAction func btnClearPasswordClick(sender: AnyObject) {
        self.txtPassword.text = ""
        self.txtPassword.becomeFirstResponder()
    }
    
    
//TODO: - Web service / API implementation
    
    func doLogin(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.LOGIN, multipartFormData: {
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
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                    } else {
                                        
                                           let id = json["user_id"].stringValue
                                           let user_token = json["user_token"].stringValue
                                            General.saveData("\(id)", name: "user_id")
                                            General.saveData("\(user_token)", name: "user_token")
                                        
                                        //MARK: User Defaults
                                        General.saveData(self.txtEmailAddress.text!, name: "login_username")
                                        General.saveData(self.txtPassword.text!, name: "login_password")
                                        General.saveData("1", name: "autologin")
                                        
                                        //MARK: Links
                                        let privacyURL = json["privacy"].stringValue
                                        let termsURL = json["terms"].stringValue
                                        let faq = json["faq"].stringValue
                                        let aboutDogTags = json["about"].stringValue
                                        let is_paid = json["is_paid"].stringValue
                                        let is_public = json["is_public"].stringValue
                                        let reference_number = json["reference_number"].stringValue
                                        let verification_pending = json["verification_pending"].stringValue
                                        let branch_id = json["branch_id"].stringValue
                                        let user_typeid = json["user_typeid"].stringValue
                                        
                                        
                                        //let verification_pending = "0"
                                        
                                        
                                        General.saveData(privacyURL, name: "privacyURL")
                                        General.saveData(termsURL, name: "termsURL")
                                        General.saveData(faq, name: "faq")
                                        General.saveData(aboutDogTags, name: "aboutDogTags")
                                        General.saveData(is_paid, name: "is_paid")
                                        General.saveData(is_public, name: "is_public")
                                        General.saveData(reference_number, name: "reference_number")
                                        General.saveData(verification_pending, name: "verification_pending")
                                        General.saveData(branch_id, name: "branch_id")
                                        General.saveData(user_typeid, name: "user_typeid")
                                        
                                        //MARK: If user is verified then
                                        /*if(verification_pending == "1"){
                                            //MARK: Track user is verified or not
                                            let prevTrackOfVerified = General.loadSaved("prevTrackOfVerified")
                                            if(prevTrackOfVerified == "1"){
                                            }else{
                                            //MARK: Track User has created Account
                                         Mixpanel.mainInstance().track(event: "Verified Account",
                                         properties: ["Verified Account" : "Verified Account"])

                                          
                                            General.saveData("1", name: "prevTrackOfVerified")
                                         }
                                        }*/
                                        
                                        
                                        //MixPanel
                                        let aliasStatus = General.loadSaved("isAlias")
                                        
                                        if aliasStatus != "Y"{
                                            // This makes the current ID (an auto-generated GUID)
                                            // and '13793' interchangeable distinct ids.
                                            Mixpanel.mainInstance().createAlias(String(id), distinctId: Mixpanel.mainInstance().distinctId)
                                            // mixpanel.createAlias(id, forDistinctID: mixpanel.distinctId)
                                            // You must call identify if you haven't already
                                            // (e.g., when your app launches).
                                            Mixpanel.mainInstance().identify(distinctId: Mixpanel.mainInstance().distinctId)
                                            General.saveData("Y", name: "isAlias")
                                        }
                                        
                                        
                                        
                                        
                                        
                                            //MARK : Setup SSASideMenu
                                        let containerVC = (self.storyboard?.instantiateViewControllerWithIdentifier("rootController"))! as UIViewController
                                        self.navigationController?.pushViewController(containerVC, animated: true)
                                      
                                        
                                        //MARK: WS to update badge count
                                        let para : [String : AnyObject] = ["user_id": id]
                                        self.updateBadge(para)
                                        
                                        
                                            print("You are in successful block")
                                        
                                    }
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
    
    
    func updateBadge(params: [String: AnyObject]) {
        
        print(params)
       
        Alamofire.upload(.POST, Urls_UI.UPDATE_BADGE, multipartFormData: {
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
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                print("JSON: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].string!)
                                    } else {
                                        print("You are in successful block")
                                        
                                    }
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

    
    
    
}
