//
//  BlockUsersViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 08/11/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class BlockUsersViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
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
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let params: [String: AnyObject] = ["user_id": userID,"token_id":token]
        fetchBlockList(params)
        
        self.mainTable.tableFooterView = UIView()
        
        self.lblNoRequest.text = "No block list"
        
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
//TODO: - UITableviewDatasource method implementation
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.requestDetails.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! RequestTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.imgDogTags.image = UIImage(named: "img_dogtagBG-small\(self.delObj.deviceName)")
        
        cell.btnDismiss.setImage(UIImage(named: "btn_close\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        cell.btnApprove.setTitle("Unblock", forState: UIControlState.Normal)
        
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
        cell.btnApprove.tag = Int(data.userID)!
        cell.btnApprove.addTarget(self, action: #selector(FollowRequestViewController.btnApproveRequestClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        cell.btnDismiss.hidden = true
        cell.btnDismiss.tag = indexPath.row
        cell.btnDismiss.addTarget(self, action: #selector(FollowRequestViewController.btnDismissRequestClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Approve request
    @IBAction func btnApproveRequestClick(sender:AnyObject){
        
        //MARK: Web service / API to accept follower Request
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let follower_id = String(sender.tag)
        let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"follower_id":follower_id ]
        unblockBlockUser(params)
        
    }
    
    
    //MARK: Dismiss Request
    @IBAction func btnDismissRequestClick(sender:AnyObject){
        let tempAlert = UIAlertController(title: "Decline Button press, Working on this sectino", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        tempAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
        self.presentViewController(tempAlert, animated: true, completion: nil)
        
    }
    
    
    
//TOOD: - Web service / API implementation
    
    /**
     Fetch All Block users
     
     - parameter params: userID,token
     */
    func fetchBlockList(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.BLOCKED_USERS_LIST, multipartFormData: {
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
                                                let city_state = json["data"][ind]["city"].stringValue + ", " + json["data"][ind]["state"].stringValue
                                                let branch_name = json["data"][ind]["branch_name"].stringValue
                                                let user_profile_pic = json["data"][ind]["user_profile_pic"].stringValue
                                                let abbreviation = json["data"][ind]["abbreviation"].stringValue 
                                                
                                                self.requestDetails.append(FollowerRequestModel(dogtagid: dogtagid, name: user_fullname, location: city_state, country: country, status: branch_name, profile: user_profile_pic,userID: user_id,abbreviation:abbreviation,is_following: "",is_requested: "0")!)
                                                
                                                
                                            }
                                            print("requestDetails>> \(self.requestDetails)")
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
     Accept follower request
     
     - parameter params: userid,token,followe_id
     */
    func unblockBlockUser(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.UNBLOCK_USER, multipartFormData: {
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
    
    
    /**
     Decline followers request
     
     - parameter params: userid,token,follower_id
     */
    func declineFollowerRequest(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.FOLLOWER_REQUEST_LIST, multipartFormData: {
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
                                        GeneralUI_UI.alert(json["message"].string!)
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
