//
//  ChatVC.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 01/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Mixpanel

class ChatVC: SOMessagingViewController {
    //TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var chatDetail = [ChatValueModel]()
    
    var dataSource : NSMutableArray = NSMutableArray()
    var myImage : UIImage = UIImage()
    var partnerImage : UIImage = UIImage()
    
    var dummyFrImageView : UIImageView = UIImageView()
    var dummySelfImageView : UIImageView = UIImageView()
    
    //TODO: - Controls
    
    
    //TODO: - Let's Message
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dummyFrImageView.frame = CGRectMake(0, 0, 60, 60)
        dummySelfImageView.frame = CGRectMake(0, 0, 60, 60)
        
        let friendPic = General.loadSaved("friend_profile")
        let selfPic = user_dictonary["user_profile_pic"] as! String
        
        let FrURL = NSURL(string: Urls.ProfilePic_Base_URL + friendPic)
        dummyFrImageView.sd_setImageWithURL(FrURL, placeholderImage: UIImage(named: "pick_camera_icon"), options: SDWebImageOptions.RefreshCached)
        
        let slfURL = NSURL(string: Urls.ProfilePic_Base_URL + selfPic)
        dummySelfImageView.sd_setImageWithURL(slfURL, placeholderImage: UIImage(named: "pick_camera_icon"), options: SDWebImageOptions.RefreshCached)
        
        self.myImage = dummySelfImageView.image!
        
        
        self.partnerImage = dummyFrImageView.image!
        loadMessage()

        
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatVC.ChatLoad(_:)), name:"PostReloadMessageChat", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatVC.methodOfReceivedNotification(_:)), name:"chatDataLoaded", object: nil)
    }
    
    func methodOfReceivedNotification(notification: NSNotification){
        //Take Action on Notification
        //loadMessage()
        refreshMessages()
    }
    
    func ChatLoad(notification: NSNotification){
        //Take Action on Notification
        //loadMessage()
        loadMessage()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.delObj.screenTag = 3
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //TODO: - Function
    
    func loadMessage(){
        self.dataSource = ContentManager.sharedManager().generateConversation() //as [NSMutableArray] // ContentManager.sharedManager().generateConversation() as! NSMutableArray
        print("        self.dataSource:\(self.dataSource)")
    }
    
    
    //TODO: - message
    
    override func messages() -> NSMutableArray! {
        return self.dataSource
    }
    /* func message() -> NSMutableArray{
     return self.dataSource
     }*/
    
    override func intervalForMessagesGrouping()->NSTimeInterval{
        return 2*24*3600
    }
    
    
    override func configureMessageCell(cell: SOMessageCell, forMessageAtIndex index: Int) {
        let message: Message = self.dataSource[index] as! Message
        // Adjusting content for 3pt. (In this demo the width of bubble's tail is 3pt)
        if !message.fromMe {
            cell.contentInsets = UIEdgeInsetsMake(0, 3.0, 0, 0)
            //Move content for 3 pt. to right
            cell.textView.textColor = UIColor.blackColor()
        }
        else {
            cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 3.0)
            //Move content for 3 pt. to left
            cell.textView.textColor = UIColor.whiteColor()
        }
        cell.userImageView.layer.cornerRadius = self.userImageSize().width / 2
        // Fix user image position on top or bottom.
        cell.userImageView.autoresizingMask = message.fromMe ? .FlexibleTopMargin : .FlexibleBottomMargin
        // Setting user images
        cell.userImage = message.fromMe ? self.myImage : self.partnerImage
        //  self.generateUsernameLabelForCell(cell)
    }
    
    
    func generateUsernameLabelForCell(cell: SOMessageCell) {
        let labelTag: Int = 666
        let message: Message = (cell.message as! Message)
        var label : UILabel = cell.containerView.viewWithTag(labelTag) as! UILabel
        
        //UILabel *label = (UILabel *)[cell.containerView viewWithTag:labelTag];
        //var label: UILabel = (cell.containerView.viewWithTag(labelTag) as! UILabel)
        //if !label {
        label = UILabel()
        label.font = UIFont.systemFontOfSize(8)
        label.textColor = UIColor.grayColor()
        label.tag = labelTag
        cell.containerView.addSubview(label)
        //}
        label.text = message.fromMe ? "Me" : "Steve Jobs"
        label.sizeToFit()
        var frame: CGRect = label.frame
        let topMargin: CGFloat = 2.0
        
        if message.fromMe {
            frame.origin.x = cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width / 2 - frame.size.width / 2
            frame.origin.y = cell.containerView.frame.size.height + topMargin
        }
        else {
            frame.origin.x = cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width / 2 - frame.size.width / 2
            frame.origin.y = cell.userImageView.frame.origin.y + cell.userImageView.frame.size.height + topMargin
        }
        
        label.frame = frame
    }
    
    
    //extra
    
    override func messageMaxWidth()->CGFloat{
        //220 for 320 width
        return UIScreen.mainScreen().bounds.width*0.68
    }
    
    
    override func userImageSize()-> CGSize{
        return CGSizeMake(40, 40)
    }
    
    func messageMinHeight()->CGFloat{
        return 0
    }
    
