//
//  RightMenuViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 03/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Mixpanel

class RIghtTableViewCell : UITableViewCell{
    
    @IBOutlet weak var imgbadge: UIImageView!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
}

class RightMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
   var menuArray =  ["Notifications","General Comments","Change My Password","Edit Profile",
    "Customize DogTag",
    "Reference ID ",
    "Blocked Users",
    "Invite Friends",
    "Help Center",
    "Logout"]

    var verifyStatus : String = String()
    var userTypeId : String = String()
//TODO: - Controls
    var tmpImageView : UIImageView = UIImageView()
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var tblMain: UITableView!
//TODO: - Let's Code
    
    
    //let imagView : UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.clearColor()
        self.tblMain.tableFooterView = UIView()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print("ViewwillAppear")
        
        
        //MARK: Load Notification count
        let userID = General.loadSaved("user_id")
        let ref = General.loadSaved("reference_number")
        let params: [String: AnyObject] = ["user_id": userID, "reference": ref ]
        if(userID != ""){
            fetchNewMessageCount(params)
        }

        
        
        
        //let sideMenu = SSASideMenu()
        //sideMenu.backgroundImage = UIImage(named: "prof3.jpg")
        tmpImageView.frame = imgBG.frame
        tmpImageView.image = UIImage(named: "dummy_launch.png")
        let pic = user_dictonary["user_profile_pic"] as? String
        if(pic != nil && pic != ""){
            tmpImageView.contentMode = .ScaleAspectFit
          //  tmpImageView.hnk_setImageFromURL(NSURL(string: Urls.ProfilePic_Base_URL + pic!)!)
        }
        
        loadProfileDetails()
        initializeMenu()
        
        let newimg = UIImage(named: "dummy_launch.png") // self.convertToGrayScale(tmpImageView.image!)
        imgBG.image = newimg
        
        if(self.delObj.is_AccountDelete){
            //remove All View from memory
            self.delObj.is_AccountDelete = false
            self.navigationController?.popToRootViewControllerAnimated(true)
           
        }
        
        
        
    }
    
    
    /**
     Initialize menu options
     
     - returns: nothing
     */
    
    func initializeMenu(){
        //MARK: Check verification
        verifyStatus = General.loadSaved("verification_pending")
        userTypeId = General.loadSaved("user_typeid")
        
        
        if(verifyStatus == "1"){
            if(userTypeId == "1"){
                //MARK: User is military member
                
               
                menuArray =  ["Invite Friends","Notifications","Customize DogTag",
                              "General Comments","Edit Profile","Reference ID","Help Center",
                              "Logout"
                              ]
            }else{
                //MARK: Verified user is non military member
              
                menuArray =  ["Invite Friends","Notifications","Customize DogTag",
                              "General Comments","Edit Profile","Help Center",
                              "Logout"
                              ]
            }
            
            
        }else{
            //MARK: Non-Verified user
            if(userTypeId == "1"){
                //MARK: Non-Verified user is military user
                
                menuArray =  ["Invite Friends","Notifications","Customize DogTag",
                              "General Comments","Edit Profile","Reference ID",
                              "Verify Account",
                              "Help Center",
                              "Logout"
                              ]

            }else{
                //MARK: Non-Verified user is not military user
                
                menuArray =  ["Invite Friends","Notifications","Customize DogTag",
                              "General Comments","Edit Profile","Verify Account",
                              "Help Center",
                              "Logout"
                              
                ]
              
            }
           
        }
        self.tblMain.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Uncomment to convert into grayscale image
    func convertToGrayScale(image: UIImage) -> UIImage {
        let imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        let context = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpace, bitmapInfo.rawValue)
        
        CGContextDrawImage(context, imageRect, image.CGImage)
        let imageRef = CGBitmapContextCreateImage(context)
        let newImage = UIImage(CGImage: imageRef!)
        
        
        
        
        return newImage
    }
    
