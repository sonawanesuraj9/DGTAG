//
//  FollowingViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 08/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Mixpanel

class FollowingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var requestDetails = [FollowerRequestModel]()
    
    var friendID : String = String()
    
//TODO: - Controls
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var lblNoFollowing: UILabel!
    
    
//TODO: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //MARK: Web service / API to fetch followers request
        let userID = friendID //General.loadSaved("user_id")
        let login_user = General.loadSaved("user_id")
        let params: [String: AnyObject] = ["user_id": userID,"login_user":login_user]
        fetchFollowingList(params)
        
        self.tblMain.tableFooterView = UIView()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - UITableViewDatasource Method implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        return self.requestDetails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! FollowingTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.imgDogTags.image = UIImage(named: "img_dogtagBG-small\(self.delObj.deviceName)")
        
        
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
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
        cell.imgProfile.clipsToBounds = true
        
        cell.btnUnfollow.tag = indexPath.row
        if(data.is_following == "1"){
            cell.btnUnfollow.setTitle("Unfollow", forState: UIControlState.Normal)
        }else{
            if(data.is_requested == "1"){
                cell.btnUnfollow.setTitle("Requested", forState: UIControlState.Normal)
            }else{
                cell.btnUnfollow.setTitle("Follow", forState: UIControlState.Normal)
            }
            
        }
        
        cell.btnUnfollow.addTarget(self, action: #selector(FollowingViewController.btnUnfollowClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
       /* cell.btnUnfollow.tag = Int(data.userID)!
        cell.btnUnfollow.setTitle("Unfollow", forState: UIControlState.Normal)
        cell.btnUnfollow.addTarget(self, action: #selector(FollowingViewController.btnUnfollowClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)*/
        
        
        cell.btnOtherUser.tag = indexPath.row
        cell.btnOtherUser.addTarget(self, action: #selector(FollowersViewController.btnOtherUserProfileClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height * 0.158
    }*/
    
    
//TODO: - UIButton Action
    
    @IBAction func btnOtherUserProfileClick(sender:UIButton){
        //MARK: Check account is verified or nor
        let veriStatus = General.loadSaved("verification_pending")
        if(veriStatus == "1"){

        
        print("sender.tag:\(sender.tag)")
        if(requestDetails.count>0){
            let data = requestDetails[sender.tag]
            let followID = data.userID
            let userid = General.loadSaved("user_id")
            print("followID:\(followID)")
            
            if(userid != followID){
                //MARK: Mixpanel
                let uid = General.loadSaved("user_id")
                Mixpanel.mainInstance().identify(distinctId: uid)
                Mixpanel.mainInstance().track(event: "DogTag Tap",
                                              properties: ["DogTag Tap" : "DogTag Tap"])
                
                let otherVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
                otherVC.friendID = followID
                self.presentViewController(otherVC, animated: true, completion: nil)
            }else{
                print("user and follower are same")
            }
        }else{
            GeneralUI.alert("Please check internet connection")
        }
        }else{
            GeneralUI.alert(self.delObj.notApprovedMessage)
        }
    }
    
    
    @IBAction func btnBackClick(sender: AnyObject) {
        if(self.navigationController != nil){
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func btnUnfollowClick(sender:AnyObject){
        //MARK: Check account is verified or not
        let veriStatus = General.loadSaved("verification_pending")
        if(veriStatus == "1"){
            let data = self.requestDetails[sender.tag]
            if(data.is_following == "1"){
                //MARK: Unfollow user
                let userID = General.loadSaved("user_id")
                let token = General.loadSaved("user_token")
                let follow_id = String(data.userID)
                let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"follow_id":follow_id ]
                unfollowFollowingUser(params)
            }else{
                //MARK: Follow User
                self.followUser(String(data.userID), button: sender as! UIButton)
            }
            
            
        }else{
            GeneralUI.alert(self.delObj.notApprovedMessage)
        }
        
        
        //MARK: Web service / API to accept follower Request
        /*let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let follow_id = String(sender.tag)
        let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"follow_id":follow_id ]
        unfollowFollowingUser(params)*/
        
    }
    
    
//TODO: - Web service / API implementation
    
    /**
     Fetch following for login user
     
     - parameter params:
     */
    func fetchFollowingList(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.LIST_FOLLOWING, multipartFormData: {
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
                        
                        let muser_id : String =  (params["user_id"] as? String)!
                        print("user_id 1:\(muser_id)")
                        let login_user = General.loadSaved("user_id")
                        
                        self.view.userInteractionEnabled = true
                        self.cust.hideLoadingCircle()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                print("JSON: \(json)")
                                
                                self.requestDetails.removeAll()
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                    } else {
                                        print("You are in successful block")
                                        let count = json["result"].array?.count
                                        if(count>0){
                                            for ind in 0...count!-1{
                                                //in success
                                                print("index\(ind)")
                                                let user_id = json["result"][ind]["user_id"].stringValue
                                                let dogtagid = json["result"][ind]["dogtag_batch"].stringValue
                                                let user_fullname = json["result"][ind]["user_fullname"].stringValue
                                                let country = json["result"][ind]["country"].stringValue
                                                let city_state = json["result"][ind]["city"].stringValue + ", " + json["result"][ind]["state_abbr"].stringValue
                                                let branch_name = json["result"][ind]["branch_name"].stringValue
                                                let user_profile_pic = json["result"][ind]["user_profile_pic"].stringValue
                                                let abbreviation =  json["result"][ind]["abbreviation"].stringValue
                                                var is_follower : String = String()
                                                if(muser_id == login_user){
                                                    is_follower = "1"
                                                }else{
                                                    is_follower = json["result"][ind]["is_follower"].stringValue
                                                }
                                                
                                                let is_requested = json["result"][ind]["is_requested"].stringValue
                                                
                                                self.requestDetails.append(FollowerRequestModel(dogtagid: dogtagid, name: user_fullname, location: city_state, country: country, status: branch_name, profile: user_profile_pic,userID: user_id,abbreviation: abbreviation,is_following: is_follower,is_requested: is_requested)!)
                                                
                                            }
                                            
                                            self.tblMain.reloadData()
                                            self.lblNoFollowing.hidden = true
                                        }else{
                                            self.tblMain.hidden = true
                                            self.lblNoFollowing.hidden = false
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
     Unfollow >> Following users
     
     - parameter params: userid, token, following iD
     */
    func unfollowFollowingUser(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.UNFOLLOW_FOLLOWING, multipartFormData: {
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
                        let follow_id : String =  (params["follow_id"] as? String)!
                        print("follow_id 1:\(follow_id)")
                       
                        
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
                                        print("You are in successful block")
                                        if(self.requestDetails.count>0){
                                            for ind in 0...self.requestDetails.count-1{
                                                let data = self.requestDetails[ind]
                                                print("follower_id 2:\(follow_id)")
                                                if(data.userID == follow_id){
                                                    self.requestDetails.removeAtIndex(ind)
                                                    break;
                                                }
                                            }//For ends
                                        }
                                        if(self.requestDetails.count>0){
                                            self.lblNoFollowing.hidden = true
                                            self.tblMain.hidden = false
                                            self.tblMain.reloadData()
                                        }else{
                                            self.lblNoFollowing.hidden = false
                                            self.tblMain.hidden = true
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

    
    func followUser(follower: String, button: UIButton) {
        
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
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
                        
                        if(json["message"].stringValue.containsString("You are allowed to follow same branch user only")){
                            
                            
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
                            
                        }else{
                            let is_paid = General.loadSaved("is_paid")
                            if(is_paid == "1"){
                                let uid = General.loadSaved("user_id")
                                Mixpanel.mainInstance().identify(distinctId: uid)
                                Mixpanel.mainInstance().track(event: "Follow Tap",
                                    properties: ["Follow Tap" : "Follow Tap"])

                            }
                            
                            if(self.requestDetails.count>0){
                                for ind in 0...self.requestDetails.count-1{
                                    let data = self.requestDetails[ind]
                                    print("follower_id 2:\(follower)")
                                    if(data.userID == follower){
                                        data.is_requested = "1"
                                        break;
                                    }
                                }//For ends
                            }
                            self.tblMain.reloadData()
                            
                            
                            GeneralUI.alert(json["message"].stringValue)
                        }
                        
                        
                        
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    self.cust.hideLoadingCircle()
                    print(error)
                }
        }
    }
    
}
