//
//  ChangePasswordViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 06/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var leftImageFrame = CGRect()
    
    
    
//TODO: - Controls
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtOldPassword: UITextField!
//TODO: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - Function
    
    func initialization(){
        leftImageFrame = CGRectMake(0, 0, 30, 20)
        
        //1
        txtOldPassword.leftViewMode = UITextFieldViewMode.Always
        let passImageView = UIImageView(frame: leftImageFrame)
        var passImage = UIImage()
        passImageView.contentMode = .Center
        
        passImage = UIImage(named: "ic_lock")!
        passImageView.image = passImage
        txtOldPassword.leftView = passImageView
        
        //2
        txtNewPassword.leftViewMode = UITextFieldViewMode.Always
        let newpassImageView = UIImageView(frame: leftImageFrame)
        var newpassImage = UIImage()
        newpassImageView.contentMode = .Center
        
        newpassImage = UIImage(named: "ic_lock")!
        newpassImageView.image = newpassImage
        txtNewPassword.leftView = newpassImageView
        
        //3
        txtConfirmPassword.leftViewMode = UITextFieldViewMode.Always
        let confpassImageView = UIImageView(frame: leftImageFrame)
        var confpassImage = UIImage()
        confpassImageView.contentMode = .Center
        
        confpassImage = UIImage(named: "ic_lock")!
        confpassImageView.image = confpassImage
        txtConfirmPassword.leftView = confpassImageView
    }
    
//TODO: - UIButton Action
    
   
    @IBAction func btnChangePasswordClick(sender: AnyObject) {
        
        // 1. Change password API
        let oldPass = txtOldPassword.text
        let newPass = txtNewPassword.text
        let confPass = txtConfirmPassword.text
        
        let userID = General.loadSaved("user_id")
        let userToken = General.loadSaved("user_token")
        if  GeneralUI_UI.validateBasic(txtOldPassword, name: "Password", min: 7) &&
            GeneralUI_UI.validateBasic(txtNewPassword, name: "Password", min: 7) &&
            GeneralUI_UI.validateBasic(txtConfirmPassword, name: "Password", min: 7) &&
            GeneralUI_UI.validateCPassword(txtNewPassword, textField2: txtConfirmPassword)
        {
            
            let params: [String: AnyObject] = ["old_pass": oldPass!, "new_pass": newPass!,"confirm_pass": confPass!,"token_id": userToken ,"user_id": userID ]
            changeMyPassword(params)
            self.view.endEditing(true)
        }

    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
//TODO: - Web service / API implementation
    
    func changeMyPassword(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.CHANGE_PASSWORD, multipartFormData: {
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
                                        //Successful
                                        GeneralUI_UI.alert(json["message"].string!)
                                        print("You are in successful block")
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                        
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
