//
//  FollowRequestViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 06/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Mixpanel


class FollowRequestViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var requestDetails = [FollowerRequestModel]()
    
    
//TODO: - Controls
    
    
    @IBOutlet weak var lblNoRequest: UILabel!
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //MARK: Web service / API to fetch followers request
        self.mainTable.tableFooterView = UIView()

       
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        //MARK: Web service call
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let params: [String: AnyObject] = ["user_id": userID,"token_id":token]
        fetchFollowerRequestsList(params)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - Function
    
    
//TODO: - UITableViewDatasource Method implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        return self.requestDetails.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! RequestTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.imgDogTags.image = UIImage(named: "img_dogtagBG-small\(self.delObj.deviceName)")
        
        cell.btnDismiss.setImage(UIImage(named: "btn_close\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        let data = self.requestDetails[indexPath.row]
        cell.lblName.text = data.name
        cell.lblLocation.text = data.location
        cell.lblCountry.text = data.country
        cell.lblSection.text = data.status
        
        //MARK: DogTags
        let dogId = data.dogtagid
        if(dogId == "19"){
            cell.lblName.textColor = UIColor.blackColor()
            cell.lblLocation.textColor = UIColor.blackColor()
            cell.lblCountry.textColor = UIColor.blackColor()
            cell.lblSection.textColor = UIColor.blackColor()
        }else{
            cell.lblName.textColor = UIColor.whiteColor()
            cell.lblLocation.textColor = UIColor.whiteColor()
            cell.lblCountry.textColor = UIColor.whiteColor()
            cell.lblSection.textColor = UIColor.whiteColor()
        }
        cell.imgDogTags.image = UIImage(named: "\(dogId)\(self.delObj.deviceName)")
        
        
        
        cell.imgProfile.image = UIImage(named: "img_profile-pic-upload\(self.delObj.deviceName)")
        let pic = data.profile
        cell.imgProfile.hnk_setImageFromURL(NSURL(string: Urls.ProfilePic_Base_URL + pic)!)
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
        cell.imgProfile.clipsToBounds = true
        
        
        //Button Action
        cell.btnOtherUserProfile.tag = Int(data.userID)!
        cell.btnOtherUserProfile.addTarget(self, action: #selector(FollowRequestViewController.btnOtherUserProfileClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        //MARK: Request received
        if(data.is_requested == "1"){
            cell.btnApprove.setTitle("Approve", forState: .Normal)
            cell.btnApprove.hidden = false
            cell.btnDismiss.hidden = false
        }else{
            //MARK: Request received previously and approved, now send follow request
            
            if(data.is_following == "0"){
                //MARK: Send now follow Request
                cell.btnApprove.hidden = false
                cell.btnDismiss.hidden = false
                cell.btnApprove.setTitle("Follow", forState: .Normal)
            }else{
                //MARK: Invalid
                cell.btnApprove.hidden = true
                cell.btnDismiss.hidden = true
            }
            
        }
        
        
        cell.btnApprove.tag = indexPath.row
        cell.btnApprove.addTarget(self, action: #selector(FollowRequestViewController.btnApproveRequestClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnDismiss.tag = Int(data.userID)!
        cell.btnDismiss.addTarget(self, action: #selector(FollowRequestViewController.btnDismissRequestClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height * 0.158
    }*/
    
//TODO: - UIButton Action
    
    @IBAction func btnOtherUserProfileClick(sender:UIButton){
        let veriStatus = General.loadSaved("verification_pending")
        if(veriStatus == "1"){
            print("other:\(sender.tag)")
        
            let followID = String(sender.tag)
            let userid = General.loadSaved("user_id")
            print("followID:\(followID)")
        
            if(userid != followID){
                let otherVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
                otherVC.friendID = followID
                self.navigationController?.pushViewController(otherVC, animated: true)
            }else{
                print("user and follower are same")
            }
        }
        else{
          GeneralUI.alert(self.delObj.notApprovedMessage)
        }
    }

    
    
    //MARK: Approve request
    @IBAction func btnApproveRequestClick(sender:AnyObject){
        let veriStatus = General.loadSaved("verification_pending")
        if(veriStatus == "1"){
            //MARK: Web service / API to accept follower Request
            
            let userData = self.requestDetails[sender.tag]
            let followMeClick = userData.is_following
            let requested = userData.is_requested
            
            let userID = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            let follower_id = String(userData.userID)//String(sender.tag)
            
            if(followMeClick == "0" && requested == "0"){
                //MARK: Follow Request call
                self.followUser(follower_id)
            }else{
                //MARK: Approve Request
               
                let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"follower_id":follower_id ]
                self.approveFollowerRequest(params)
            }
            
            
        }else{
            GeneralUI.alert(self.delObj.notApprovedMessage)
        }

    }
    
    
    //MARK: Dismiss Request
    @IBAction func btnDismissRequestClick(sender:AnyObject){
        let veriStatus = General.loadSaved("verification_pending")
        if(veriStatus == "1"){
            //MARK: Web service / API to accept follower Request
            let userID = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            let follower_id = String(sender.tag)
            let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"follower_id":follower_id ]
            self.declineFollowerRequest  (params)
        }
        else{
          GeneralUI.alert(self.delObj.notApprovedMessage)
        }
        
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

   
    
//TODO: - Web service / API implementation
    
    /**
     Fetch All follower request for user
     
     - parameter params: userID,token
     */
    func fetchFollowerRequestsList(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.FOLLOW_BACK, multipartFormData: {
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
                                
                                print("JSON***: \(json)")
                                
                               self.requestDetails.removeAll()
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                    } else {
                                        print("You are in successful block")
                                        let count = json["data"].array?.count
                                        if(count>0){
                                            for ind in 0...count!-1{
                                               //in success
                                                print("index\(ind)")
                                                let user_id = json["data"][ind]["user_id"].stringValue
                                                 let dogtagid = json["data"][ind]["dogtag_batch"].stringValue
                                                let user_fullname = json["data"][ind]["user_fullname"].stringValue
                                                let country = json["data"][ind]["country"].stringValue
                                                let city_state = json["data"][ind]["city"].stringValue + ", " + json["data"][ind]["state_abbr"].stringValue
                                                let branch_name = json["data"][ind]["branch_name"].stringValue
                                                let user_profile_pic = json["data"][ind]["user_profile_pic"].stringValue
                                                let abbreviation = json["data"][ind]["abbreviation"].stringValue
                                                let received = json["data"][ind]["received"].stringValue
                                                let is_request_sent = json["data"][ind]["is_request_sent"].stringValue
                                                
                                                
                                                
                                                self.requestDetails.append(FollowerRequestModel(dogtagid: dogtagid, name: user_fullname, location: city_state, country: country, status: branch_name, profile: user_profile_pic,userID: user_id,abbreviation:abbreviation,is_following: is_request_sent,is_requested: received)!)
                                                
                                                
                                            }
                                            print("requestDetails>> \(self.requestDetails)")
                                            self.lblNoRequest.hidden = true
                                            self.mainTable.hidden = false
                                            self.mainTable.reloadData()
                                        }else{
                                            self.mainTable.hidden = true
                                            self.lblNoRequest.hidden = false
                                        }
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
                    self.cust.hideLoadingCircle()
                    print(encodingError)
                }
        })
    }
    
    /**
     Send Follow Request to other
     
     - parameter follower: Person
     - parameter button:   tap button
     */
    func followUser(follower: String) {
        
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
       
        print("follower:\(follower)")
        
        self.cust.showLoadingCircle()
        Alamofire.request(.POST, Urls.FOLLOW_USER, parameters: ["user_id": userID, "token_id": token, "follow_id": follower])
            .responseJSON { response in
                
                self.removeAllOverlays()
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(json)
                        self.cust.hideLoadingCircle()
                        let is_paid = General.loadSaved("is_paid")
                        if(is_paid == "1"){
                            let uid = General.loadSaved("user_id")
                            Mixpanel.mainInstance().identify(distinctId: uid)
                            Mixpanel.mainInstance().track(event: "Follow Tap",
                                properties: ["Follow Tap" : "Follow Tap"])

                        }
                        GeneralUI.alert(json["message"].stringValue)
                       //REmove this from list
                        
                        let params: [String: AnyObject] = ["user_id": userID,"token_id":token]
                        self.fetchFollowerRequestsList(params)
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    self.cust.hideLoadingCircle()
                    print(error)
                }
        }
    }
    
    

    /**
     Accept follower request
     
     - parameter params: userid,token,followe_id
     */
    func approveFollowerRequest(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.APPROVE_FOLLOWER_REQUEST, multipartFormData: {
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
                        
                        let follower_id : String =  (params["follower_id"] as? String)!
                        print("follower_id 1:\(follower_id)")
                        
                        
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
                                        GeneralUI_UI.alert(json["message"].string!)
                                        
                                        
                                        //MARK: Web service call
                                        let userID = General.loadSaved("user_id")
                                        let token = General.loadSaved("user_token")
                                        let params: [String: AnyObject] = ["user_id": userID,"token_id":token]
                                        self.fetchFollowerRequestsList(params)
                                        
                                        /*let isverified = General.loadSaved("verification_pending")
                                        if(isverified == "1"){
                                            Mixpanel.mainInstance().track(event: "Approved Follow Request")
                                        }*/
                                        
                                        
                                        /*if(self.requestDetails.count>0){
                                            for ind in 0...self.requestDetails.count-1{
                                                let data = self.requestDetails[ind]
                                                    print("follower_id 2:\(follower_id)")
                                                    if(data.userID == follower_id){
                                                        self.requestDetails.removeAtIndex(ind)
                                                        break;
                                                    }
                                            }//For ends
                                        }*/
                                        /*if(self.requestDetails.count>0){
                                            self.lblNoRequest.hidden = true
                                            self.mainTable.hidden = false
                                            self.mainTable.reloadData()
                                        }else{
                                            self.lblNoRequest.hidden = false
                                            self.mainTable.hidden = true
                                        }*/
                                        
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
                    self.cust.hideLoadingCircle()
                    print(encodingError)
                }
        })
    }
    
    
    /**
     Decline follower request
     
     - parameter params: userid,token,followe_id
     */
    func declineFollowerRequest(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.DECLINE_FOLLOW_REQUEST, multipartFormData: {
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
                        
                        let follower_id : String =  (params["follower_id"] as? String)!
                        print("follower_id 1:\(follower_id)")
                        
                        
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
                                        GeneralUI_UI.alert(json["message"].string!)
                                        
                                        if(self.requestDetails.count>0){
                                            for ind in 0...self.requestDetails.count-1{
                                                let data = self.requestDetails[ind]
                                                print("follower_id 2:\(follower_id)")
                                                if(data.userID == follower_id){
                                                    self.requestDetails.removeAtIndex(ind)
                                                    break;
                                                }
                                            }//For ends
                                        }
                                        if(self.requestDetails.count>0){
                                            self.lblNoRequest.hidden = true
                                            self.mainTable.hidden = false
                                            self.mainTable.reloadData()
                                        }else{
                                            self.lblNoRequest.hidden = false
                                            self.mainTable.hidden = true
                                        }
                                        
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
                    self.cust.hideLoadingCircle()
                    print(encodingError)
                }
        })
    }
    
    
}
