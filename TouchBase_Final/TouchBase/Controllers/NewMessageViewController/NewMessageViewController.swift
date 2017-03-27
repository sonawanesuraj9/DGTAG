//
//  NewMessageViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 31/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DropDown
import Mixpanel

class NewMessageViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var is_textEdited : Bool = Bool()
    let placeholderTextColor : UIColor = UIColor.lightGrayColor()
    
    
    var dropDown = DropDown()
    
    var recID : String = String()
    var isWSCall : Bool = Bool()
    var receiverImageArray : [String] = []
    var receiverIDArray : [String] = []
    var receiverNameArray : [String] = []
//TODO: - Controls
    

    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var tblMain: UITableView!
   // @IBOutlet weak var btnTypeHere: UIButton!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var txtTypeHere: UITextField!
    
    
//TODO: - Let's Code    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tblMain.tableFooterView = UIView()
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.tblMain.hidden = true
        self.overlay.hidden = true
        
        
        initialization()
        initPlaceholderForTextView()
        initDropDown()
        
        //MARK: Web service call to load all followers to initiate message
       /* let user = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
        let params: [String: AnyObject] = ["user_id": user, "token_id": token ]
        fetchMyFollowers(params)
        self.view.endEditing(true)*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == placeholderTextColor{
            self.tblMain.hidden = true
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            is_textEdited = true
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == txtMessage{
            if textView.text.isEmpty{
                
                txtMessage.text = "Type your text here..."
                txtMessage.textColor = placeholderTextColor
                is_textEdited = false
            }
            
        }
    }

//TODO: - UITextField Delegate Method implementation
    
    /*func textFieldDidBeginEditing(textField: UITextField){
        if(textField == txtTypeHere){
            //self.resignFirstResponder()
            //dropDown.show()
        }
    }*/
    
  
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
       // self.callToSearch(self.txtTypeHere.text!)
        return true
    }

    @IBAction func textIsChanged(sender: AnyObject) {
         self.txtTypeHere.becomeFirstResponder()
        if(self.txtTypeHere.text?.characters.count == 0){
            clearAllData()
            self.tblMain.reloadData()
            self.tblMain.hidden = true
            self.overlay.hidden = true
        }else{
            self.callToSearch(self.txtTypeHere.text!)
        }
    }
    
//TODO: - UITableViewDatasource method implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return receiverNameArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
     let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! MessageSearchCell
        
        cell.lblName.text = self.receiverNameArray[indexPath.row]
        
        let ur = NSURL(string: Urls.ProfilePic_Base_URL + self.receiverImageArray[indexPath.row])
        cell.imgProfile.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "avatar_thumbnail.jpg"), options: SDWebImageOptions.RefreshCached)
        
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
        cell.imgProfile.clipsToBounds = true
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("indexpath:\(indexPath.row)")
        let index = indexPath.row
        self.txtTypeHere.text = self.receiverNameArray[index] //item
        self.recID = self.receiverIDArray[index]
        self.tblMain.hidden = true
        
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var txtAfterUpdate:NSString = self.txtTypeHere.text! as NSString
        txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
        
        //self.callToSearch(self.txtTypeHere.text!)
        return true
    }

    
    
