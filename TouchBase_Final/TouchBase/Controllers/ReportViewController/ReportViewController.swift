//
//  ReportViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 06/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON


class ReportViewController: UIViewController,UITextViewDelegate {

    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    
    //0 >> Report 1 >> suggestion
    var  selection : Int = Int()
    
    
    let placeholderTextColor : UIColor = UIColor.lightGrayColor()
    var is_textEdited : Bool = Bool()
    var lblPlaceholderText : String = String()
    var selected_subject : String = String()
    
    var dropDown = DropDown()
    
    
//TODO: - Controls
    
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var btnSubjectOutlet: UIButton!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnReportOutlet: UIButton!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
//TODO: - Let's Code    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        
        
        if(selection == 0){
            self.lblTitle.text = "Report A Problem"
            lblPlaceholderText = "Write your Problem here..."
            self.btnReportOutlet.setTitle("Report Problem", forState: UIControlState.Normal)
            
            self.imgDropDown.hidden = false
            
            //MARK: if report then reload report
            initDropDown()
        }else if(selection == 1){
            self.lblTitle.text = "General Comments"
              lblPlaceholderText = "Write your Comment here..."
              self.btnReportOutlet.setTitle("General Comment", forState: UIControlState.Normal)
            
            //MARK: If General then no dropdown
            self.btnSubjectOutlet.setTitle("General", forState: UIControlState.Normal)
            self.btnSubjectOutlet.setTitleColor(UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0), forState: UIControlState.Normal)
            self.selected_subject = "General"
            self.imgDropDown.hidden = true
            
        }
        initPlaceholderForTextView()
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
        txtMessage.text = self.lblPlaceholderText
        txtMessage.textColor = placeholderTextColor
        is_textEdited = false
        txtMessage.delegate = self
        
        self.txtMessage.layer.borderColor = cust.placeholderTextColor.CGColor
        self.txtMessage.layer.borderWidth = 0.5
        
    }
    
    /**
     Initialize DropDown here
     
     - returns: does not return
     */
    func initDropDown(){
        
        // The view to which the drop down will appear on
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["General", "Abuse", "Account","Billing","Technical","Suggestion"]
        dropDown.anchorView = self.lblSeperator // UIView or UIBarButtonItem

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btnSubjectOutlet.setTitle(item, forState: UIControlState.Normal)
            self.btnSubjectOutlet.setTitleColor(UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0), forState: UIControlState.Normal)
            self.selected_subject = item
        }
    }
    
//TODO: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == placeholderTextColor{
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            is_textEdited = true
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == txtMessage{
            if textView.text.isEmpty{
                
                txtMessage.text = self.lblPlaceholderText
                txtMessage.textColor = placeholderTextColor
                is_textEdited = false
            }
            
        }
    }
    
//TODO: - UIButton Action
    
    
    @IBAction func btnSubjectClick(sender: AnyObject) {
        dropDown.show()
        
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        if(self.navigationController != nil){
              self.navigationController?.popViewControllerAnimated(true)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
      
    }
    
    @IBAction func btnReportProblemClick(sender: AnyObject) {
       
        let token_id = General.loadSaved("user_token")
        let user_id = General.loadSaved("user_id")
        //let trimmedString = General.trimMyString(self.txtMessage.text!)
        let trimmedString = self.txtMessage.text!
        
        if selected_subject != ""
        {
            if(is_textEdited && trimmedString.characters.count>0){
                let params: [String: AnyObject] = ["userid": user_id, "token_id": token_id,"reason":selected_subject,"description":trimmedString ]
                sendMyReport(params)
                self.view.endEditing(true)
            }else{
                GeneralUI_UI.alert("Enter Description")
            }
        }else{
            GeneralUI_UI.alert("Select subject")
            
        }
    }
    
    
    
//TODO: - Web service / API implementation
    
    func sendMyReport(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.REPROT_PROBLEM, multipartFormData: {
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
