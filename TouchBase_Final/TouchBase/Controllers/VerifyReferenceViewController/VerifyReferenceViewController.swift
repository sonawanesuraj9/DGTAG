//
//  VerifyReferenceViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 06/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class RefernceIDCell: UITableViewCell {
    //
      var lblTitle: UILabel!
}

class VerifyReferenceViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var referenceDetails = [ReferenceListModel]()
    
//TODO: - Controls
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblRefNumber: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblMain: UITableView!
//TODO: - Let's Code    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let refVar = General.loadSaved("reference_number")
        self.lblRefNumber.text = refVar
        
        //MARK: Web service / API to fetch reference request
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let params: [String: AnyObject] = ["user_id": userID,"token_id":token,"reference":refVar]
        fetchMyRefernces(params)
        
        self.tblMain.tableFooterView = UIView()
        
        
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - UITableViewDatasource Method Implementation
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return referenceDetails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! RequestTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
       // cell.imgDogTags.image = UIImage(named: "img_dogtagBG-small\(self.delObj.deviceName)")
        
        
        cell.btnDismiss.setImage(UIImage(named: "btn_close\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        let data = self.referenceDetails[indexPath.row]
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
       // cell.imgDogTags.image = UIImage(named: "\(dogId)\(self.delObj.deviceName)")
        

        cell.imgProfile.image = UIImage(named: "img_profile-pic-upload\(self.delObj.deviceName)")
        let pic = data.profile
        cell.imgProfile.hnk_setImageFromURL(NSURL(string: Urls.ProfilePic_Base_URL + pic)!)
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
        cell.imgProfile.clipsToBounds = true
        
        
        //Button Action
        cell.btnApprove.tag = Int(data.userID)!
        cell.btnApprove.addTarget(self, action: #selector(VerifyReferenceViewController.btnApproveRequestClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.btnOtherUserProfile.tag = Int(data.userID)!
        cell.btnOtherUserProfile.addTarget(self, action: #selector(VerifyReferenceViewController.btnOtherUserProfileClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.btnDismiss.hidden = true
        cell.btnDismiss.tag = indexPath.row
        cell.btnDismiss.addTarget(self, action: #selector(VerifyReferenceViewController.btnDismissClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
       
        return cell
      
        
    }
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height * 0.158
    }*/
    
    
//TODO: - Web service / API implementation
    
    /**
     Fetch All My Refernces of user
     
     - parameter params: userID,token
     */
    func fetchMyRefernces(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.MY_REFERENCE_LIST, multipartFormData: {
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
                                
                                self.referenceDetails.removeAll()
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        
                                        if(json["result"].stringValue.containsString("No result found")){
                                            
                                        }else{
                                           GeneralUI_UI.alert(json["result"].stringValue)
                                        }
                                        self.tblMain.hidden = true
                                        self.lblMessage.hidden = false
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
                                                let city_state = json["result"][ind]["city"].stringValue + ", " + json["result"][ind]["state"].stringValue
                                                let branch_name = json["result"][ind]["branch_name"].stringValue
                                                let user_profile_pic = json["result"][ind]["user_profile_pic"].stringValue
                                                let abbreviation = json[""][ind]["abbreviation"].stringValue
                                                
                                                
                                                self.referenceDetails.append(ReferenceListModel(dogtagid: dogtagid, name: user_fullname, location: city_state, country: country, status: branch_name, profile: user_profile_pic,userID: user_id,abbreviation: abbreviation)!)
                                                
                                                
                                            }
                                            print("requestDetails>> \(self.referenceDetails)")
                                            self.tblMain.reloadData()
                                        }else{
                                            self.tblMain.hidden = true
                                            self.lblMessage.hidden = false
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
     Approve Reference Request
     
     - parameter params: userid,token,reference_id
     */
    func approveReferenceRequest(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.APPROVE_REFERENCE, multipartFormData: {
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
                        
                        let reference_id : String =  (params["reference_id"] as? String)!
                        print("reference_id 1:\(reference_id)")
                        
                        
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
                                        
                                        if(self.referenceDetails.count>0){
                                            for ind in 0...self.referenceDetails.count-1{
                                                let data = self.referenceDetails[ind]
                                                print("reference_id 2:\(reference_id)")
                                                if(data.userID == reference_id){
                                                    self.referenceDetails.removeAtIndex(ind)
                                                    break;
                                                }
                                            }//For ends
                                        }
                                        if(self.referenceDetails.count>0){
                                            self.lblMessage.hidden = true
                                            self.tblMain.hidden = false
                                            self.tblMain.reloadData()
                                        }else{
                                            self.lblMessage.hidden = false
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
    
    
    
//TODO: - UIButton Action
    
    //MARK: Approve request
    @IBAction func btnApproveRequestClick(sender:AnyObject){
        let veriStatus = General.loadSaved("verification_pending")
        if(veriStatus == "1"){

            //MARK: Web service / API to accept follower Request
            let userID = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            let reference_id = String(sender.tag)
            let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"reference_id":reference_id ]
            approveReferenceRequest(params)
        }
        else{
            GeneralUI.alert(self.delObj.notApprovedMessage)
        }
    }
    
    
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
    
    @IBAction func btnDismissClick(sender:UIButton){
        print("Dismiss Click:\(sender.tag)")
    }
    
    
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