//TODO: - UITableViewDatasource Method implementatino
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return menuArray.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! RIghtTableViewCell
        cell.lblTitle.text = menuArray[indexPath.row]
        cell.selectionStyle = .None
        cell.lblCounter.hidden = true
        cell.imgbadge.hidden = true
        
        if(cell.lblTitle.text == "Notifications" || cell.lblTitle.text == "Reference ID"){
            cell.imgbadge.hidden = false
            cell.lblCounter.hidden = false
            
            
            if(cell.lblTitle.text == "Notifications"){
                let ct = Int(self.delObj.likeBadgeCount)! + Int(self.delObj.commentBadgeCount)! + Int(self.delObj.followrequestBadgeCount)!
                cell.lblCounter.text = String(ct)
                if(ct==0){
                    cell.imgbadge.hidden = true
                    cell.lblCounter.hidden = true
                }
            }else if(cell.lblTitle.text == "Reference ID"){
                let ct = Int(self.delObj.referenceBadgeCount)!
                
                cell.lblCounter.text = String(ct)
                if(ct==0){
                    cell.imgbadge.hidden = true
                    cell.lblCounter.hidden = true
                }
            }
        }
        
        /*let cell = tableView.dequeueReusableCellWithIdentifier("CellID")! as UITableViewCell
        cell.textLabel?.text = menuArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Swiss721BT-Light", size: 14)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.textAlignment = NSTextAlignment.Left
        cell.selectionStyle = UITableViewCellSelectionStyle.None*/
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let index = indexPath.row
        
        print("verifyStatus:\(verifyStatus) && userTypeId:\(userTypeId)" )
        if(verifyStatus == "1" && userTypeId == "1"){
            //MARK: user is military and verified account
            switch index {
            case 0:
                //Invite list
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navInvite") as! UINavigationController
                
                let uid = General.loadSaved("user_id")
                Mixpanel.mainInstance().identify(distinctId: uid)
                Mixpanel.mainInstance().track(event: "Invite Button Tap",
                                              properties: ["Invite Button Tap" : "Invite Button Tap"])

                self.presentViewController(noti, animated: true, completion: nil)
                break;
            case 1:
                //Notifications
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("notiNav") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
            case 2:
                
                //changeDogTag
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("changeDogTag") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
               
            case 3:
                
                //General Comment
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idReportViewController") as! ReportViewController
                noti.selection = 1
                self.presentViewController(noti, animated: true, completion: nil)
                break;
            case 4:
                //Edit My Profile
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navEditProfile") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
            case 5:
                //Verify References
                let veriStatus = General.loadSaved("verification_pending")
                if(veriStatus == "1"){
                    //MARK: Account is approved
                    let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navReferList") as! UINavigationController
                    self.presentViewController(noti, animated: true, completion: nil)
                }else{
                    //MARK: Account is approved
                    GeneralUI.alert(self.delObj.notApprovedMessage)
                }
                
                break;
            case 6:
                //Help Center
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navHelp") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
            case 7:
                //LogOut
                self.logoutAlert()
                break;
            default:
                print("Hurry..")
            }
            
        }else if(verifyStatus == "0" && userTypeId == "1"){
            //MARK: user is military but not verified account
            
            switch index {
            case 0:
                
                //Invite list
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navInvite") as! UINavigationController
                let uid = General.loadSaved("user_id")
                Mixpanel.mainInstance().identify(distinctId: uid)
                Mixpanel.mainInstance().track(event: "Invite Button Tap",
                                              properties: ["Invite Button Tap" : "Invite Button Tap"])

                self.presentViewController(noti, animated: true, completion: nil)
                break;
                
            case 1:
                //Notifications
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("notiNav") as! UINavigationController
                 self.presentViewController(noti, animated: true, completion: nil)
                 break;
            case 2:
                //changeDogTag
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("changeDogTag") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
                
                
                
            case 3:
                //General Comment
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idReportViewController") as! ReportViewController
                 noti.selection = 1
                 self.presentViewController(noti, animated: true, completion: nil)
                 break;
            case 4:
                //Edit My Profile
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navEditProfile") as! UINavigationController
                 self.presentViewController(noti, animated: true, completion: nil)
                 break;
            case 5:
                //Verify References
                let veriStatus = General.loadSaved("verification_pending")
                if(veriStatus == "1"){
                    //MARK: Account is approved
                    let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navReferList") as! UINavigationController
                    self.presentViewController(noti, animated: true, completion: nil)
                }else{
                    //MARK: Account is approved
                    GeneralUI.alert(self.delObj.notApprovedMessage)
                }
                
                break;
            case 6:
                //Verify section
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupVerificationOptionViewController") as! SignupVerificationOptionViewController
                let useridtype = General.loadSaved("user_typeid")
                noti.userid = General.loadSaved("user_id")
                //noti.branchid = self.branch
                
                self.delObj.isFromMenu = true
                self.delObj.signupSelectedIndex = Int(useridtype)!
                self.presentViewController(noti, animated: true, completion: nil)
                break;
                
                
              
            case 7:
                //Help Center
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navHelp") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
               
            case 8:
                //LogOut
                self.logoutAlert()
                break;

            default:
                print("Hurry..")
            }
            
        }
        else if(verifyStatus == "1" && userTypeId != "1"){
            //MARK: user is non military and verified account
            
            switch index {
            case 0:
                //Invite list
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navInvite") as! UINavigationController
                let uid = General.loadSaved("user_id")
                Mixpanel.mainInstance().identify(distinctId: uid)
                Mixpanel.mainInstance().track(event: "Invite Button Tap",
                                              properties: ["Invite Button Tap" : "Invite Button Tap"])

                self.presentViewController(noti, animated: true, completion: nil)
                break;
                
                
                
            case 1:
                //Notifications
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("notiNav") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
                
               
            case 2:
                //changeDogTag
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("changeDogTag") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
                
                
            case 3:
                //General Comment
                 let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idReportViewController") as! ReportViewController
                 noti.selection = 1
                 self.presentViewController(noti, animated: true, completion: nil)
                 break;
               
            case 4:
                //Edit My Profile
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navEditProfile") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
            
            case 5:
                //Help Center
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navHelp") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
            case 6:
                //LogOut
                self.logoutAlert()
                break;
            
            default:
                print("Hurry..")
            }
            
        }else if(verifyStatus == "0" && userTypeId != "1"){
            //MARK: user is non military and non verified account
          
            switch index {
            case 0:
                //Invite list
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navInvite") as! UINavigationController
                let uid = General.loadSaved("user_id")
                Mixpanel.mainInstance().identify(distinctId: uid)
                Mixpanel.mainInstance().track(event: "Invite Button Tap",
                                              properties: ["Invite Button Tap" : "Invite Button Tap"])

                self.presentViewController(noti, animated: true, completion: nil)
                break;
            case 1:
                //Notifications
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("notiNav") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
            case 2:
                //changeDogTag
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("changeDogTag") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
               
            case 3:
                //General Comment
                 let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idReportViewController") as! ReportViewController
                 noti.selection = 1
                 self.presentViewController(noti, animated: true, completion: nil)
                 break;
                
            case 4:
                //Edit My Profile
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navEditProfile") as! UINavigationController
                 self.presentViewController(noti, animated: true, completion: nil)
                 break;
            case 5:
                //Verify section
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupVerificationOptionViewController") as! SignupVerificationOptionViewController
                let useridtype = General.loadSaved("user_typeid")
                noti.userid = General.loadSaved("user_id")
                //noti.branchid = self.branch
                
                self.delObj.isFromMenu = true
                self.delObj.signupSelectedIndex = Int(useridtype)!
                self.presentViewController(noti, animated: true, completion: nil)
                break;
            case 6:
                //Help Center
                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navHelp") as! UINavigationController
                self.presentViewController(noti, animated: true, completion: nil)
                break;
            case 7:
                //LogOut
                self.logoutAlert()
                break;

            default:
                print("Hurry..")
            }
            
            
        }
       
      
    }
    
