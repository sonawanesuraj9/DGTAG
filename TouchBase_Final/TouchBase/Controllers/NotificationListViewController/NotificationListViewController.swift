//
//  NotificationListViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 03/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class notificationTableViewCell : UITableViewCell{
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imgBadge: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
}
class NotificationListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var menuArray : [String] = ["Follow Request",
        "Like",
        "Comment"
        ]
    
//TODO: - Controls
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblMain: UITableView!
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblMain.tableFooterView = UIView()
        
        //MARK: Notifcation implementation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotificationListViewController.methodOfReceivedNotification(_:)), name:"PostReloadNotificationTab", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //MARK: Web service call
        //loadProfileDetails()
        
        //MARK: Load Notification count
        let userID = General.loadSaved("user_id")
        let ref = General.loadSaved("reference_number")
        let params: [String: AnyObject] = ["user_id": userID, "reference": ref ]
        if(userID != ""){
            fetchNewMessageCount(params)
        }
        //fetchAllCounters()
        
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    /**
     Notification raised
     
     - parameter notification: HomeTab
     */
    func methodOfReceivedNotification(notification: NSNotification){
        
        //Take Action on Notification
       //self.fetchAllCounters()
        
        //MARK: Load Notification count
        let userID = General.loadSaved("user_id")
        let ref = General.loadSaved("reference_number")
        let params: [String: AnyObject] = ["user_id": userID, "reference": ref ]
        if(userID != ""){
            fetchNewMessageCount(params)
        }
    }
    
    
   
    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

//TODO: - UITableViewDatasource Method implementatino
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return menuArray.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! notificationTableViewCell
        cell.selectionStyle = .None
        cell.lblTitle.text = menuArray[indexPath.row]
        
        cell.imgBadge.hidden = true
        cell.lblCount.hidden = true
        
        if(Int(self.delObj.followrequestBadgeCount) > 0 && indexPath.row == 0){
            cell.imgBadge.hidden = false
            cell.lblCount.hidden = false
            
            cell.lblCount.text = self.delObj.followrequestBadgeCount
            
            
        }else if(Int(self.delObj.likeBadgeCount) > 0 && indexPath.row == 1){
            cell.imgBadge.hidden = false
            cell.lblCount.hidden = false
            
            cell.lblCount.text = self.delObj.likeBadgeCount
            
            
        }else if(Int(self.delObj.commentBadgeCount) > 0 && indexPath.row == 2){
            cell.imgBadge.hidden = false
            cell.lblCount.hidden = false
            cell.lblCount.text = self.delObj.commentBadgeCount
        }
        
        return cell
        
       /* let cell = tableView.dequeueReusableCellWithIdentifier("CellID")! as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = menuArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Swiss721BT-Light", size: 14)
        cell.textLabel?.textColor = self.cust.darkButtonBackgroundColor
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell*/
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let index = indexPath.row
        switch index {
        case 0:
            let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idFollowRequestViewController") as! FollowRequestViewController
            self.navigationController?.pushViewController(noti, animated: true)
            break;
        case 1:
            let collectionPic = self.storyboard?.instantiateViewControllerWithIdentifier("idLikedPostViewController") as! LikedPostViewController
            self.navigationController?.pushViewController(collectionPic, animated: true)
            break;
        case 2:
            let collectionPic = self.storyboard?.instantiateViewControllerWithIdentifier("idCommentedPostViewController") as! CommentedPostViewController
            self.navigationController?.pushViewController(collectionPic, animated: true)

            break;
        case 3:
            let collectionPic = self.storyboard?.instantiateViewControllerWithIdentifier("idPhotoCollectionViewController") as! PhotoCollectionViewController
            self.navigationController?.pushViewController(collectionPic, animated: true)

            break;
       
        default:
            print("Hurry..")
        }

    }
    
    
//TODO: - Web service / API implementation
    
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
                                        self.tblMain.reloadData()
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
}

