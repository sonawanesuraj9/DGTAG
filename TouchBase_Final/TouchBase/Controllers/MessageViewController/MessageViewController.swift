//
//  MessageViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 31/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Mixpanel

class MessageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var messageList = [MessagePersonListModel]()
    
//TODO: - Controls
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnMessageOutlet: UIButton!
    @IBOutlet weak var tblMain: UITableView!
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //MARK: Notifcation implementation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageViewController.methodOfReceivedNotification(_:)), name:"PostReloadMessageUserList", object: nil)
        
        
    }
    
    /**
     Notification raised
     
     - parameter notification: HomeTab
     */
    func methodOfReceivedNotification(notification: NSNotification){
        //Take Action on Notification
        //MARK: Web service / API to fetch followers request
        let userID = General.loadSaved("user_id")
        let params: [String: AnyObject] = ["usenderid": userID ]
        listMyCurrentMessageThread(params)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.delObj.screenTag = 2
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
    self.btnMessageOutlet.setImage(UIImage(named:"img_new-messsage\(self.delObj.deviceName)" ), forState: UIControlState.Normal)
        
        //MARK: Web service / API to fetch followers request
        let userID = General.loadSaved("user_id")
        let params: [String: AnyObject] = ["usenderid": userID ]
        listMyCurrentMessageThread(params)
        
        self.tblMain.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//TODO: - UITableViewDatasource Method Implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return messageList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! MessagePersonTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let data = messageList[indexPath.row]
        cell.lblSenderName.text = data.user_fullname //"Suraj Sonawane"
        cell.lblSenderMessage.text = data.user_message //"Hello Buddy, You are Awesome, just keep it up!!!"
        
        //MARK: Profile Pic
        let pic = data.user_profile
        let ur = NSURL(string: Urls.ProfilePic_Base_URL + pic)
        cell.imgProfilePic.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "pick_camera_icon"), options: SDWebImageOptions.RefreshCached)
        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.width/2
        cell.imgProfilePic.clipsToBounds = true
        
        //Message Count
        let ct = data.unread_messages
        if(Int(ct) == 0){
            cell.imgBadge.hidden = true
            cell.lblCount.hidden = true
        }else{
            cell.imgBadge.hidden = false
            cell.lblCount.hidden = false
            cell.lblCount.text = ct
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("indexPath\(indexPath.row)")
        
        let chatVC = self.storyboard?.instantiateViewControllerWithIdentifier("idChattingViewController") as! ChattingViewController
        let data = messageList[indexPath.row]
        print(data.user_id)
        General.saveData(data.user_id, name: "friend_id_mes")
        General.saveData(data.user_profile, name: "friend_profile")
        let uID = General.loadSaved("user_id")
        
        //MARK: Web service to read latest messages
        let params : [String:AnyObject] = ["usenderid":data.user_id,"ureceiverid":uID]
        self.readMessageCount(params)
        self.navigationController?.pushViewController(chatVC, animated: true)
        
        
        /*let is_paid = General.loadSaved("is_paid")
        let branch_id  = General.loadSaved("branch_id")
        let premID = data.premUser
        if(is_paid == "1"){
            self.navigationController?.pushViewController(chatVC, animated: true)
        }else if(branch_id == premID){
            self.navigationController?.pushViewController(chatVC, animated: true)
        }else{
            
            
         Mixpanel.mainInstance().track(event: "User prompted to Upgrade",
         properties: ["User prompted to Upgrade" : "User prompted to Upgrade"])

         
         
            //MARK: Prem alert
            let premAlert = UIAlertController(title: "DogTags", message: self.delObj.notPremiumMessage, preferredStyle: UIAlertControllerStyle.Alert)
            premAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                //
            }))
            premAlert.addAction(UIAlertAction(title: "Purchase", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                //
                self.dismissViewControllerAnimated(true, completion: nil)
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navUpgrade") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
            }))
            
            self.presentViewController(premAlert, animated: true, completion: nil)
        }
        */
        
       
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            print("Row is deleted")
            
            let datalist = messageList[indexPath.row]
            let loginID = General.loadSaved("user_id")
            let usenderid = datalist.usenderid
            let ureceiverid = datalist.ureceiverid
            var owner_id : String = String()
            if(usenderid != loginID ){
                owner_id = usenderid
            }else if(ureceiverid != loginID){
                owner_id = ureceiverid
            }
            
            let params: [String: AnyObject] = ["usenderid": usenderid,"ureceiverid":ureceiverid,"owner_id":owner_id ]
            ClearMessageThread(params, index: indexPath.row)
        }
    }
    
    
    