//TODO: - Display Alert
    
    func logoutAlert(){
       let logoutAlert =  UIAlertController(title: "Do you want to Logout?", message: "", preferredStyle: .Alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Logout", style: .Default, handler: { (value:UIAlertAction) in
            //Yes code here
            //MARK: web service call to logout
            let userID = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            let params: [String: AnyObject] = ["user_id": userID, "token_id": token ]
            self.logoutUser(params)
            
            
        }))
        
        
        logoutAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(logoutAlert, animated: true, completion: nil)
        
    }
    
    
//TODO: - Web service implementation
    
    /**
     Logout user
     
     - parameter params: user_id,token
     */
    
    func logoutUser(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.LOGOUT_USER, multipartFormData: {
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
                        self.cust.hideLoadingCircle()
                        self.view.userInteractionEnabled = true
                        
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
                                        General.saveData("0", name: "autologin")
                                        General.saveData("", name: "deviceTokenString")
                                         General.saveData("0", name: "badge_count")
                                        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                                       self.navigationController?.popToRootViewControllerAnimated(false)
                                        
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
    
    
    //TODO: - Web service / API implementation
    /**
     Web service call to all information related to login user
     */
    func loadProfileDetails() {
        let userID = General.loadSaved("user_id")
        let userToken = General.loadSaved("user_token")
        
        //self.cust.showLoadingCircle()
        
        Alamofire.request(.POST, Urls.PROFILE_VIEW, parameters: ["user_id":userID, "token_id":userToken])
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                        //  self.cust.hideLoadingCircle()
                        
                        let json = JSON(value)
                        print("json for menu profile:\(json)")
                        
                        //MARK: save user info in defaults to access later
                        user_dictonary["user_fullname"] = json[0]["user_fullname"].stringValue
                        user_dictonary["user_email"] = json[0]["user_email"].stringValue
                        user_dictonary["user_type"] = json[0]["user_type"].stringValue
                        user_dictonary["user_loc_city_state"] = json[0]["user_loc_city"].stringValue + ", " + json[0]["user_loc_state_abbr"].stringValue
                        //user_loc_state
                        user_dictonary["user_loc_country"] = json[0]["user_loc_country"].stringValue
                        user_dictonary["user_branch"] = json[0]["user_branch"].stringValue
                        user_dictonary["user_profile_pic"] = json[0]["user_profile_pic"].stringValue
                        user_dictonary["dogtag_batch"] = json[0]["dogtag_batch"].stringValue
                        user_dictonary["abbreviation"] = json[0]["user_loc_abbreviation"].stringValue
                        print("user_dictonary:\(user_dictonary)")
                        
                        let is_paid = "1" //json[0]["user_version"].stringValue
                        //let is_public = json[0]["is_public"].stringValue
                        let reference_number = json[0]["reference_number"].stringValue
                        let verification_pending = json[0]["verification_pending"].stringValue
                        
                        
                        General.saveData(is_paid, name: "is_paid")
                        //General.saveData(is_public, name: "is_public")
                        General.saveData(reference_number, name: "reference_number")
                        General.saveData(verification_pending, name: "verification_pending")
                        
                        
                        NSUserDefaults.standardUserDefaults().setObject(user_dictonary, forKey: "user_dictonary")
                        
                        self.initializeMenu()
                        
                        
                    }
                case .Failure(let error):
                   // GeneralUI.alert(error.localizedDescription)
                    // self.cust.hideLoadingCircle()
                    print(error)
                }
        }
    }

    
    /**
     Fetch all post from following and self
     
     - parameter params: userid, token
     */
    func fetchNewMessageCount(params: [String: AnyObject]) {
        
        
        print(params)
        Alamofire.upload(.POST, Urls_UI.FETCH_APP_COUNT, multipartFormData: {
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
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                print("JSON: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                        if(json["message"] != nil){
                                            // GeneralUI_UI.alert(json["message"].string!)
                                        }
                                        
                                    } else {
                                        print("You are in successful block")
                                        self.delObj.likeBadgeCount = json["like_count"].stringValue
                                        self.delObj.commentBadgeCount = json["comment_count"].stringValue
                                        self.delObj.messageBadgeCount = json["unread_count"].stringValue
                                        self.delObj.referenceBadgeCount = json["reference_count"].stringValue
                                        self.delObj.followrequestBadgeCount = json["follow_request"].stringValue
                                       
                                        
                                        let badgeCount = Int(self.delObj.likeBadgeCount)! +
                                            Int(self.delObj.commentBadgeCount)! +
                                            Int(self.delObj.messageBadgeCount)! +
                                            Int(self.delObj.referenceBadgeCount)! +
                                            Int(self.delObj.followrequestBadgeCount)!
                                         General.saveData(String(badgeCount), name: "badge_count")
                                        UIApplication.sharedApplication().applicationIconBadgeNumber = badgeCount
                                        
                                        
                                        NSNotificationCenter.defaultCenter().postNotificationName("PostBottomBadgeCounter", object: nil)
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                           // GeneralUI_UI.alert(error.localizedDescription)
                            print(error)
                        }
                    }
                case .Failure(let encodingError):
                    
                    print(encodingError)
                }
        })
    }

    
    //changeDogTag
}
