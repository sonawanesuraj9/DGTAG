//
//  SignupFirstStepViewController.swift
//  DogTags
//
//  Created by vijay kumar on 28/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JDropDownAlert
import SwiftOverlays
import Mixpanel

class SignupFirstStepViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,KACircleCropViewControllerDelegate {
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust: CustomClass_Dev = CustomClass_Dev()
    var returnKeyHandler : IQKeyboardReturnKeyHandler = IQKeyboardReturnKeyHandler()
    
    var leftImageFrame = CGRect()
    var picker = UIImagePickerController()
    var userAvatar: UIImage!
    
    var iAgree : Bool = Bool()
    @IBOutlet weak var btnTermsSwitch: UISwitch!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnUploadOutlet: UIButton!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    @IBOutlet weak var txtConfEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
         initializeTextView()
        initPlaceholder()
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /**
     Function to set left side images for each UITextField
     - returns: this will not return anythin
     **/
    func initializeTextView(){
        
        leftImageFrame = CGRectMake(0, 0, 30, 20)
        //1
        txtFirstName.leftViewMode = UITextFieldViewMode.Always
        let FirstImageView = UIImageView(frame: leftImageFrame)
        var FirstImage = UIImage()
        FirstImageView.contentMode = .Center
        
        FirstImage = UIImage(named: "img_name-signup\(self.delObj.deviceName)")!
        FirstImageView.image = FirstImage
        txtFirstName.leftView = FirstImageView
        
        //2
        txtLastName.leftViewMode = UITextFieldViewMode.Always
        let LastImageView = UIImageView(frame: leftImageFrame)
        var LastImage = UIImage()
        LastImageView.contentMode = .Center
        
        LastImage = UIImage(named: "img_name-signup\(self.delObj.deviceName)")!
        LastImageView.image = LastImage
        txtLastName.leftView = LastImageView
        
        //3
        txtEmailAddress.leftViewMode = UITextFieldViewMode.Always
        let emailImageView = UIImageView(frame: leftImageFrame)
        var emailImage = UIImage()
        emailImageView.contentMode = .Center
        
        emailImage = UIImage(named: "img_email-id-input\(self.delObj.deviceName)")!
        emailImageView.image = emailImage
        txtEmailAddress.leftView = emailImageView
        
        //3-1
        //3
        txtConfEmail.leftViewMode = UITextFieldViewMode.Always
        let confemailImageView = UIImageView(frame: leftImageFrame)
        var confemailImage = UIImage()
        confemailImageView.contentMode = .Center
        
        confemailImage = UIImage(named: "img_email-id-input\(self.delObj.deviceName)")!
        confemailImageView.image = confemailImage
        txtConfEmail.leftView = confemailImageView
        
        //4
        txtPassword.leftViewMode = UITextFieldViewMode.Always
        let passImageView = UIImageView(frame: leftImageFrame)
        var passImage = UIImage()
        passImageView.contentMode = .Center
        
        passImage = UIImage(named: "img_password-input\(self.delObj.deviceName)")!
        passImageView.image = passImage
        txtPassword.leftView = passImageView
        
        //5
        txtConfirmPassword.leftViewMode = UITextFieldViewMode.Always
        let confImageView = UIImageView(frame: leftImageFrame)
        var confImage = UIImage()
        confImageView.contentMode = .Center
        
        confImage = UIImage(named: "img_password-input\(self.delObj.deviceName)")!
        confImageView.image = confImage
        txtConfirmPassword.leftView = confImageView
        
        self.txtFirstName.autocapitalizationType = .Words
        self.txtLastName.autocapitalizationType = .Words
        
        self.navigationView.backgroundColor = self.cust.navBackgroundColor
        self.view.backgroundColor = self.cust.mainBackgroundColor
        
        self.txtEmailAddress.keyboardType = UIKeyboardType.EmailAddress
        self.txtConfEmail.keyboardType = UIKeyboardType.EmailAddress
    }
    
    
    /**
     Initialize design section for signup screen
     
     - returns: Nothing to return
     */
    func initPlaceholder(){
        //1
        self.txtFirstName.attributedPlaceholder = NSAttributedString(string:"First Name",
                                                                        attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        self.txtFirstName.tintColor = cust.textTintColor
        
        //2
        
        self.txtLastName.attributedPlaceholder = NSAttributedString(string:"Last Name",
                                                                        attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
         self.txtLastName.tintColor = cust.textTintColor
        
        //3
        self.txtEmailAddress.attributedPlaceholder = NSAttributedString(string:"Email Address",
                                                                        attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        self.txtEmailAddress.tintColor = cust.textTintColor
        
        //3-1
        //3
        self.txtConfEmail.attributedPlaceholder = NSAttributedString(string:"Confirm Email Address",
                                                                        attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        self.txtConfEmail.tintColor = cust.textTintColor
        
        //4
        
        self.txtConfirmPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password",
                                                                        attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
         self.txtConfirmPassword.tintColor = cust.textTintColor
        
        //5
        
        self.txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                    attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        self.txtPassword.tintColor = cust.textTintColor
        
        
        //6
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        self.btnUploadOutlet.setBackgroundImage(UIImage(named: "img_profile-pic-upload\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        //7
        self.txtFirstName.textColor = cust.textColor
        self.txtLastName.textColor = cust.textColor
        self.txtConfirmPassword.textColor = cust.textColor
        self.txtPassword.textColor = cust.textColor
        self.txtEmailAddress.textColor = cust.textColor
        self.txtConfEmail.textColor = cust.textColor
        
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtConfirmPassword.delegate = self
        self.txtPassword.delegate = self
        self.txtEmailAddress.delegate = self
        self.txtConfEmail.delegate = self
    }
    
    @IBAction func BackButtonClick(sender:AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func btnSubmitClick(sender: AnyObject) {
        
        // 1. Register API
        let firstname = txtFirstName.text
        let lastname = txtLastName.text
        let email = txtEmailAddress.text
        let password = txtPassword.text
        
        
        if  GeneralUI.validateBasic(txtFirstName, name: "First Name", min: 2) &&
            GeneralUI.validateBasic(txtLastName, name: "Last Name", min: 1) &&
            GeneralUI.validateEmail(txtEmailAddress, name: "Email") &&
            GeneralUI.validateEmail(txtConfEmail, name: "Confirm Email") &&
            GeneralUI.validateBasic(txtPassword, name: "Password", min: 5) &&
            GeneralUI.validateCEmail(txtEmailAddress, textField2: txtConfEmail) &&
            GeneralUI.validateCPassword(txtPassword, textField2: txtConfirmPassword) &&
            validateAvatar() && GeneralUI.validateAgree(iAgree) {
            
            // self.showWaitOverlayWithText("Please wait...")
            let params: [String: AnyObject] = [ "ufname": firstname!, "ulname": lastname!, "uemail": email!, "upwd": password! ]
            
            doRegister(params)
            self.view.endEditing(true)
        }
       
    }
    
    
    
    func doRegister(params: [String: AnyObject]) {
        
        
        self.cust.showLoadingCircle()
        self.view.userInteractionEnabled = false
        print(params)
        Alamofire.upload(.POST, Urls.REGISTER_STEP1, multipartFormData: {
            multipartFormData in
            
            let filename = GeneralUI_UI.generateRandomImageName()
            print(":filename\(filename)")
            if let imageData = UIImageJPEGRepresentation(self.userAvatar, 0.8) {
                multipartFormData.appendBodyPart(data: imageData, name: "uprofile", fileName: "\(filename).jpg", mimeType: "image/jpeg")
            }
            
            for (key, value) in params {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            }, encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON {
                        response in
                       self.cust.hideLoadingCircle()
                        self.view.userInteractionEnabled = true
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                let uemail : String =  (params["uemail"] as? String)!
                                let upwd : String =  (params["upwd"] as? String)!
                                
                                
                                print("JSON: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                        GeneralUI.alert(json["message"].string!)
                                    } else {
                                        if let id = json["user_id"].int {
                                            General.saveData("\(id)", name: "user_id")
                                            
                                            
                                            // This makes the current ID (an auto-generated GUID)
                                            // and '13793' interchangeable distinct ids.
                                            Mixpanel.mainInstance().createAlias(String(id), distinctId: Mixpanel.mainInstance().distinctId)
                                           // mixpanel.createAlias(id, forDistinctID: mixpanel.distinctId)
                                            // You must call identify if you haven't already
                                            // (e.g., when your app launches).
                                            Mixpanel.mainInstance().identify(distinctId: Mixpanel.mainInstance().distinctId)
                                            General.saveData("Y", name: "isAlias")
                                            
                                            
                                            let signupSecondSetpVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupSecondStepViewController") as! SignupSecondStepViewController
                                             signupSecondSetpVC.userid = "\(id)"
                                             General.saveData(uemail, name: "uemail")
                                             General.saveData(upwd, name: "upwd")
                                            
                                             self.navigationController?.pushViewController(signupSecondSetpVC, animated: true)
                                        } else {
                                            GeneralUI.alert(json["status"].string!)
                                        }
                                    }
                                }
 
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    self.view.userInteractionEnabled = true                    
                     self.cust.hideLoadingCircle()
                    print(encodingError)
                }
        })
    }
    
    func validateAvatar() -> Bool {
        if userAvatar == nil {
            GeneralUI.alert("Please select a profile image!")
            return false
        }
        return true
    }
    
    @IBAction func pickPhoto(sender: UIButton) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func openGallary() {
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    //TODO: UITextFiled Delegate Method implementation
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker .dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
        let circleCropController = KACircleCropViewController(withImage: image!)
        circleCropController.delegate = self
        presentViewController(circleCropController, animated: false, completion: nil)
        
        
       /* userAvatar = image
        self.btnUploadOutlet.setImage(image, forState: .Normal)
        self.btnUploadOutlet.layer.cornerRadius = self.btnUploadOutlet.frame.size.width/2
        self.btnUploadOutlet.contentMode = .ScaleAspectFit*/
        
        //self.btnUploadOutlet.clipsToBounds = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK:  KACircleCropViewControllerDelegate methods
    
    func circleCropDidCancel() {
        //Basic dismiss
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func circleCropDidCropImage(image: UIImage) {
        //Same as dismiss but we also return the image
        
        userAvatar = image
        self.btnUploadOutlet.setImage(image, forState: .Normal)
        self.btnUploadOutlet.layer.cornerRadius = self.btnUploadOutlet.frame.size.width/2
        self.btnUploadOutlet.contentMode = .ScaleAspectFit
        self.btnUploadOutlet.clipsToBounds = true
        dismissViewControllerAnimated(false, completion: nil)
    }

    @IBAction func btnTermsClick(sender: AnyObject) {
        //Terms and Conditions
        let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navWebView") as! UINavigationController
        self.delObj.webViewIndex = 3
        self.presentViewController(noti, animated: true, completion: nil)
       
    }
    @IBAction func btnTermsSwitchChange(sender: AnyObject) {
        
        if(btnTermsSwitch.on){
            self.iAgree = true
        }else{
            self.iAgree = false
        }
    }
}