//
//  UpgradeMembershipViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 27/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Mixpanel

enum Direction { case In, Out }

protocol Dimmable { }

extension Dimmable where Self: UIViewController {
    
    func dim(direction: Direction, color: UIColor = UIColor.blackColor(), alpha: CGFloat = 0.0, speed: Double = 0.0) {
        
        switch direction {
        case .In:
            
            // Create and add a dim view
            let dimView = UIView(frame: view.frame)
            dimView.backgroundColor = color
            dimView.alpha = 0.0
            view.addSubview(dimView)
            
            // Deal with Auto Layout
            dimView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            
            // Animate alpha (the actual "dimming" effect)
            UIView.animateWithDuration(speed) { () -> Void in
                dimView.alpha = alpha
            }
            
        case .Out:
            UIView.animateWithDuration(speed, animations: { () -> Void in
                self.view.subviews.last?.alpha = alpha ?? 0
                }, completion: { (complete) -> Void in
                    self.view.subviews.last?.removeFromSuperview()
            })
        }
    }
}


class UpgradeMembershipViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,Dimmable {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    @IBOutlet weak var btnDummyPurchase: UIButton!
    var dogTagImageName : [String] = []
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    var selectionArray : [String] = []
    var militaryStatus : [String] = ["Navy","Military UserType","Military UserType","Military UserType","Military UserType","Military UserType","Military UserType","Military UserType","Military UserType","Military UserType","Military UserType","Military UserType",
    "Air Force ABU",
    "Army ACU",
    "Army CP",
    "Coast Guard",
    "Marin Corps Dessert",
    "Marin Corps Digital",
    "Navy NWU",
    "Navy Type 3"]
    
//TODO: - Controls
    
    @IBOutlet weak var tblMain: UITableView!
//TODO: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblMain.dataSource = self
        self.tblMain.delegate = self
        
        selectionArray.removeAll(keepCapacity: false)
        for _ in 0...19{
            selectionArray.append("0")
        }
        tblMain.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
         self.btnDummyPurchase.hidden = true
        //let ispaid = General.loadSaved("is_paid")
        /*if(ispaid == "1"){
            self.btnDummyPurchase.hidden = true
        
        }else{
             self.btnDummyPurchase.hidden = false
        }*/
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dim(.In, alpha: dimLevel, speed: dimSpeed)
    }
    
    @IBAction func unwindFromSecondary(segue: UIStoryboardSegue) {
        dim(.Out, speed: dimSpeed)
    }
    
   
    