//TODO: - UIButton Action
    
    @IBAction func btnNewMessage(sender: AnyObject) {
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("idNewMessageViewController") as! NewMessageViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
//TODO: - Web service / API implementation
    
    /**
     List all active commnication thread
     
     - parameter params: userID & Token
     */
    func listMyCurrentMessageThread(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.LIST_MESSAGE_THREAD, multipartFormData: {
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
                                 self.messageList.removeAll()
                                print("JSON List: \(json)")
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        if(json["message"].stringValue.containsString("No information found")){}else{
                                           GeneralUI_UI.alert(json["message"].stringValue)
                                        }
                                        
                                    } else {
                                        print("You are in successful Block")
                                        
                                        let count = json["data"].array?.count
                                        if(count>0){
                                            
                                            for ind in 0...count!-1{
                                            
                                                let message = json["data"][ind]["message"].stringValue
                                                 //let user_id = json["data"][ind]["user_id"].stringValue
                                                 let reciver_fullname = json["data"][ind]["user_fullname"].stringValue
                                                 let sender_fullname = json["data"][ind]["sender_fullname"].stringValue
                                                 let user_senderid = json["data"][ind]["user_senderid"].stringValue
                                                 let user_receiverid = json["data"][ind]["user_receiverid"].stringValue
                                                 let receiver_profile = json["data"][ind]["receiver_profile"].stringValue
                                                 let sender_profile = json["data"][ind]["sender_profile"].stringValue
                                                 let branch_id = json["data"][ind]["branch_id"].stringValue
                                                 let  sender_unread_messages  = json["data"][ind]["unread_messages"].stringValue
                                                 let  receiver_unread_messages = json["data"][ind]["unread_sender"].stringValue
                                                
                                                
                                                var user_profile_pic : String = String()
                                                var user_fullname : String = String()
                                                var user_id : String = String()
                                                var unread_messages : String = String()
                                                
                                                let tmpUID = General.loadSaved("user_id")
                                                
                                                if(user_receiverid != tmpUID){
                                                    user_id = user_receiverid
                                                    user_profile_pic = receiver_profile
                                                    user_fullname = reciver_fullname
                                                    unread_messages = receiver_unread_messages
                                                }else{
                                                    user_id = user_senderid
                                                    user_profile_pic = sender_profile
                                                    user_fullname = sender_fullname
                                                    unread_messages = sender_unread_messages
                                                }
                                                
                                                
                                                
                                                self.messageList.append(MessagePersonListModel(user_fullname: user_fullname, user_message: message, user_profile: user_profile_pic, user_id: user_id,usenderid: user_senderid,ureceiverid: user_receiverid,premUser: branch_id,unread_messages:unread_messages)!)
                                            }
                                            self.tblMain.reloadData()
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
    
    
    /**
     Read my new messages
     
     - parameter params: user_id,friend_id
     */
    func readMessageCount(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.READ_MESSAGE_COUNT, multipartFormData: {
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
                                
                                print("JSON List: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].string!)
                                    } else {
                                        print("You are in successful Block")
                                        
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

    /**
     remove Message thread
     
     - parameter params: usenderid,ureceiverid
     */
    func ClearMessageThread(params: [String: AnyObject],index:Int) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.CLEAR_MESSAGE_THREAD, multipartFormData: {
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
                                
                                print("JSON List: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].string!)
                                    } else {
                                        print("You are in successful Block")
                                        self.messageList.removeAtIndex(index)
                                        self.tblMain.reloadData()
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                            self.view.userInteractionEnabled = true
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