//TODO: - SOMessaging delegate
    override func didSelectMedia(media: NSData!, inMessageCell cell: SOMessageCell!) {
        didSelectMedia(media, inMessageCell: cell)
    }
    
    override func messageInputView(inputView: SOMessageInputView!, didSendMessage message: String!) {
        
        if(message.characters.count==0){
            return
        }else{
            
            let msg: Message = Message()
            msg.text = message
            msg.fromMe = true
            self.sendMessage(msg)
            
            view.endEditing(false)
            //MARK: Web service / API to fetch One to One chat
            let userID = General.loadSaved("user_id")
            let frID = General.loadSaved("friend_id_mes")
            let params: [String: AnyObject] = ["usenderid": userID, "umessage": message,"ureceiverid":frID ]
            sendMyMessage(params)
        }
        
        
        
        
        
        
        // self.refreshMessages()
    }
    override func messageInputViewDidSelectMediaButton(inputView: SOMessageInputView!) {
        //call for gallary
    }
    
    
//TODO: - Web service / API implementation
    
    /**
     Fetch ONE TO ONE MESSAGE
     
     - parameter params: usenderid, ureceiverid
     */
    func sendMyMessage(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        //self.cust.showLoadingCircle()
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
                                        print("You are in successful block")
                                        
                                        //Mixpanel:
                                        let uid = General.loadSaved("user_id")
                                        Mixpanel.mainInstance().identify(distinctId: uid)
                                        Mixpanel.mainInstance().track(event: "Message Sent",
                                            properties: ["Message Sent" : "Message Sent"])

                                        
                                        let count = json["data"].array?.count
                                        if(count>0){
                                            
                                            for ind in 0...count!-1{
                                                //in success
                                                print("index\(ind)")
                                                //user data
                                                let user_senderid = json["data"][ind]["user_senderid"].string
                                                let user_receiverid = json["data"][ind]["user_receiverid"].string
                                                let user_message = json["data"][ind]["user_message"].string
                                                //let message_date = json["data"][ind]["message_date"].string!
                                                let dateT = NSDate()
                                                

                                                self.chatDetail.append(ChatValueModel(user_senderid: user_senderid!, user_receiverid: user_receiverid!, user_message: user_message!, message_date: dateT,type: "SOMessageTypeText")!)
                                                
                                            }
                                            let nsMutableArray = NSMutableArray(array: self.chatDetail)
                                            self.dataSource = nsMutableArray
                                            self.refreshMessages()
                                            print("requestDetails>> \(self.chatDetail)")
                                            
                                        }else{
                                            
                                        }
                                    }
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
