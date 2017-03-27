//
//  ForgotPasswordViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 29/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ForgotPasswordViewController: UIViewController {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let cust : CustomClass_Dev = CustomClass_Dev()
    
//TODO: - Controls
    @IBOutlet weak var btnBack: UIButton!
    var leftImageFrame = CGRect()
    @IBOutlet weak var txtEmailID: UITextField!
//TODO: - Let;s Code    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBack.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initalize()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
//TODO: - Function
    
    func initalize(){
         leftImageFrame = CGRectMake(0, 0, 30, 20)
        
        //3
        txtEmailID.leftViewMode = UITextFieldViewMode.Always
        let emailImageView = UIImageView(frame: leftImageFrame)
        var emailImage = UIImage()
        emailImageView.contentMode = .Center
        
        emailImage = UIImage(named: "img_email-id-input\(self.delObj.deviceName)")!
        emailImageView.image = emailImage
        txtEmailID.leftView = emailImageView
        
        
        self.txtEmailID.attributedPlaceholder = NSAttributedString(string:"Enter your Email ID",
                                                                    attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        
        self.txtEmailID.tintColor = cust.textTintColor
    }
    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func btnSubmitClick(sender: AnyObject) {
        
        let email = self.txtEmailID.text
        
        if GeneralUI_UI.validateEmail(txtEmailID, name: "Email")
        {
              let params: [String: AnyObject] = ["uemail": email!]
                sendMyPassword(params)
                self.view.endEditing(true)
           
        }
        
        
    }
    
    
    
    
    
    
//TODO: - Web service / API implementation
    /**
     Send password to email address
     
     - parameter params: parameter is from submit button, user Input email Address.
     */
    func sendMyPassword(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.FORGOT_PASSWORD, multipartFormData: {
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