//TODO: - Function
    
    func callToSearch(searchPhase:String){
        print("searchPhase:\(searchPhase)")
        
        //MARK: Web service / API to unlike post
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
        let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"keyword":searchPhase ]
        print("params:\(params)")
            self.FetchUserList(params){ response in
                        print("FetchUserList:\(response)")
                        if(response){
                            if(self.receiverNameArray.count>0){
                                  self.tblMain.hidden = false
                                self.tblMain.reloadData()
                            }
                          
                        }else{
                            print(" false")
                        }
                        
            }
                
       
        

        
        
       

    }
    
    func initialization(){
        
        //self.txtTypeHere.delegate = self
        self.txtTypeHere.returnKeyType = .Search
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        /*let paddingForFirst = UIView(frame: CGRectMake(0, 0, 15, self.txtTypeHere.frame.size.height))
        //Adding the padding to the second textField
        txtTypeHere.leftView = paddingForFirst
        txtTypeHere.leftViewMode = UITextFieldViewMode .Always*/
    }
    
    func initPlaceholderForTextView(){
        txtMessage.text = "Type your text here... "
        txtMessage.textColor = placeholderTextColor
        is_textEdited = false
    }
    
    /**
     Initialize DropDown here
     
     - returns: does not return
     */
    func initDropDown(){
        
        // The view to which the drop down will appear on
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = receiverNameArray
        dropDown.anchorView = self.txtTypeHere // UIView or UIBarButtonItem
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txtTypeHere.text = self.receiverNameArray[index] //item
            self.recID = self.receiverIDArray[index]
            /*self.btnSubjectOutlet.setTitle(item, forState: UIControlState.Normal)
            self.btnSubjectOutlet.setTitleColor(UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0), forState: UIControlState.Normal)
            self.selected_subject = item*/
        }
    }
    
    
    func clearAllData(){
        self.receiverNameArray.removeAll(keepCapacity: false)
        self.receiverIDArray.removeAll(keepCapacity: false)
        self.receiverImageArray.removeAll(keepCapacity: false)
    }

//TODO: - UIButton Action
    
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnSendClick(sender: AnyObject) {
        self.tblMain.hidden = true
        let userID = General.loadSaved("user_id")
        let recID = self.recID
        let message = self.txtMessage.text
        //message = General.trimMyString(message)
        
        
        if(recID != ""){
            if(is_textEdited && message.characters.count>0 && recID != ""){
                let param : [String: AnyObject] = ["usenderid":userID,"umessage":message,"ureceiverid":recID]
                self.sendMyMessage(param)
            }else{
                GeneralUI_UI.alert("Please enter Text")
            }
        }else{
            GeneralUI_UI.alert("Please select receiver")
        }
        
    }
    
    
//TODO: - Web service / API implementation
    
    
    /**
     Like to specific post will be here
     
     - parameter params: userid, postid, token
     */
    
    func FetchUserList(params: [String: AnyObject], completion : (Bool) -> ()) {
        
        //self.view.userInteractionEnabled = false
        print(params)
        if !isWSCall{
            isWSCall = true
        Alamofire.upload(.POST, Urls_UI.FETCH_USER_LIST, multipartFormData: {
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
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                self.clearAllData()
                                self.tblMain.reloadData()
                                self.isWSCall = false
                                print("JSON: \(json)")
                                
                                let count = json.array?.count
                                if(count>0){
                                    for ind in 0...count!-1{
                                        self.receiverNameArray.append(json[ind]["user_fullname"].stringValue)
                                        self.receiverIDArray.append(json[ind]["user_id"].stringValue)
                                        self.receiverImageArray.append(json[ind]["user_profile_pic"].stringValue)
                                    }
                                }else{
                                    GeneralUI.alert(json["message"].stringValue)
                                    //self.txtTypeHere.text = ""
                                    //self.txtTypeHere.becomeFirstResponder()
                                }
                               completion(true)
                            }
                        case .Failure(let error):
                            self.isWSCall = false
                            GeneralUI_UI.alert(error.localizedDescription)
                            completion(false)
                             self.view.userInteractionEnabled = true
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    completion(false)
                    self.isWSCall = false
                     self.view.userInteractionEnabled = true
                    print(encodingError)
                }
        })
        }else{
            print("WS is alreay call")
        }
    }
    
    
    
    
    @IBAction func btnTypeHereClick(sender: AnyObject) {
        dropDown.dataSource = receiverNameArray
        dropDown.show()
    }
    
    /**
     Send Message to Followers
     
     - parameter params: usenderid,umessage,ureceiverid
     */
    func sendMyMessage(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.SEND_MESSAGE, multipartFormData: {
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
                                        
                                        //Mixpanel:
                                        let uid = General.loadSaved("user_id")
                                        Mixpanel.mainInstance().identify(distinctId: uid)
                                        Mixpanel.mainInstance().track(event: "Message Sent",
                                            properties: ["Message Sent" : "Message Sent"])

                                       
                                        print("You are in success block")
                                        if(self.navigationController != nil){
                                            self.navigationController?.popViewControllerAnimated(true)
                                        }else{
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                        }
                                        
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    self.view.userInteractionEnabled = true
                    print(encodingError)
                }
        })
    }
    

}
