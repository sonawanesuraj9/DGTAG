//
//  HomeTabViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 30/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVKit
import AVFoundation
import Mixpanel

class HomeTabViewController: UIViewController,UIPopoverPresentationControllerDelegate,Dimmable, UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let postFont = UIFont(name: "Swiss721BT-Light", size: 14)
    var postDetails = [PostValueModel]()
    var CounterDetails = [CounterValueModel]()
    var CallToWS : Bool = Bool()
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    
//TODO: - Controls
    @IBOutlet weak var btnTmp: UIButton!
    
    @IBOutlet weak var lblNoPost: UILabel!
    @IBOutlet weak var tblMain: UITableView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    //Message
    @IBOutlet weak var imgMessageCounter: UIImageView!
    @IBOutlet weak var lblMessageCounter: UILabel!
//TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblMain.tableFooterView = UIView()
        
        self.tblMain.rowHeight = UITableViewAutomaticDimension
        self.tblMain.estimatedRowHeight = 350
        
        //MARK: Web service / API to fetch followers request
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        

        //Index
        var tmpIndex : String = String()
        if(self.postDetails.count>0){
            tmpIndex = String(self.postDetails.count)
        }else{
            tmpIndex = "0"
        }
        
        let params: [String: AnyObject] = ["user_id": userID, "token_id": token, "index": tmpIndex ]
        self.postDetails.removeAll()
        fetchPostForMe(params)
        
        //MARK: Notifcation implementation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTabViewController.methodOfReceivedNotification(_:)), name:"PostReloadHomePage", object: nil)
        
        
        //MARK: Notifcation implementation
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTabViewController.GotDeviceTokenNotification(_:)), name:"GotDeviceToken", object: nil)
    }
    
    /**
     Notification raised
     
     - parameter notification: HomeTab
     */
    func methodOfReceivedNotification(notification: NSNotification){
        //Take Action on Notification
        
        //MARK: Web service / API to fetch followers request
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
        self.postDetails.removeAll()
        self.tblMain.reloadData()
        
        //Index
        var tmpIndex : String = String()
        tmpIndex = "0"
        let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"index":tmpIndex ]
        fetchPostForMe(params)
    }
    
    func GotDeviceTokenNotification(notification: NSNotification){
        //Take Action on Notification
        //MARK: Update Device token
        let userID = General.loadSaved("user_id")
        let dt = General.loadSaved("deviceTokenString")
        if(self.delObj.deviceTokenToSend != ""){
            let params: [String: AnyObject] = ["user_id": userID, "device_token": dt]
            self.updateDeviceToken(params)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        self.delObj.screenTag = 1
        
        self.lblMessageCounter.hidden = true
        self.imgMessageCounter.hidden = true
        
        
        //MARK: Web service / API to fetch followers request
        let userID = General.loadSaved("user_id")
        
        let messageParams : [String: AnyObject] = ["user_id": userID]
        fetchNewMessageCount(messageParams)
        
        
        //MARK: Update Device token
        let dt = General.loadSaved("deviceTokenString")
        if(self.delObj.deviceTokenToSend != ""){
            let params: [String: AnyObject] = ["user_id": userID, "device_token": dt]
            self.updateDeviceToken(params)
        }
        
        
        //MARK: Load Notification count
        let ref = General.loadSaved("reference_number")
        let params1: [String: AnyObject] = ["user_id": userID, "reference": ref ]
        if(userID != ""){
            fetchNewMessageCount(params1)
        }
        
        
        if(defaults.valueForKey("user_dictonary") != nil){
            user_dictonary = defaults.valueForKey("user_dictonary")  as! [String : AnyObject]
        }
        //MARK: Load userdetails
        self.loadProfileDetails()
        
        //MARK: Delegation
        if(self.delObj.isSomeThingEdited){
            let carryPostID = self.delObj.carryPostID
            let ct = postDetails.count
            if(ct>0){
                for pos in 0...ct-1{
                    let postdt = postDetails[pos]
                    if(carryPostID == postdt.postid){
                        //Edit from here
                        //MARK: Web service / API to fetch followers request
                        let userID = General.loadSaved("user_id")
                        let token = General.loadSaved("user_token")
                        let params: [String: AnyObject] = ["user_id": userID, "token_id": token, "post_id": self.delObj.carryPostID]
                        fetchSinglePostForMe(params)
                    }
                }
            }
        }
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - UITableViewDataSource Method Implementation
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.postDetails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! HomeTableViewCell
        //cell.imgDogTags.image = UIImage(named: "img_dogtagBG-small\(self.delObj.deviceName)")
        
        let tapGest : UITapGestureRecognizer = UITapGestureRecognizer()
        cell.imgDogTags.userInteractionEnabled = true
        cell.imgDogTags.addGestureRecognizer(tapGest)
        tapGest.addTarget(self, action: #selector(HomeTabViewController.dogTagClick))
        
        
        cell.btnOption.setImage(UIImage(named: "img_inner-menu\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        //MARK: - User's Data
        let data = self.postDetails[indexPath.row]
        cell.lblName.text = data.user_fullname
        cell.lblLocation.text = data.city + ", " + data.state
        cell.lblCountry.text = data.country
        cell.lblPosition.text = data.branch_name

        //MARK: - DogTag & Text Color
        let dogId = data.dogtag_batch
        if(dogId == "19"){
            cell.lblName.textColor = UIColor.blackColor()
            cell.lblLocation.textColor = UIColor.blackColor()
            cell.lblCountry.textColor = UIColor.blackColor()
            cell.lblPosition.textColor = UIColor.blackColor()
        }else{
            cell.lblName.textColor = UIColor.whiteColor()
            cell.lblLocation.textColor = UIColor.whiteColor()
            cell.lblCountry.textColor = UIColor.whiteColor()
            cell.lblPosition.textColor = UIColor.whiteColor()
        }
         cell.imgDogTags.image = UIImage(named: "\(dogId)\(self.delObj.deviceName)")
        
        //Flag
        let flagName = data.abbreviation
        if(flagName != ""){
            cell.imgFlag.image = UIImage(named: "\(flagName).png")
        }
        
       
        let pic = data.user_profile_pic
        
        let ur = NSURL(string: Urls.ProfilePic_Base_URL + pic)
        cell.imgProfile.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "avatar_thumbnail.jpg"), options: SDWebImageOptions.RefreshCached)
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
        cell.imgProfile.clipsToBounds = true
        
        cell.btnLikes.setTitle("\(data.likeCount) Likes", forState: UIControlState.Normal)
        cell.btnComment.setTitle("\(data.commentCount) Comment", forState: UIControlState.Normal)
        
       
        //MARK: - POST data
         cell.lblPost.hidden = true
        
        //MARK: Convert date
        let tmmpDate = General.convertDateToUserTimezone(data.post_date)
        print("tmmpDate:\(tmmpDate)")
        
        cell.lblPostDate.text = tmmpDate //data.post_date
        if(data.post_content != ""){
            
            //Remove space for caption
            
            cell.lblPost.text = data.post_content
            cell.topConstraint.active = true
            cell.imgPost.hidden = true
            cell.imgVidThumb.hidden = true
            cell.imgPost.frame.size.height = 0.0
           cell.bottomConstraint.active = false
            
            cell.lblPost.hidden = false
            cell.lblCaption.hidden = true
           
            cell.imgPost.updateConstraints()
           
            self.view.layoutIfNeeded()
            
        }else{
           cell.topConstraint.active = false
            cell.imgPost.hidden = false
            cell.bottomConstraint.active = true
            //Uncomment to generate Thumbnail
            
            //Video Working code
            /*let videoURL = NSURL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
            let player = AVPlayer(URL: videoURL!)
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = cell.bounds
            
            cell.layer.addSublayer(playerLayer)
            player.play()*/
            
            //cell.imgPost.image = UIImage(named: "")
            if(data.video_thumb != ""){
                //MARK: Display video thumb
                cell.imgVidThumb.hidden = false
                 let imgPostString = data.video_thumb
                
                let ur = NSURL(string: Urls.POSTVideo_Base_URL + imgPostString)
                cell.imgPost.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "pick_video_icon"), options: SDWebImageOptions.RefreshCached)
                cell.imgPost.contentMode = UIViewContentMode.ScaleAspectFit

                
            }else{
                //MARK: Display Image here
                cell.imgVidThumb.hidden = true
                 let imgPostString = data.photo_video
                
                let ur = NSURL(string: Urls.POSTVideo_Base_URL + imgPostString)
                cell.imgPost.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "pick_camera_icon"), options: SDWebImageOptions.RefreshCached)
                cell.imgPost.contentMode = UIViewContentMode.ScaleToFill

            }
            
           
            
            

            
            //MARK: Check if caption is entered or not
            if(data.post_caption != ""){
                //cell.captionView.hidden = false
                cell.lblCaption.hidden = false
                cell.lblCaption.text = data.post_caption
            }else{
                //cell.captionView.hidden = true
                cell.lblCaption.hidden = true
               
            }
            
        }
        
        //Buttons
        
        
        if(data.isLike == "0"){
            //previosuly not like, now go and Like post
            cell.btnLikes.tag = Int(data.postid)!
            cell.btnLikes.addTarget(self, action: #selector(HomeTabViewController.btnLikePostClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.btnLikes.setImage(UIImage(named: "img_star\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            
        }else{
            //previously like post now go and Unlikes or never like
            cell.btnLikes.setImage(UIImage(named: "star-selected\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            cell.btnLikes.tag = Int(data.postid)!
            cell.btnLikes.addTarget(self, action: #selector(HomeTabViewController.btnLikePostClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
       
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(HomeTabViewController.cellMoreOptionClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.btnComment.tag = indexPath.row
        cell.btnComment.addTarget(self, action: #selector(HomeTabViewController.CommentButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.btnOtheruserProfile.tag = indexPath.row
        cell.btnOtheruserProfile.addTarget(self, action: #selector(HomeTabViewController.btnOtherUserProfileClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    //Detect last cell
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastSectionIndex : NSInteger = tblMain.numberOfSections - 1
        let lastRowIndex : NSInteger = tblMain.numberOfRowsInSection(lastSectionIndex) - 1
        if(lastRowIndex > 4){
            if (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex){
                print("You are at last cell")
               
                //Activity Indicator
                
                let spinner : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                spinner.frame = CGRectMake(0, 0, 44, 44)
                spinner.startAnimating()
                self.tblMain.tableFooterView = spinner
                /*
                 
                 UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
                 [spinner startAnimating];
                 spinner.frame = CGRectMake(0, 0, 320, 44);
                 self.tableView.tableFooterView = spinner;
                 */
                
                
                //MARK: Web service / API to fetch followers request
                let userID = General.loadSaved("user_id")
                let token = General.loadSaved("user_token")
                
                //Index
                var tmpIndex : String = String()
                if(self.postDetails.count>0){
                    tmpIndex = String(self.postDetails.count)
                }else{
                    tmpIndex = "0"
                }
                
                let params: [String: AnyObject] = ["user_id": userID, "token_id": token, "index": tmpIndex ]
                fetchPostForMe(params)
                
                
            }
        }
    }
    
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
       //print("\(indexPath.row)cell height changed to:\(self.delObj.dashCellHeight)")
        
        var outHeight : CGFloat =  CGFloat()
         let data = self.postDetails[indexPath.row]
        let wid = self.tblMain.frame.width - 16
        //print("wid:\(wid)")
        //print("\(indexPath.row) data.post_content>> \( data.post_content)")
        
        let textHeight = heightForView(data.post_content, font: postFont!, width: wid)
        let captionHeight = heightForView(data.post_caption, font: postFont!, width: wid)
        let imageHeight = UIScreen.mainScreen().bounds.width
        let dogtagHeight : CGFloat = 90
        let commentBarHeight : CGFloat = 30
        let bottomButtonHeight : CGFloat = 30
        
        if(data.post_content != ""){
            //MARK: Only contents
            print("textHeight:\(textHeight)")
            outHeight = dogtagHeight + commentBarHeight + textHeight
        }else{
            //Image with or without caption
             print("captionHeight:\(captionHeight)")
            outHeight = dogtagHeight + commentBarHeight + bottomButtonHeight + imageHeight + captionHeight //+ 30
        }
        
       
        print("outHeight:\(outHeight)")
        outHeight = outHeight  + 55
        print("After outHeight:\(outHeight)")
        
        return 350 //outHeight //self.delObj.dashCellHeight
    }*/
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let postDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPostDetailContainerViewController") as! PostDetailContainerViewController
        let index = indexPath.row
        let data = self.postDetails[index]
        DataContainerSingleton.sharedDataContainer.postID = data.postid
        DataContainerSingleton.sharedDataContainer.postContent = data.post_content
        DataContainerSingleton.sharedDataContainer.postCommentCount = data.commentCount
        DataContainerSingleton.sharedDataContainer.postImage = data.photo_video
        DataContainerSingleton.sharedDataContainer.postLikeCount = data.likeCount
        DataContainerSingleton.sharedDataContainer.isPostLike = data.isLike
        DataContainerSingleton.sharedDataContainer.postCaption = data.post_caption
        DataContainerSingleton.sharedDataContainer.postDate = data.post_date
        DataContainerSingleton.sharedDataContainer.video_thumb = data.video_thumb
        DataContainerSingleton.sharedDataContainer.postAuthor = data.author
        self.delObj.carryPostID = data.postid
        
        //MARK: User info
        userinfoCotainerSingleton.userinfo.userID = data.author
        userinfoCotainerSingleton.userinfo.country = data.country
        userinfoCotainerSingleton.userinfo.dogTag_batch = data.dogtag_batch
        userinfoCotainerSingleton.userinfo.fullname = data.user_fullname
        userinfoCotainerSingleton.userinfo.location = data.city + ", " + data.state
        userinfoCotainerSingleton.userinfo.profileurl = data.user_profile_pic
        userinfoCotainerSingleton.userinfo.status = data.branch_name
        userinfoCotainerSingleton.userinfo.abbrivation = data.abbreviation
        print(" data.abbreviation:\( data.abbreviation)")
        self.navigationController?.pushViewController(postDTVC, animated: true)
        
    }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
//TODO: - Function
    /**
     Function to view other user's profile
     */
    func dogTagClick(){
        let navVC = self.storyboard?.instantiateViewControllerWithIdentifier("navOtherUserProfile") as! UINavigationController
        let uid = General.loadSaved("user_id")
        Mixpanel.mainInstance().identify(distinctId: uid)
        Mixpanel.mainInstance().track(event: "DogTag Tap",
                                      properties: ["DogTag Tap" : "DogTag Tap"])

        self.presentViewController(navVC, animated: true, completion: nil)
    }
    
    
    func deleteSelfPost(postID:String){
        
        //MARK: Web service / API to unlike post
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let postID = postID
        let params: [String: AnyObject] = ["userid": userID, "post_id": postID ,"token_id":token]
        self.deletePost(params)
    }
    
    func displayBlockAlert(followerID : String){
        let blockAlert = UIAlertController(title: "", message: "Do you want to block user?", preferredStyle: UIAlertControllerStyle.Alert)
        blockAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
            //Hnadle Yes value
           
            //MARK: Web service / API to unlike post
            let userID = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            let followerID = String(followerID)
            let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"follower_id":followerID ]
            self.blockFollower(params)
            
        }))
        
        blockAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (value:UIAlertAction) in
            //Hnadle NO value
        }))
        self.presentViewController(blockAlert, animated: true, completion: nil)
        
    }
    
    func displayReportAlert(postID:String){
      /* let reportAlert = self.storyboard?.instantiateViewControllerWithIdentifier("idReportAlertVC") as! ReportAlertVC
        reportAlert.postID = postID
        self.presentViewController(reportAlert, animated: true, completion: nil)*/
        
        let reportAlert = UIAlertController(title: "Report Reason", message: "", preferredStyle: .ActionSheet)
        reportAlert.addAction(UIAlertAction(title: "It’s Spam", style: .Destructive, handler: { (value:UIAlertAction) in
            //
            print("1")
            print("It’s spam")
            self.reportProblem(postID, reason: "It’s spam")
        }))
        
        reportAlert.addAction(UIAlertAction(title: "It’s Abusive", style: .Destructive, handler: { (value:UIAlertAction) in
            //
            print("2")
            print("It’s Abusive")
            self.reportProblem(postID, reason: "It’s Abusive")
        }))
        
        reportAlert.addAction(UIAlertAction(title: "Security Issue", style: .Destructive, handler: { (value:UIAlertAction) in
            //
            print("3")
            print("Security Issue")
            self.reportProblem(postID, reason: "Security Issue")
        }))
        
        reportAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (value:UIAlertAction) in
            //
            print("4")
        }))
        
        self.presentViewController(reportAlert, animated: true, completion: nil)
        
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dim(.In, alpha: dimLevel, speed: dimSpeed)
    }
    
    @IBAction func unwindFromSecondary(segue: UIStoryboardSegue) {
        dim(.Out, speed: dimSpeed)
        
    }

    