//TODO: - UITableViewDatasource method implementation
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("selectionArray.count:\(selectionArray.count)")
        return selectionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! UpgradeTableViewCell
        
        /*let ind = (self.selectionArray.count-1) - indexPath.row
        let name = "\(ind)\(self.delObj.deviceName)"
        print("DGNAME:\(name)")*/
        cell.imgDogTag.image = UIImage(named: "\(indexPath.row)\(self.delObj.deviceName)")
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let pic = user_dictonary["user_profile_pic"] as? String
        let ur = NSURL(string: Urls.ProfilePic_Base_URL + pic!)
        cell.imgProfile.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "avatar_thumbnail.jpg"), options: SDWebImageOptions.RefreshCached)
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
        cell.imgProfile.clipsToBounds = true
        
        cell.lblName.text = user_dictonary["user_fullname"] as? String
        cell.lblStatus.text = user_dictonary["user_branch"] as? String //militaryStatus[indexPath.row]
        cell.lblCountry.text = user_dictonary["user_loc_country"] as? String
        cell.lblLocation.text = user_dictonary["user_loc_city_state"] as? String
        
        //DogTag design
        let dogTagID = user_dictonary["dogtag_batch"] as? String
        
        if(dogTagID == String(indexPath.row)){
            cell.btnSelection.setImage(UIImage(named: "radio-selected"), forState: UIControlState.Normal)
            selectionArray[indexPath.row] = "1"
        }else{
            cell.btnSelection.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
        }
        
        //selection
        if(selectionArray[indexPath.row] == "1"){
            cell.btnSelection.setImage(UIImage(named: "radio-selected"), forState: UIControlState.Normal)
        }else{
            cell.btnSelection.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
        }
        
        
        if(indexPath.row == (self.selectionArray.count-1)){
            cell.lblName.textColor = UIColor.blackColor()
            cell.lblLocation.textColor = UIColor.blackColor()
            cell.lblCountry.textColor = UIColor.blackColor()
            cell.lblStatus.textColor = UIColor.blackColor()
        }else{
            cell.lblName.textColor = UIColor.whiteColor()
            cell.lblLocation.textColor = UIColor.whiteColor()
            cell.lblCountry.textColor = UIColor.whiteColor()
            cell.lblStatus.textColor = UIColor.whiteColor()
        }
        
        //Flag
        let flag = user_dictonary["abbreviation"] as? String
        if(flag != ""){
            cell.imgFlag.hidden = false
            cell.imgFlag.image = UIImage(named: "\(flag!).png")
        }
        
        
        //Button Target
        
        cell.btnSelection.tag = indexPath.row
        cell.btnSelection.addTarget(self, action: #selector(UpgradeMembershipViewController.selectionClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height * 0.158
    }*/
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let verify = General.loadSaved("verification_pending")
        
        //MARK: Check verification is done or not
        if(verify == "1"){
            
        
            for ind in 0...selectionArray.count-1{
                selectionArray[ind] = "0"
            }
        
            selectionArray[indexPath.row] = "1"
        
            self.tblMain.reloadData()
        }else{
            GeneralUI.alert("Your account isn't approves yet")
        }
        //self.tblMain.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }

    
//TODO: - UIButton Action
    
    @IBAction func selectionClick(sender:UIButton){
        
        let verify = General.loadSaved("verification_pending")
        
        //MARK: Check verification is done or not
        if(verify == "1"){
            for ind in 0...selectionArray.count-1{
                selectionArray[ind] = "0"
            }
        
            selectionArray[sender.tag] = "1"
        
            print("selectionArray:\(selectionArray)")
            
            self.tblMain.reloadData()
        }else{
            GeneralUI.alert("Your account isn't approved yet")
        }
    }
    
    @IBAction func btnPurchaseClick(sender: AnyObject) {
        //let ispaid = General.loadSaved("is_paid")
        //if(ispaid == "1"){
        //MARK: Obtain DogTag ID
        
        let verify = General.loadSaved("verification_pending")
        
        //MARK: Check verification is done or not
        if(verify == "1"){
            
            var dogID : String = String()
            for ind in 0...selectionArray.count-1{
                if(selectionArray[ind] == "1"){
                    dogID = String(ind)
                    break
                }
            }
        
            //MARK: Web service / API to change My DogTag
            let userID = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"dogtag_id":dogID ]
            self.changeMyDogTag(params)
        }else{
            GeneralUI.alert("Your account isn't approved yet")
        }
        /*}else{
            let alert  = UIAlertController(title: "", message: "Purchase Premium Membership for Full Access", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }*/
     
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
//TODO: - Web service / API implementation
    
    /**
     change my DogTag
     
     - parameter params: user_id,dogtag id, token
     */
    func changeMyDogTag(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.CHANGE_DOGTAG, multipartFormData: {
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
                        let tag_id : String =  (params["dogtag_id"] as? String)!
                        print("tag_id 1:\(tag_id)")
                        
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
                                        
                                        //MARK: If user is verified then
                                        let isVerified = General.loadSaved("verification_pending")
                                        if(isVerified == "1"){
                                            
                                                //MARK: Track user is Verified & User Customized DogTag
                                            let uid = General.loadSaved("user_id")
                                            Mixpanel.mainInstance().identify(distinctId: uid)
                                                Mixpanel.mainInstance().track(event: "Customized DogTag",
                                                properties: ["Customized DogTag" : "Customized DogTag"])

                                            
                                        }
                                        
                                        
                                        
                                        GeneralUI_UI.alert(json["message"].string!)
                                        user_dictonary["dogtag_batch"] = tag_id
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
