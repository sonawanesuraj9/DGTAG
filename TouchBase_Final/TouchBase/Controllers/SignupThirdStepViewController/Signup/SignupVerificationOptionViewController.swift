//
//  SignupVerificationOptionViewController.swift
//  DogTags
//
//  Created by vijay kumar on 28/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import JDropDownAlert
import SwiftOverlays
import ObjectMapper
import Haneke
import DLRadioButton
import DatePickerDialog
import Mixpanel

class SignupVerificationOptionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    @IBOutlet weak var pickDoc1Button: UIButton!
    @IBOutlet weak var pickDoc2Button: UIButton!
    @IBOutlet weak var pickDoc3Button: UIButton!
    @IBOutlet weak var pickDoc4Button: UIButton!
    @IBOutlet weak var pickDoc5Button: UIButton!
    
    @IBOutlet weak var uniformStack: UIStackView!
    
    var picker = UIImagePickerController()
    var userDoc1: UIImage!
    var userDoc2: UIImage!
    var userDoc3: UIImage!
    var userDoc4: UIImage!
    var userDoc5: UIImage!
    
    var doc = 0
    var needFinish = false
    
    //Array
    var currentlyOpen : [String] = []
    
    //Tap Gesture
    var emailTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    var documentTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    var refernceTapGesture  : UITapGestureRecognizer = UITapGestureRecognizer()
    var instantTapGesture  : UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var navigationView: UIView!
    
    //Top Views
    @IBOutlet weak var militaryEmailView: UIView!
    @IBOutlet weak var documentView: UIView!
    @IBOutlet weak var referenceView: UIView!
    
    @IBOutlet weak var instantView: UIView!
    
    //Expanded Views
    
    @IBOutlet weak var emailExpand: UIView!
    @IBOutlet weak var documentExpand: UIView!
    
    @IBOutlet weak var instantExpand: UIView!
    @IBOutlet weak var referenceExpand: UIView!
    
    //size contz
    @IBOutlet weak var firstBox: NSLayoutConstraint!
    @IBOutlet weak var secondBox: NSLayoutConstraint!
    @IBOutlet weak var thirdBox: NSLayoutConstraint!
    @IBOutlet weak var forthBox: NSLayoutConstraint!
    
    var userid: String!
    var branchid: String!
    // V1
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtRefNum: UITextField!
    @IBOutlet weak var txtSSNum: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        self.navigationView.backgroundColor = cust.navBackgroundColor
        self.view.backgroundColor = cust.mainBackgroundColor
        
        pickDoc1Button.layer.cornerRadius = self.pickDoc1Button.frame.size.width / 2
        pickDoc1Button.clipsToBounds = true
        pickDoc2Button.layer.cornerRadius = self.pickDoc2Button.frame.size.width / 2
        pickDoc2Button.clipsToBounds = true
        pickDoc3Button.layer.cornerRadius = self.pickDoc3Button.frame.size.width / 2
        pickDoc3Button.clipsToBounds = true
        pickDoc4Button.layer.cornerRadius = self.pickDoc4Button.frame.size.width / 2
        pickDoc4Button.clipsToBounds = true
        pickDoc5Button.layer.cornerRadius = self.pickDoc5Button.frame.size.width / 2
        pickDoc5Button.clipsToBounds = true
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        self.delObj.isOnVerificationMethod = true
        
        initialization()
        initVerificationMethod()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initialization() {
        //1
        //self.militaryEmailView.userInteractionEnabled = true
        self.militaryEmailView.addGestureRecognizer(emailTapGesture)
        self.emailTapGesture.addTarget(self, action: #selector(SignupVerificationOptionViewController.expandEmail))
        
        //2
        //self.documentView.userInteractionEnabled = true
        self.documentView.addGestureRecognizer(documentTapGesture)
        self.documentTapGesture.addTarget(self, action: #selector(SignupVerificationOptionViewController.expandDocument))
        //3
        //self.referenceView.userInteractionEnabled = true
        self.referenceView.addGestureRecognizer(refernceTapGesture)
        self.refernceTapGesture.addTarget(self, action: #selector(SignupVerificationOptionViewController.expandReference))
        //4
        //self.instantView.userInteractionEnabled = true
        self.instantView.addGestureRecognizer(instantTapGesture)
        self.instantTapGesture.addTarget(self, action: #selector(SignupVerificationOptionViewController.expandInstant))
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    
    func initVerificationMethod(){
         self.militaryEmailView.hidden = true
        self.uniformStack.userInteractionEnabled = false
        
        print("Selected info : \(self.delObj.signupSelectedIndex)")
        if(self.delObj.signupSelectedIndex == 1){
            self.referenceView.userInteractionEnabled = false
            self.referenceView.alpha = 0.4
            self.uniformStack.userInteractionEnabled = true
        }else if(self.delObj.signupSelectedIndex == 2){
            self.pickDoc5Button.userInteractionEnabled = false
            self.pickDoc5Button.enabled = false
            self.militaryEmailView.userInteractionEnabled = false
            self.militaryEmailView.alpha = 0.4
        }else if(self.delObj.signupSelectedIndex == 3){
            self.pickDoc5Button.userInteractionEnabled = false
            self.pickDoc5Button.enabled = false
            self.militaryEmailView.userInteractionEnabled = false
            self.militaryEmailView.alpha = 0.4
        }
    }
    
    
    func postRegister(params: [String: AnyObject],msg:String) {
        
        self.cust.showLoadingCircle()
        Alamofire.request(.POST, Urls.REGISTER_STEP3, parameters: params)
            .responseJSON { response in
                self.removeAllOverlays()
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                        
                        self.cust.hideLoadingCircle()
                        
                        if let message = json["message"].string {
                            if message.containsString("success") {
                                if self.needFinish {
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                } else {
                                    //MARK: Track User has created Account
                                    Mixpanel.mainInstance().identify(distinctId: String(self.userid))
                                    Mixpanel.mainInstance().track(event: "Verification Submitted",
                                        properties: ["Verification Submitted" : "Verification Submitted"])

                                    
                                    let branchUpdate =  json["branch_message"].stringValue
                                    if(branchUpdate != ""){
                                        
                                        let tmpAlert = UIAlertController(title: "DogTags", message: branchUpdate, preferredStyle: UIAlertControllerStyle.Alert)
                                        
                                        tmpAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (value:UIAlertAction) in
                                            //
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                            self.displayAlert(msg)
                                        }))
                                       
                                        self.presentViewController(tmpAlert, animated: true, completion: nil)
                                    }else{
                                        self.displayAlert(msg)
                                    }
                                    
                                   
                                }
                            } else {
                                GeneralUI.alert(json["message"].string!)
                            }
                        }
                        
                    }
                case .Failure(let error):
                    self.cust.hideLoadingCircle()
                    print(error)
                }
            }
        
    }

    func displayAlert(msg:String){
        let tmpAlert = UIAlertController(title: "DogTags", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        tmpAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (value:UIAlertAction) in
            //
            self.moveLogin()
        }))
        self.presentViewController(tmpAlert, animated: true, completion: nil)
    }
    
    @IBAction func EmailVerification(sender: UIButton) {
        
        let email = txtEmail.text
        
        if  GeneralUI.validateEmail(txtEmail, name: "Email") {
            //self.showWaitOverlayWithText("Please wait...")
            let params: [String: AnyObject] = [ "userid": userid, "verifyMethod": "verify_mil_email", "verifyParam": email! ]
            let msg = "An Email has been sent to your Military Email Address with verification link. Please verify your account."
            
            
            if !validateMilEmailText(email!) {
                //GeneralUI.alert(")
                let tmpAlert = UIAlertController(title: "Please Type Correct Military Email Address!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                tmpAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (value:UIAlertAction) in
                    //
                    self.txtEmail.becomeFirstResponder()
                }))
                self.presentViewController(tmpAlert, animated: true, completion: nil)
                
            } else {
                postRegister(params,msg: msg)
            }
        }
    }
    
    func validateMilEmailText(enteredEmail: String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.mil"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail.lowercaseString)
        
    }
    
    
    @IBAction func DocVerification(sender: UIButton) {
        
        if validateAvatar() {
            let filename = GeneralUI_UI.generateRandomImageName()
            print(":filename\(filename)")
            
            
            self.view.userInteractionEnabled = false
            let params: [String: AnyObject] = [ "userid": userid, "verifyMethod": "verify_doc", "verifyParam": "" ]
            
            self.showWaitOverlayWithText("Please wait...")
            Alamofire.upload(.POST, Urls.REGISTER_STEP3, multipartFormData: {
                multipartFormData in
                
                if(self.userDoc1 != nil){
                    if let imageData = UIImageJPEGRepresentation(self.userDoc1, 0.6) {
                    multipartFormData.appendBodyPart(data: imageData, name: "militaryid", fileName: "\(filename).jpg", mimeType: "image/jpeg")
                    }
                }
                
                if(self.userDoc2 != nil){
                    if let imageData = UIImageJPEGRepresentation(self.userDoc2, 0.6) {
                    multipartFormData.appendBodyPart(data: imageData, name: "militaryorder", fileName: "\(filename).jpg", mimeType: "image/jpeg")
                    }
                }
                
                if(self.userDoc3 != nil){
                    if let imageData = UIImageJPEGRepresentation(self.userDoc3, 0.6) {
                    multipartFormData.appendBodyPart(data: imageData, name: "militarydd", fileName: "\(filename).jpg", mimeType: "image/jpeg")
                    }
                }
                
                if(self.userDoc4 != nil){
                    if let imageData = UIImageJPEGRepresentation(self.userDoc4, 0.6) {
                    multipartFormData.appendBodyPart(data: imageData, name: "militaryles", fileName: "\(filename).jpg", mimeType: "image/jpeg")
                    }
                }
                //NEed to code
                if(self.userDoc5 != nil){
                    if let imageData = UIImageJPEGRepresentation(self.userDoc5, 0.6) {
                        multipartFormData.appendBodyPart(data: imageData, name: "militaryuni", fileName: "\(filename).jpg", mimeType: "image/jpeg")
                    }
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
                            
                            self.removeAllOverlays()
                            self.view.userInteractionEnabled = true
                            
                            switch response.result {
                            case .Success:
                                if let value = response.result.value {
                                    let json = JSON(value)
                                    print("json:\(json)")
                                    if let message = json["message"].string {
                                        if message.containsString("success") {
                                            
                                            //MARK: Track User has created Account
                                            Mixpanel.mainInstance().identify(distinctId: String(self.userid))
                                            Mixpanel.mainInstance().track(event: "Verification Submitted",
                                                properties: ["Verification Submitted" : "Verification Submitted"])

                                            
                                            let tmpAlert = UIAlertController(title: "DogTags", message: "You Will Be Verified Shortly", preferredStyle: UIAlertControllerStyle.Alert)
                                            
                                            tmpAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (value:UIAlertAction) in
                                                if self.needFinish {
                                                        self.dismissViewControllerAnimated(true, completion: nil)
                                                } else {
                                                        self.moveLogin()
                                                }
                                            }))
                                             self.presentViewController(tmpAlert, animated: true, completion: nil)
                                        } else {
                                            GeneralUI.alert(json["message"].string!)
                                        }
                                    }
                                    
                                }
                            case .Failure(let error):
                                GeneralUI.alert(error.localizedDescription)
                                print(error)
                            }
                            
                            
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
            })
        }
        
    }
    
    @IBAction func RefNumVerification(sender: UIButton) {
        
        // 1.Army: 'armj7jkl'
        // 2.Air force: 'airj7jkl'
        // 3.Coast Guard: 'cogj7jkl'
        // 4.Marine Corps:'marj7jkl'
        // 5.Navy:'navj7jkl'
        
        let number = txtRefNum.text
        /*if  validateReferenceNo(txtRefNum, name: "Reference Number", id: branchid) {
            
        }*/
        let params: [String: AnyObject] = [ "userid": userid, "verifyMethod": "verify_ref_number", "verifyParam": number! ]
        let msg = "Your Account Verification request with the Military Reference Number has been sent to DogTags admininstrator and Military Member. You will be notified via the email once your account will be approved and ready to use."
        postRegister(params,msg: msg)
    }
    
    func validateReferenceNo(textField: UITextField, name: String, id: String) -> Bool {
        
        var branchNames = ["","Army","Air force","Coast Guard","Marine Corps","Navy"]
        var branchIDs = ["","arm","air","cog","mar","nav"]
        
        let text: String = textField.text!
        let alert = JDropDownAlert()
        
        if text.characters.count == 0 {
            alert.alertWith("Please enter \(name)!")
            textField.becomeFirstResponder()
            return false
        } else if text.characters.count < 4 {
            alert.alertWith("Please enter vaild \(name)!")
            textField.becomeFirstResponder()
            return false
        } else {
            
            var start3 = text
            start3 = start3[start3.startIndex..<start3.startIndex.advancedBy(3)]
            
            if start3 == branchIDs[Int(id)!] {
                return true
            } else {
                alert.alertWith("Your profile selected Branch doesnot match with Reference No. Branch.(\(branchNames[Int(id)!]))")
                textField.becomeFirstResponder()
                return false
            }
        }
        
        return true
    }
    
    @IBAction func InstantVerification(sender: UIButton) {
        let number = txtSSNum.text
        if  GeneralUI.validateBasic(txtSSNum, name: "SSN Number", min: 5) {
            let params: [String: AnyObject] = [ "userid": userid, "verifyMethod": "verify_instant", "verifyParam": number! ]
            let msg = ""
            postRegister(params,msg: msg)
        }
    }
    
    func moveLogin() {
        if(!self.delObj.isFromMenu){
            let idViewController = self.storyboard?.instantiateViewControllerWithIdentifier("idViewController") as! ViewController
            General.saveData("1", name: "autologin")
            General.saveData("1", name: "NavToSignin")
            self.navigationController?.pushViewController(idViewController, animated: true)
        }else{
            //MARK: User is naviagted after login to app
           self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func validateAvatar() -> Bool {
        let alert = JDropDownAlert()
        if userDoc1 == nil &&  userDoc2 == nil &&  userDoc3 == nil &&  userDoc4 == nil &&  userDoc5 == nil {
            alert.alertWith("Please choose any one document")
            return false
        }
        return true
    }
    
    func initView() {
        self.firstBox.constant = 0.0
        self.secondBox.constant = 0.0
        self.thirdBox.constant = 0.0
        self.forthBox.constant = 0.0
    }
    
    func expandEmail(){
        initView()
        self.firstBox.constant = 95.0
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func expandDocument(){
        initView()
        self.secondBox.constant = 360 //320.0
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func expandReference(){
        initView()
        self.thirdBox.constant = 85.0
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func expandInstant(){
        initView()
        self.forthBox.constant = 120.0
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
        
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnSkipForNow(sender: AnyObject) {
        if self.needFinish {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.moveLogin()
        }
       /* if(self.delObj.isFromEditProfile){
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            moveLogin()
        }*/
        
    }
    
    @IBAction func pickDoc(sender: UIButton) {
        showPickerDialog(sender.tag)
    }
    
    func showPickerDialog(doc: Int) {
        self.doc = doc
        
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Take Picture", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Use existing picture", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            self.dismissViewControllerAnimated(true, completion: nil)
           // self.openGallary()
        }
        
        let removeAction = UIAlertAction(title: "Remove picture", style: UIAlertActionStyle.Destructive) {
            UIAlertAction in
            
            if doc == 1 {
                self.pickDoc1Button.setImage(UIImage(named: "img_profile-pic-upload_i5"), forState: .Normal)
                self.userDoc1 = nil
            } else if doc == 2 {
                self.pickDoc2Button.setImage(UIImage(named: "img_profile-pic-upload_i5"), forState: .Normal)
                self.userDoc2 = nil
            } else if doc == 3 {
                self.pickDoc3Button.setImage(UIImage(named: "img_profile-pic-upload_i5"), forState: .Normal)
                self.userDoc3 = nil
            }else if doc == 4 {
                self.pickDoc4Button.setImage(UIImage(named: "img_profile-pic-upload_i5"), forState: .Normal)
                self.userDoc4 = nil
            } else {
                self.pickDoc5Button.setImage(UIImage(named: "img_profile-pic-upload_i5"), forState: .Normal)
                self.userDoc5 = nil
            }
            
             self.dismissViewControllerAnimated(true, completion: nil)
        }
        
         alert.addAction(cameraAction)
         alert.addAction(gallaryAction)
         alert.addAction(cancelAction)
         alert.addAction(removeAction)
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
    
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker .dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
                
        if doc == 1 {
            userDoc1 = image
            pickDoc1Button.setImage(image, forState: .Normal)
        } else if doc == 2 {
            userDoc2 = image
            pickDoc2Button.setImage(image, forState: .Normal)
        } else if doc == 3 {
            userDoc3 = image
            pickDoc3Button.setImage(image, forState: .Normal)
        }else if doc == 4 {
            userDoc4 = image
            pickDoc4Button.setImage(image, forState: .Normal)
        } else {
            userDoc5 = image
            pickDoc5Button.setImage(image, forState: .Normal)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnExample1Click(sender: AnyObject) {
        let ex = self.storyboard?.instantiateViewControllerWithIdentifier("idMilIDExampleViewController") as! MilIDExampleViewController
        ex.id = "1"
        self.presentViewController(ex, animated: true, completion: nil)
    }
    
    @IBAction func btnExample2Click(sender: AnyObject) {
        let ex = self.storyboard?.instantiateViewControllerWithIdentifier("idMilIDExampleViewController") as! MilIDExampleViewController
        ex.id = "2"
        self.presentViewController(ex, animated: true, completion: nil)
    }

}