//TODO: - UIButton Action
    
    @IBAction func btnOtherUserProfileClick(sender:UIButton){
        let veriStatus = General.loadSaved("verification_pending")
        if(veriStatus == "1"){
        print("other:\(sender.tag)")
        if(postDetails.count>0){
            let data = postDetails[sender.tag]
            let followID = data.author
            let userid = General.loadSaved("user_id")
            print("followID:\(followID)")
        
            if(userid != followID){
                let otherVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
                otherVC.friendID = followID
                self.navigationController?.pushViewController(otherVC, animated: true)
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
    
    
    @IBAction func shareCurrentPost(){
        let shareVC = self.storyboard?.instantiateViewControllerWithIdentifier("navSharePost") as! UINavigationController
        
        self.presentViewController(shareVC, animated: true, completion: nil)    
    }
    
    
    /**
     Button for 3 dot's
     
     - parameter sender: cell button
     */
    @IBAction func cellMoreOptionClick(sender:UIButton){
        let data = self.postDetails[sender.tag]
        
        let actionMore = UIAlertController(title: "", message: "Perform Following Action", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let followerID = data.author
        let user_id = General.loadSaved("user_id")
        print("followerID:\(followerID)")
        
        //MARK: Only Self user can delete self posts
        if(user_id == followerID){
            
            //MARK: Edit
            
            actionMore.addAction(UIAlertAction(title: "Edit Post", style: UIAlertActionStyle.Default, handler: { (vlue:UIAlertAction) in
                //Code here
                
                self.delObj.isPostEditEnable = true
                
                postContainerSingleton.postData.postCaption = data.post_caption
                postContainerSingleton.postData.postContent = data.post_content
                postContainerSingleton.postData.postID = data.postid
                postContainerSingleton.postData.postImage = data.photo_video
                postContainerSingleton.postData.vid_thumb = data.video_thumb
                
                if(data.post_content != ""){
                    //MARK: Move to edit status
                    let statVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAddStatusViewController") as! AddStatusViewController
                    self.navigationController?.pushViewController(statVC, animated: true)
                }else{
                    //MARK: Move to edit multimedia
                    let multiVC = self.storyboard?.instantiateViewControllerWithIdentifier("idMulitimediaPostContainerVC") as! MulitimediaPostContainerVC
                    self.navigationController?.pushViewController(multiVC, animated: true)
                    
                }
            }))
       
            
            
            
            //MARK: Delete
            actionMore.addAction(UIAlertAction(title: "Delete Post", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                //MARK: Delete self post
                self.deleteSelfPost(data.postid)
                
            }))
            
            
            
        }
        
        
        //MARK: Only followers can block, same user can not block him self
        if(user_id != followerID){
            
            actionMore.addAction(UIAlertAction(title: "Block User", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
           
                    self.displayBlockAlert(followerID)
           
            
            }))
            
            actionMore.addAction(UIAlertAction(title: "Report", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                
                let postID = data.postid
                print("postID:\(postID)")
                self.displayReportAlert(postID)
                
            }))
        
         }
        
        
        
        actionMore.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(actionMore, animated: true, completion: nil)
    }
    
    /**
     Comment button is click
     
     - parameter sender: cell Comment
     */
    @IBAction func CommentButtonClick(sender:AnyObject){
        let postDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPostDetailContainerViewController") as! PostDetailContainerViewController
        let index = sender.tag
        let data = self.postDetails[index]
        print("data:\(data.author)")
        DataContainerSingleton.sharedDataContainer.postID = data.postid
        DataContainerSingleton.sharedDataContainer.postContent = data.post_content
        DataContainerSingleton.sharedDataContainer.postCommentCount = data.commentCount
        DataContainerSingleton.sharedDataContainer.postImage = data.photo_video
        DataContainerSingleton.sharedDataContainer.postLikeCount = data.likeCount
        DataContainerSingleton.sharedDataContainer.isPostLike = data.isLike
        DataContainerSingleton.sharedDataContainer.postCaption = data.post_caption
        DataContainerSingleton.sharedDataContainer.postDate = data.post_date
        DataContainerSingleton.sharedDataContainer.video_thumb = data.video_thumb
        DataContainerSingleton.sharedDataContainer.postAuthor = data.author
        self.delObj.carryPostID = data.postid
        
        //MARK: User info
        userinfoCotainerSingleton.userinfo.userID = data.author
        userinfoCotainerSingleton.userinfo.country = data.country
        userinfoCotainerSingleton.userinfo.dogTag_batch = data.dogtag_batch
        userinfoCotainerSingleton.userinfo.fullname = data.user_fullname
        userinfoCotainerSingleton.userinfo.location = data.city + ", " + data.state
        userinfoCotainerSingleton.userinfo.profileurl = data.user_profile_pic
        userinfoCotainerSingleton.userinfo.status = data.branch_name
        userinfoCotainerSingleton.userinfo.abbrivation = data.abbreviation
        
        self.navigationController?.pushViewController(postDTVC, animated: true)
    }
    
    /**
     Like Post
     
     - parameter sender: Button
     */
    @IBAction func btnLikePostClick(sender:UIButton){
        
        
       /* UIView.animateWithDuration(0.6, animations: { () -> Void in
            sender.transform = CGAffineTransformMakeScale(1.3, 1.3)
        }) { (Value:Bool) -> Void in
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                sender.transform = CGAffineTransformIdentity
                }, completion: nil)
            
            //MARK: Web service / API to like post
            let userID = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            let postId = String(sender.tag)
            let params: [String: AnyObject] = ["userid": userID, "token_id": token,"post_id":postId ]
            self.likePost(params)
            
        }*/
        
        
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            sender.transform = CGAffineTransformMakeScale(1.3, 1.3)
        }) { (Value:Bool) -> Void in
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                sender.transform = CGAffineTransformIdentity
                }, completion: nil)
            
            
            //MARK: Web service / API to unlike post
            let userID = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            let postId = String(sender.tag)
            let params: [String: AnyObject] = ["userid": userID, "token_id": token,"post_id":postId ]
            
            for ind in 0...self.postDetails.count-1{
                let data = self.postDetails[ind]
                if(data.postid == postId){
                    if(data.isLike == "0"){
                        self.likePost(params)
                    }else{
                        self.unLikePost(params)
                    }
                }
            }
            
            
        }

        
    }
    
    /**
     UnLike Post
     
     - parameter sender: button
     */
    @IBAction func btnunLikePostClick(sender:UIButton){
        
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            sender.transform = CGAffineTransformMakeScale(1.3, 1.3)
        }) { (Value:Bool) -> Void in
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                sender.transform = CGAffineTransformIdentity
                }, completion: nil)
            
            
            //MARK: Web service / API to unlike post
            let userID = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            let postId = String(sender.tag)
            let params: [String: AnyObject] = ["userid": userID, "token_id": token,"post_id":postId ]
            
            for ind in 0...self.postDetails.count-1{
                let data = self.postDetails[ind]
                if(data.postid == postId){
                    if(data.isLike == "0"){
                        self.likePost(params)
                    }else{
                        self.unLikePost(params)
                    }
                }
            }
            
           
        }

       
    }
    
    /**
     Share photo
     
     - parameter sender: Photo/Video button
     */
    @IBAction func btnPhotoClick(sender: AnyObject) {
        
        let veriStatus = General.loadSaved("verification_pending")
        if(veriStatus == "1"){
            //MARK: Account is approved
            let multiVC = self.storyboard?.instantiateViewControllerWithIdentifier("idMulitimediaPostContainerVC") as! MulitimediaPostContainerVC
            self.delObj.isPostEditEnable = false
            self.navigationController?.pushViewController(multiVC, animated: true)
        }else{
            //MARK: Account is approved
            GeneralUI.alert(self.delObj.notApprovedMessage)
        }
    }
    
    /**
     Status Button code
     
     - parameter sender: status button
     */
    @IBAction func btnStatusClick(sender: AnyObject) {
        //MARK: Limited Access >>
        let veriStatus = General.loadSaved("verification_pending")
        
        if(veriStatus == "1"){
            //MARK: Account is approved
            let statVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAddStatusViewController") as! AddStatusViewController
            self.delObj.isPostEditEnable = false
            self.navigationController?.pushViewController(statVC, animated: true)
        }else{
            //MARK: Account is approved
            
           GeneralUI.alert(self.delObj.notApprovedMessage)
        }
        
        
        
    }
    
    
    /**
     Message button
     
     - parameter sender: message button
     */
    @IBAction func btnMessageClick(sender: AnyObject) {
        let veriStatus = General.loadSaved("verification_pending")
        if(veriStatus == "1"){
            //MARK: Account is approved
            
            let msgListVC = self.storyboard?.instantiateViewControllerWithIdentifier("idMessageViewController") as! MessageViewController
            self.navigationController?.pushViewController(msgListVC, animated: true)
        }else{
            //MARK: Account is approved
            
            GeneralUI.alert(self.delObj.notApprovedMessage)
        }
        
    }
    
    /**
     Invite Button
     
     - parameter sender: Invite Button
     */
    @IBAction func btnInviteClick(sender: AnyObject) {
        let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navInvite") as! UINavigationController
        let uid = General.loadSaved("user_id")
        Mixpanel.mainInstance().identify(distinctId: uid)
        Mixpanel.mainInstance().track(event: "Invite Button Tap",
                                      properties: ["Invite Button Tap" : "Invite Button Tap"])

        self.presentViewController(noti, animated: true, completion: nil)
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
                        print("json for edit profile:\(json)")
                        
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
                        
                        self.delObj.user_branch = json[0]["user_branch"].stringValue
                        self.delObj.user_branchid = json[0]["user_branchid"].stringValue
                        
                        let is_paid = "1" //json[0]["user_version"].stringValue
                        //let is_public = json[0]["is_public"].stringValue
                        let reference_number = json[0]["reference_number"].stringValue
                        let verification_pending = json[0]["verification_pending"].stringValue
                        
                        
                        General.saveData(is_paid, name: "is_paid")
                       // General.saveData(is_public, name: "is_public")
                        General.saveData(reference_number, name: "reference_number")
                        General.saveData(verification_pending, name: "verification_pending")
                        
                        
                        NSUserDefaults.standardUserDefaults().setObject(user_dictonary, forKey: "user_dictonary")
                        
                        
                        
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                   // self.cust.hideLoadingCircle()
                    print(error)
                }
        }
    }

    
    /**
     Fetch all post from following and self
     
     - parameter params: userid, token
     */
    func fetchPostForMe(params: [String: AnyObject]) {
        
        if(!CallToWS){
            CallToWS = true
        print("123**:\(params)")
            if(self.postDetails.count==0){
            self.view.userInteractionEnabled = false
             self.cust.showLoadingCircle()
          }
        
            Alamofire.upload(.POST, Urls_UI.LIST_POST, multipartFormData: {
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
                                self.CallToWS = false
                               // print("JSON: \(json)")
                                /**/
                                // self.lblFollowingCount.text = "0"
                                //self.lblFollowersCount.text = "0"
                                if let status = json["status"].string {
                                    if status != "0" {
                                        if(json["message"] != nil){
                                            GeneralUI_UI.alert(json["message"].string!)
                                        }
                                        if(json["message"].stringValue.containsString("No feeds found")) {
                                            self.tblMain.hidden = true
                                        }
                                       // self.tblMain.hidden = true
                                        self.lblNoPost.hidden = false
                                         self.tblMain.tableFooterView = nil
                                    } else {
                                        print("You are in successful block")
                                        let count = json["data"].array?.count
                                        print("****count:\(count)")
                                        if(count>0){
                                           
                                            for ind in 0...count!-1 {
                                                //in success
                                                print("index\(ind)")
                                                //user data
                                                let user_id = json["data"][ind]["author"].stringValue
                                                let user_fullname = json["data"][ind]["user_fullname"].stringValue
                                                let country = json["data"][ind]["country"].stringValue
                                                let city = json["data"][ind]["city"].stringValue
                                                let state = json["data"][ind]["state_abbr"].stringValue //json["data"][ind]["user_ht_state_abbr"].stringValue   
                                                let branch_name = json["data"][ind]["branch_name"].stringValue
                                                let user_profile_pic = json["data"][ind]["user_profile_pic"].stringValue
                                                let dog_tag = json["data"][ind]["dogtag_batch"].stringValue
                                                let abbreviation = json["data"][ind]["abbreviation"].stringValue
                                                
                                                //post data
                                                let postid = json["data"][ind]["postid"].stringValue
                                                let post_date = json["data"][ind]["post_date"].stringValue
                                                let post_type = json["data"][ind]["post_type"].stringValue
                                                let post_content = json["data"][ind]["post_content"].stringValue
                                                let photo_video = json["data"][ind]["photo_video"].stringValue
                                                let post_caption = json["data"][ind]["post_caption"].stringValue
                                                let id = json["data"][ind]["id"].stringValue
                                                let video_thumb = json["data"][ind]["video_thumb"].stringValue
                                                
                                                //Counter
                                                let likeCount = json["data"][ind]["like_count"].stringValue
                                                let commentCount = json["data"][ind]["comment_count"].stringValue
                                                let isLike = json["data"][ind]["is_like"].stringValue
                                                self.postDetails.append(PostValueModel(postid: postid, author: user_id, user_fullname: user_fullname, user_profile_pic: user_profile_pic, post_date: post_date, post_type: post_type, post_content: post_content, photo_video: photo_video, post_caption: post_caption, id: id, country: country, state: state, city: city, branch_name: branch_name,commentCount: commentCount,likeCount: likeCount,isLike: isLike,dogtag_batch: dog_tag,abbreviation:abbreviation,video_thumb: video_thumb)!)
                                                
                                            }
 
                                            self.tblMain.tableFooterView = nil
                                            print("requestDetails>> \(self.postDetails)")
                                            self.tblMain.reloadData()
                                            self.tblMain.hidden = false
                                            //self.createPostView()
                                             self.lblNoPost.hidden = true
                                        }else{
                                            self.tblMain.tableFooterView = nil
                                            self.tblMain.hidden = true
                                            self.lblNoPost.hidden = false
                                        }
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            self.CallToWS = false
                            self.tblMain.tableFooterView = nil
                            GeneralUI_UI.alert(error.localizedDescription)
                            print(error)
                        }
                    }
                case .Failure(let encodingError):
                    self.CallToWS = false
                    self.tblMain.tableFooterView = nil
                    self.cust.hideLoadingCircle()
                    print(encodingError)
                }
        })
        }else{
            
            print("WS is already call")
        }
    }
    
    /**
     Fetch single post from following and self
     
     - parameter params: userid, token
     */
    func fetchSinglePostForMe(params: [String: AnyObject]) {
        
            print("123**:\(params)")
            
            Alamofire.upload(.POST, Urls_UI.SINGLE_POST, multipartFormData: {
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
                                    print("single post json :\(json)")
                                    
                                    if let status = json["status"].string {
                                        if status != "0" {
                                           
                                        } else {
                                            print("You are in successful block")
                                            self.delObj.isSomeThingEdited = false
                                            
                                            let is_like = json["data"]["is_like"].stringValue
                                            let like_count = json["data"]["like_count"].stringValue
                                            let comment_count = json["data"]["comment_count"].stringValue
                                            
                                            let ct = self.postDetails.count
                                            if(ct>0){
                                                for ind in 0...ct-1{
                                                    let postdt = self.postDetails[ind]
                                                    if(self.delObj.carryPostID == postdt.postid){
                                                        postdt.likeCount = like_count
                                                        postdt.commentCount = comment_count
                                                        postdt.isLike = is_like
                                                        break;
                                                    }
                                                    
                                                }
                                            }
                                            
                                            self.tblMain.reloadData()
                                            self.tblMain.hidden = false
                                            
                                        }
                                    }
                                    
                                }
                            case .Failure(let error):
                                
                                GeneralUI_UI.alert(error.localizedDescription)
                                print(error)
                            }
                        }
                    case .Failure(let encodingError):
                       
                        self.cust.hideLoadingCircle()
                        print(encodingError)
                    }
            })
        
        }
    
    
    /**
     Fetch all post from following and self
     
     - parameter params: userid, token
     */
    func fetchNewMessageCount(params: [String: AnyObject]) {
        
        //self.view.userInteractionEnabled = false
        print(params)
        //self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.FETCH_NEW_MESSAGE_COUNT, multipartFormData: {
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
                                        if(json["message"] != nil){
                                            GeneralUI_UI.alert(json["message"].string!)
                                        }
                                        
                                    } else {
                                        print("You are in successful block")
                                        let cunt = json["unread count"].stringValue
                                        if(Int(cunt) > 0){
                                            self.lblMessageCounter.text = cunt
                                            self.lblMessageCounter.hidden = false
                                            self.imgMessageCounter.hidden = false
                                        }else{
                                            self.lblMessageCounter.hidden = true
                                            self.imgMessageCounter.hidden = true
                                        }
                                       print("New Message count : \(cunt)")
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                           // GeneralUI_UI.alert(error.localizedDescription)
                            print(error)
                        }
                    }
                case .Failure(let encodingError):
                    self.cust.hideLoadingCircle()
                    print(encodingError)
                }
        })
    }
    
    
    
    
    
    /**
     Like to specific post will be here
     
     - parameter params: userid, postid, token
     */
    
    func likePost(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        
        Alamofire.upload(.POST, Urls_UI.LIKE_POST, multipartFormData: {
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
                        let post_id : String =  (params["post_id"] as? String)!
                        print("post_id 1:\(post_id)")
                        
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
                                       GeneralUI_UI.alert(json["message"].stringValue)
                                        
                                        if(self.postDetails.count>0){
                                            for ind in 0...self.postDetails.count-1{
                                                let data = self.postDetails[ind]
                                                print("post_id 2:\(post_id)")
                                                if(data.postid == post_id){
                                                    data.isLike = "1"
                                                    var tmpLikeCt = Int(data.likeCount)
                                                    tmpLikeCt = tmpLikeCt! + 1
                                                    data.likeCount = String(tmpLikeCt!)
                                                    break;
                                                }
                                            }//For ends
                                            self.tblMain.reloadData()
                                        }
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                          //  GeneralUI_UI.alert(error.localizedDescription)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                   
                    print(encodingError)
                }
        })
    }
    
    
    
    /**
     Unlike to previously like post
     
     - parameter params: userid, postid, token
     */
    
    func unLikePost(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        //self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.UNLIKE_POST, multipartFormData: {
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
                        let post_id : String =  (params["post_id"] as? String)!
                        print("post_id 1:\(post_id)")
                        
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
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                        if(self.postDetails.count>0){
                                            for ind in 0...self.postDetails.count-1{
                                                let data = self.postDetails[ind]
                                                print("post_id 2:\(post_id)")
                                                if(data.postid == post_id){
                                                    data.isLike = "0"
                                                    var tmpLikeCt = Int(data.likeCount)
                                                    tmpLikeCt = tmpLikeCt! - 1
                                                    data.likeCount = String(tmpLikeCt!)
                                                    break;
                                                }
                                            }//For ends
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
                    print(encodingError)
                }
        })
    }
    
    
    
    /**
     Unlike to previously like post
     
     - parameter params: userid, postid, token
     */
    
    func blockFollower(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.BLOCK_FOLLOWER, multipartFormData: {
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
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                    } else {
                                        print("You are in successful block")
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                       
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
    
    /**
     Delete post
     
     - parameter params: userid, postid, token
     */
    
    func deletePost(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.MY_POST_DELETE, multipartFormData: {
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
                        let post_id : String =  (params["post_id"] as? String)!
                        print("post_id 1:\(post_id)")
                        
                        
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
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                        //After success
                                       
                                        if(self.postDetails.count>0){
                                            for ind in 0...self.postDetails.count-1{
                                                let data = self.postDetails[ind]
                                                print("post_id 2:\(post_id)")
                                                if(data.postid == post_id){
                                                    self.postDetails.removeAtIndex(ind)
                                                    break;
                                                }
                                            }//For ends
                                            self.tblMain.reloadData()
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
    
    
    /**
     update Device Token
     
     - parameter params: user_id, device_token
     */
    
    func updateDeviceToken(params: [String: AnyObject]) {
        print("*Params:\(params)")
        Alamofire.upload(.POST, Urls_UI.UPDATE_DEVICE_TOKEN, multipartFormData: {
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
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                          print(json["message"].stringValue)
                                    } else {
                                        self.delObj.isDeviceTokenSend = 1
                                        print("You are in successful block")
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            print(error)
                        }
                    }
                case .Failure(let encodingError):                    
                    print(encodingError)
                }
        })
    }
    
    
    
    /**
     Web service call to all information related to login user
     */
    func reportProblem(postID:String,reason:String) {
        let userID = General.loadSaved("user_id")
        let userToken = General.loadSaved("user_token")
        print("postIDassasa>>\(postID)")
        //print("reason:\(self.selectedReason)")
        self.cust.showLoadingCircle()
        
        Alamofire.request(.POST, Urls_UI.REPORT_POST, parameters: ["userid":userID, "token_id":userToken,"post_id":postID,"reason":reason])
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                        self.cust.hideLoadingCircle()
                        
                        let json = JSON(value)
                        print("json for REPORT_POST:\(json)")
                        if(json["status"] != "0"){
                            GeneralUI.alert(json["status"].stringValue)
                        }else{
                            GeneralUI.alert("Reported successfully")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    self.cust.hideLoadingCircle()
                    print(error)
                }
        }
    }

    
    
    
    /**
     Fetch all post from following and self
     
     - parameter params: userid, token
     */
    func fetchAllMessageCount(params: [String: AnyObject]) {
        
        
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
                                        
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            //GeneralUI_UI.alert(error.localizedDescription)
                            print(error)
                        }
                    }
                case .Failure(let encodingError):
                    
                    print(encodingError)
                }
        })
    }
    
    
}
