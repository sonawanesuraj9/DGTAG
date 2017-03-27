//
//  ProfileTabViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 30/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import JDropDownAlert
import SwiftOverlays
import ObjectMapper
import Haneke

extension String {
    func firstCharacterUpperCase() -> String {
        let lowercaseString = self.lowercaseString
        
        return lowercaseString.stringByReplacingCharactersInRange(lowercaseString.startIndex...lowercaseString.startIndex, withString: String(lowercaseString[lowercaseString.startIndex]).uppercaseString)
    }
}


class ProfileTabViewController: UIViewController,UIScrollViewDelegate {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var deviceWidth : CGFloat = CGFloat()
    var deviceHeight : CGFloat = CGFloat()
    
    var profileDetails = [ProfileValueModel]()
    var postDetails = [MyPostValueModel]()
//TODO: - Controls
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mainScrollview: UIScrollView!
    
    //3rd View
    @IBOutlet weak var btnInfoOutlet: UIButton!
    @IBOutlet weak var btnUpdatesOutlet: UIButton!
    
    //2nd View
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    
    @IBOutlet weak var btnEditOutlet: UIButton!
    //Common
    @IBOutlet weak var imgInfoTap: UIImageView!
    @IBOutlet weak var imgUpdateTap: UIImageView!
    @IBOutlet weak var imgDogTags: UIImageView!
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserPic: UIImageView!
//TODO: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.imgInfoTap.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileTabViewController.updateMyInfo(_:)), name:"updateUserInfo", object: nil)

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        deviceWidth = self.view.frame.width
        deviceHeight = self.view.frame.height
        
        self.imgFlag.hidden = true
        //MARK: Web service / API to fetch followers and following Count
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let params: [String: AnyObject] = ["user_id": userID, "token_id": token ]
        fetchFollowesAndFollowingCount(params)
        
        
        initLoginUserInfo()
        
        
        //self.imgDogTags.image = UIImage(named: "img_dogtagBG\(self.delObj.deviceName)")
        self.btnEditOutlet.setImage(UIImage(named: "btn_edit\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        
        self.imgInfoTap.image = UIImage(named: "img_selected-tab\(self.delObj.deviceName)")
        self.imgUpdateTap.image = UIImage(named: "img_selected-tab\(self.delObj.deviceName)")
        
        //MARK: Initially setup scrollview content size to device
        self.mainScrollview.contentSize = CGSizeMake(self.mainScrollview.frame.width,self.deviceHeight)
    }
    
    func updateMyInfo(notification: NSNotification){
        //Take Action on Notification
        initLoginUserInfo()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.btnInfoOutlet.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - Function
    
    func initLoginUserInfo(){
       
        //name
        let firstname = user_dictonary["user_fullname"] as? String
        self.lblUserName.text = firstname!.capitalizedString
        
        //address
        let location = user_dictonary["user_loc_city_state"] as? String
        self.lblLocation.text = location //location!.capitalizedString
        
        //country
        let country = user_dictonary["user_loc_country"] as? String
        self.lblCountry.text =  country!.capitalizedString
        
        //status
        let status = user_dictonary["user_branch"] as? String
        self.lblSection.text = status?.capitalizedString
        
        //Flag
        let flag = user_dictonary["abbreviation"] as? String
        if(flag != ""){
            self.imgFlag.hidden = false
             self.imgFlag.image = UIImage(named: "\(flag!).png")
        }
       
        
        //User profile
        let pic = user_dictonary["user_profile_pic"] as? String
        let ur = NSURL(string: Urls.ProfilePic_Base_URL + pic!)
        self.imgUserPic.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "avatar_thumbnail.jpg"), options: SDWebImageOptions.RefreshCached)
        self.imgUserPic.layer.cornerRadius = self.imgUserPic.frame.size.width/2
        self.imgUserPic.clipsToBounds = true
       
        //DogTag design 
        var dogTagID = user_dictonary["dogtag_batch"] as? String
        if(dogTagID == ""){
            dogTagID = "19"
        }
        if(dogTagID == "19"){
            self.lblUserName.textColor = UIColor.blackColor()
            self.lblLocation.textColor = UIColor.blackColor()
            self.lblCountry.textColor = UIColor.blackColor()
            self.lblSection.textColor = UIColor.blackColor()
        }else{
            self.lblUserName.textColor = UIColor.whiteColor()
            self.lblLocation.textColor = UIColor.whiteColor()
            self.lblCountry.textColor = UIColor.whiteColor()
            self.lblSection.textColor = UIColor.whiteColor()
        }
        self.imgDogTags.image = UIImage(named: "\(dogTagID!)\(self.delObj.deviceName)")
        
    }
    
    

//TODO: - UIButton Action
    
    @IBAction func btnEditProfileClick(sender: AnyObject) {
        let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navEditProfile") as! UINavigationController
        self.presentViewController(noti, animated: true, completion: nil)
    }
    
    //3rd View Click
    @IBAction func btnFollowersClick(sender: AnyObject) {
        let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idFollowersViewController") as! FollowersViewController
        noti.friendID = General.loadSaved("user_id")
        self.presentViewController(noti, animated: true, completion: nil)
    }
    
    @IBAction func btnFollowingClick(sender: AnyObject) {
        let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idFollowingViewController") as! FollowingViewController
        noti.friendID = General.loadSaved("user_id")
        self.presentViewController(noti, animated: true, completion: nil)
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

    /**
     Dynamically creates User Info view
     */
    func createInfoView(){
        removeControllsFromSubView()
        var yPos : CGFloat = CGFloat()
        var outHeight : CGFloat = CGFloat()
        
        let count = self.profileDetails.count
        let leftFrameWidth = deviceWidth*0.4062
        let rightFrameWidth = deviceWidth*0.5937
        for ind in 0...count-1{
            print(ind)
            
            yPos = yPos + outHeight + 8
            // = (CGFloat(ind)*35)+8
            print("**\(yPos)")
            
            let data = self.profileDetails[ind]
            var textOut : String = String()
            //var outHeight : CGFloat = CGFloat()
            
            textOut = data.detail
            //Determine Height
            let getHeight = heightForView(textOut, font: UIFont(name: cust.FontName, size: cust.FontSizeText)!, width: rightFrameWidth)
            if(getHeight<30){
                outHeight = 30
            }else{
                outHeight = getHeight
                
            }
            
            
            
            
            //Left View
            
            let initialFrame = CGRectMake(0, yPos,leftFrameWidth, outHeight)
            let contentInset : UIEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            let leftPaddedFrame : CGRect = UIEdgeInsetsInsetRect(initialFrame, contentInset)
            
            //Left Title
            let leftLabel : UILabel = UILabel(frame: leftPaddedFrame)
            leftLabel.textColor = Colors_UI.textColor
            leftLabel.backgroundColor = Colors_UI.profileTitleColor
            leftLabel.font = UIFont(name: cust.FontName, size: cust.FontSizeText)
            
            
            //Right View
            
            let rInitialFrame = CGRectMake(leftFrameWidth, yPos,rightFrameWidth, outHeight)
            let rContentInset : UIEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            let rightPaddedFrame : CGRect = UIEdgeInsetsInsetRect(rInitialFrame, rContentInset)
            
            //Right Title
            let rightLabel : UILabel =  UILabel(frame: rightPaddedFrame)
            rightLabel.textColor = Colors_UI.textColor
            rightLabel.backgroundColor = Colors_UI.profileValueColor
            rightLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            rightLabel.numberOfLines = 0
            rightLabel.font = UIFont(name: cust.FontName, size: cust.FontSizeText)
           
            
            //Assign data
           // let data = self.profileDetails[ind]
            leftLabel.text = data.name
            let labelTemp = data.detail
            if(labelTemp != ""){
                 labelTemp.capitalizedString
              // labelTemp = labelTemp.firstCharacterUpperCase()
               
            }
            rightLabel.text = labelTemp
            
            
            
           
            bottomView.addSubview(leftLabel)
            bottomView.addSubview(rightLabel)
            
            
           // self.bottomView.addSubview(outView)
        }
        
        self.bottomView.backgroundColor = UIColor.whiteColor()
        self.mainScrollview.contentSize = CGSizeMake(self.mainScrollview.frame.width,(self.topView.frame.origin.y + self.topView.frame.height) + yPos + 40)
        
    }
    
   
    /**
     Dynamically creates User's post view
     */
    func createPostView(){
        removeControllsFromSubView()
        
        var yPos : CGFloat = CGFloat()
        var textHeight : CGFloat = CGFloat()
        var imageHeight : CGFloat = CGFloat()
       
        
        let count = self.postDetails.count
        if(count>0){
            
       //
        for ind in 0...count-1{
            print(ind)
            
            /**/
            //1
            yPos = yPos + textHeight + 8 + imageHeight
            var imageFlag : Bool = Bool()
            //2
            let data = self.postDetails[ind]
            var textOut : String = String()
            
            
            //3
            if(data.post_content != ""){
                imageFlag = false
                imageHeight = 20
                textOut = data.post_content
                print("In content:\(ind)")
            }else if(data.post_caption != ""){
                imageFlag = true
                imageHeight = UIScreen.mainScreen().bounds.width
                 textOut = data.post_caption
                print("In caption:\(ind)")
            }else{
                imageFlag = true
                imageHeight = UIScreen.mainScreen().bounds.width
                 textOut = ""
               print("Only image:\(ind)")
            }
            
           
            //Determine Height
            let getHeight = heightForView(textOut, font: UIFont(name: cust.FontName, size: cust.FontSizeText)!, width: deviceWidth-25)
            print("\(ind) >> content height :\(getHeight)")
            textHeight = getHeight + 80
            
            
            //Remove previous view if any
            var mySubview:MyCustomView!
            if(mySubview != nil && !mySubview.view.hidden)
            {
                mySubview.view.removeFromSuperview()
            }
            
            
            //Set frame to new view
            mySubview = MyCustomView(frame: CGRect(x:0,y:yPos, width:deviceWidth, height:textHeight + imageHeight))
            
            
        
            
            print("mySubview frame :\(mySubview.frame)")
             mySubview.imgVideoIcon.hidden = true
            if(data.post_content != ""){
                 mySubview.lblContent.text = textOut
                mySubview.titleLabel.hidden = true
                mySubview.lblContent.hidden = false
                mySubview.imgVideoIcon.hidden = true
                mySubview.imageBottomConstraint.active = false
                
                
                mySubview.postCaptionHeight.active = true
                mySubview.postCaptionHeight.constant = 0.0
             
            }else
            {
                 mySubview.postCaptionHeight.active = false
                
                mySubview.imageBottomConstraint.active = true
                if(data.video_thumb != ""){
                    mySubview.imgVideoIcon.hidden = false
                }else{
                    mySubview.imgVideoIcon.hidden = true
                }
                
                mySubview.titleLabel.hidden = false
                mySubview.lblContent.hidden = true
                mySubview.titleLabel.text = textOut
               
            }
            
           //"My custom title"
           
           //Check image is nil or not
            if(!imageFlag){
                mySubview.myImage.hidden = true
            }else{
                
                var imgPostString = String()
                var placeholderImage = String()
                if(data.video_thumb != ""){
                    imgPostString = data.video_thumb
                    mySubview.myImage.contentMode = UIViewContentMode.ScaleAspectFit
                    placeholderImage = "pick_video_icon"
                }else{
                    imgPostString = data.photo_video
                    mySubview.myImage.contentMode = UIViewContentMode.ScaleAspectFill
                     placeholderImage = "pick_camera_icon"
                }
                
                
                let ur = NSURL(string: Urls.POSTVideo_Base_URL + imgPostString)
                mySubview.myImage.sd_setImageWithURL(ur, placeholderImage: UIImage(named: placeholderImage), options: SDWebImageOptions.RefreshCached)
                
                
                mySubview.myImage.hidden = false
            }
            
            var comment_count = data.comment_count
            var like_count = data.like_count
            let is_like = data.is_like
            
            //MARK: Convert date
            let tmmpDate = General.convertDateToUserTimezone(data.post_date)
            
            print("tmmpDate:\(tmmpDate)")
            
            
            mySubview.lblPostDate.text = tmmpDate //data.post_date
            
            //Button code
            if(comment_count == "0"){
                comment_count = " Comment"
            }else{
                comment_count = comment_count + " Comments"
            }
            
            if(like_count == "0"){
                like_count = " Like"
            }else{
                 like_count = like_count + " Likes"
            }
            
            mySubview.myButton.setTitle("\(like_count)", forState: UIControlState.Normal)
            if(is_like == "0"){
                 mySubview.myButton.setImage(UIImage(named: "img_star\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            }else{
                //Self like
                 mySubview.myButton.setImage(UIImage(named: "star-selected\(self.delObj.deviceName)"), forState: UIControlState.Normal)
                
            }
            mySubview.myButton.tag = Int(data.post_id)!
            mySubview.myButton.addTarget(self, action: #selector(ProfileTabViewController.btnLikePostClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            mySubview.btnComment.setTitle("\(comment_count)", forState: UIControlState.Normal)
            mySubview.btnComment.setImage(UIImage(named: "btn_comment\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            
            mySubview.btnComment.tag = ind
            mySubview.btnComment.addTarget(self, action: #selector(ProfileTabViewController.CommentButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            mySubview.btnMoreOption.tag = ind
            mySubview.btnMoreOption.addTarget(self, action: #selector(ProfileTabViewController.moreDetailButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            self.bottomView.addSubview(mySubview)
            
            
        }
        self.bottomView.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 232/255, alpha: 1.0)
        let ht = textHeight + imageHeight //+ 8 //CGFloat(secondHeight*CGFloat(count))
            
            //MARK: Show More button data
            var showMoreHeight : CGFloat = CGFloat()
            if(postDetails.count == 5){
                showMoreHeight = 40
            }else{
                showMoreHeight = 0
            }
            
            //MARK: Show more button
            let btnShowMore = UIButton()
            btnShowMore.frame = CGRectMake(0, yPos + ht + 10, UIScreen.mainScreen().bounds.size.width * 0.95, showMoreHeight)
            btnShowMore.backgroundColor = UIColor.blackColor()
            btnShowMore.center.x = self.view.center.x
            btnShowMore.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            btnShowMore.setTitle("Show More", forState: .Normal)
            btnShowMore.titleLabel?.font = UIFont(name: self.cust.FontName, size: self.cust.FontSizeTitle)
            btnShowMore.addTarget(self, action: #selector(ProfileTabViewController.btnShowMoreClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
           
            if(postDetails.count == 5){
                self.bottomView.addSubview(btnShowMore)
            }
            
            
            self.mainScrollview.contentSize = CGSizeMake(self.mainScrollview.frame.width,(self.topView.frame.origin.y + self.topView.frame.height) + yPos + ht + 20 + showMoreHeight)
            
            //self.mainScrollview.backgroundColor = UIColor.blueColor()
        }else{
            print("You do not have any post here")
            self.mainScrollview.contentSize = CGSizeMake(self.mainScrollview.frame.width,self.mainScrollview.frame.height)
        }
    }
    
    /**
     Remove all previous view from bottom view
     */
    func removeControllsFromSubView()
    {
        for view in bottomView.subviews {
            view.removeFromSuperview()
        }
        
    }
    
    
    @IBAction func moreDetailButtonClick(sender:UIButton){
        print(sender.tag)
        print("sender.tag >> \(sender.tag)")
        let data = self.postDetails[sender.tag]
        
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Edit Post", style: UIAlertActionStyle.Default, handler: { (vlue:UIAlertAction) in
            //Code here
            
            self.delObj.isPostEditEnable = true
            
            postContainerSingleton.postData.postCaption = data.post_caption
            postContainerSingleton.postData.postContent = data.post_content
            postContainerSingleton.postData.postID = data.post_id
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
       
        actionSheet.addAction(UIAlertAction(title: "Delete Post", style: .Default, handler: { (value:UIAlertAction) in
            //Code her
            
            //MARK: Confirmation alert
            let confAlert = UIAlertController(title: "Do you want to delete post?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            confAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                //Yes code here
                let postID = data.post_id
                
                //MARK: Web service / API to Delete users post
                let userID = General.loadSaved("user_id")
                let token = General.loadSaved("user_token")
                let params: [String: AnyObject] = ["userid": userID, "post_id": postID ,"token_id":token]
                print("params:\(params)")
                self.deletePost(params)
            }))
            
            
            confAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(confAlert, animated: true, completion: nil)
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func btnShowMoreClick(sender: AnyObject){
        print("Show more click")
        let showVC = self.storyboard?.instantiateViewControllerWithIdentifier("navShowMore") as! UINavigationController
        self.delObj.carryUserID = General.loadSaved("user_id")
        
        userDetailsSingleton.userDT.userID =  self.delObj.carryUserID        
        userDetailsSingleton.userDT.fullname = user_dictonary["user_fullname"] as? String
        userDetailsSingleton.userDT.country = user_dictonary["user_loc_country"] as? String
        userDetailsSingleton.userDT.location = user_dictonary["user_loc_city_state"] as? String
        userDetailsSingleton.userDT.status = user_dictonary["user_branch"] as? String
        userDetailsSingleton.userDT.dogTag_batch = user_dictonary["dogtag_batch"] as? String
        userDetailsSingleton.userDT.abbrivation = user_dictonary["abbreviation"] as? String
        userDetailsSingleton.userDT.profileurl = user_dictonary["user_profile_pic"] as? String
        
        self.presentViewController(showVC, animated: true, completion: nil)
    }
    
    //2nd View Click

    @IBAction func btnUpdateClick(sender: AnyObject) {
        self.btnInfoOutlet.backgroundColor = cust.lightButtonBackgroundColor
         self.btnUpdatesOutlet.backgroundColor = cust.darkButtonBackgroundColor
        self.imgInfoTap.hidden = true
        self.imgUpdateTap.hidden = false
        //createPostView()
        fetMyPosts()
        
    }
    
    @IBAction func btnInfoClick(sender: AnyObject) {
        self.btnInfoOutlet.backgroundColor = cust.darkButtonBackgroundColor
        self.btnUpdatesOutlet.backgroundColor = cust.lightButtonBackgroundColor
        self.imgInfoTap.hidden = false
        self.imgUpdateTap.hidden = true
        loadProfileDetails()
    }
    
    
    /**
     Like Post
     
     - parameter sender: Button
     */
    @IBAction func btnLikePostClick(sender:UIButton){
        
        
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
                if(data.post_id == postId){
                    if(data.is_like == "0"){
                        self.likePost(params){ response in
                            print("likePost:\(response)")
                            if(response){
                                print(" true")
                               let tmpCount = Int(data.like_count)
                                var outText : String = String()
                                if(tmpCount == 1){
                                    outText = "\(tmpCount!) Like"
                                }else{
                                    outText = "\(tmpCount!) Likes"
                                }
                                sender.setTitle("\(outText)", forState: UIControlState.Normal)
                                sender.setImage(UIImage(named: "star-selected\(self.delObj.deviceName)"), forState: UIControlState.Normal)
                            }else{
                                print(" false")
                            }
                            
                        }
                    }else{
                        self.unLikePost(params){ response in
                            print("unLikePost:\(response)")
                            if(response){
                                print(" true")
                                let tmpCount = Int(data.like_count)
                                var outText : String = String()
                                if(tmpCount == 0){
                                    outText = "Like"
                                }else{
                                    outText = "\(tmpCount!) Likes"
                                }
                                sender.setTitle("\(outText)", forState: UIControlState.Normal)
                                sender.setImage(UIImage(named: "img_star\(self.delObj.deviceName)"), forState: UIControlState.Normal)
                            }else{
                                print(" false")
                            }
                            
                        }
                    }
                }
            }
            
            
        }
        
        
    }
    

    /**
     Comment button is click
     
     - parameter sender: cell Comment
     */
    @IBAction func CommentButtonClick(sender:AnyObject){
        let postDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPostDetailContainerViewController") as! PostDetailContainerViewController
        let index = sender.tag
        let data = self.postDetails[index]
        DataContainerSingleton.sharedDataContainer.postID = data.post_id
        DataContainerSingleton.sharedDataContainer.postContent = data.post_content
        DataContainerSingleton.sharedDataContainer.postCommentCount = data.comment_count
        DataContainerSingleton.sharedDataContainer.postImage = data.photo_video
        DataContainerSingleton.sharedDataContainer.postLikeCount = data.like_count
        DataContainerSingleton.sharedDataContainer.isPostLike = data.is_like
        DataContainerSingleton.sharedDataContainer.postCaption = data.post_caption
        DataContainerSingleton.sharedDataContainer.video_thumb = data.video_thumb
        DataContainerSingleton.sharedDataContainer.postDate = data.post_date
         let userID = General.loadSaved("user_id")
        DataContainerSingleton.sharedDataContainer.postAuthor = userID
        
        
        userinfoCotainerSingleton.userinfo.fullname = user_dictonary["user_fullname"] as? String
         userinfoCotainerSingleton.userinfo.country = user_dictonary["user_loc_country"] as? String
        userinfoCotainerSingleton.userinfo.location = user_dictonary["user_loc_city_state"] as? String
         userinfoCotainerSingleton.userinfo.status = user_dictonary["user_branch"] as? String
        userinfoCotainerSingleton.userinfo.dogTag_batch = user_dictonary["dogtag_batch"] as? String
         userinfoCotainerSingleton.userinfo.abbrivation = user_dictonary["abbreviation"] as? String
         userinfoCotainerSingleton.userinfo.profileurl = user_dictonary["user_profile_pic"] as? String
        
        
        
        self.navigationController?.pushViewController(postDTVC, animated: true)
    }
    
//TOOD: - Web service / API implementation
    
    /**
     Web service call to all information related to login user
     */
    func loadProfileDetails() {
        let userID = General.loadSaved("user_id")
        let userToken = General.loadSaved("user_token")
        
        self.cust.showLoadingCircle()
        
        Alamofire.request(.POST, Urls.PROFILE_VIEW, parameters: ["user_id":userID, "token_id":userToken])
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        self.profileDetails.removeAll()
                        self.cust.hideLoadingCircle()
                        
                        let json = JSON(value)
                        print("json for edit profile:\(json)")
                        if let value:String = json[0]["user_fullname"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Name", detail: value, lock: "0")!)
                        }
                        
                        
                       /* if let user_email = json[0]["user_email"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Email Address", detail: user_email, lock: "0")!)
                        }*/
                        if let user_type:String = json[0]["user_type"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "User type", detail: user_type, lock: json[0]["type_islocked"].stringValue)!)
                        }
                        
                        
                        if let data:String = json[0]["user_service_status"].stringValue {
                            var tempStatus = json[0]["dependent"].stringValue
                            if(tempStatus != ""){
                                tempStatus = tempStatus.firstCharacterUpperCase()
                                self.profileDetails.append(ProfileValueModel(name: "Dependent status", detail: tempStatus, lock: "0")!)
                            }else{
                                self.profileDetails.append(ProfileValueModel(name: "Service status", detail: data, lock: "0")!)
                            }
                            
                            
                        }
                        
                        if let data:String = json[0]["user_ht_country"].stringValue {
                            
                            var city = ""
                            var state = ""
                            
                            if let data2:String = json[0]["user_ht_state"].stringValue {
                                state = data2
                                
                                if let data3:String = json[0]["user_ht_city"].stringValue {
                                    city = data3 + ", "
                                }
                            }
                            
                            
                            self.profileDetails.append(ProfileValueModel(name: "Hometown", detail: city + state  + "\n" + data, lock: json[0]["ht_country_islocked"].string!)!)
                        }
                        
                        if let data:String = json[0]["user_loc_country"].stringValue {
                            
                            var city = ""
                            var state = ""
                            
                            if let data2:String = json[0]["user_loc_state"].stringValue {
                                state = data2
                                
                                if let data3:String = json[0]["user_loc_city"].stringValue {
                                    city = data3 + ", "
                                }
                            }
                            
                            self.profileDetails.append(ProfileValueModel(name: "Current Location", detail: city + state + "\n" + data, lock: json[0]["loc_country_islocked"].string!)!)
                        }
                        
                        
                        if var data:String = json[0]["user_military_base"].stringValue {
                            var lockVal : String = String()
                            if data == "" {
                                data = "Not Applicable"
                                lockVal = "1"
                            }else{
                                lockVal = json[0]["military_base_islocked"].stringValue
                            }
                            self.profileDetails.append(ProfileValueModel(name: "Military base", detail: data, lock:lockVal )!)
                        }
                        
                        
                        if let data:String = json[0]["user_age"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Age", detail: data, lock: json[0]["birth_date_islocked"].stringValue)!)
                        }
                        
                        if let data:String = json[0]["user_gender"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Gender", detail: data, lock: json[0]["gender_islocked"].stringValue)!)
                        }
                        
                        if let data:String = json[0]["user_ethnicity"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Ethnicity", detail: data, lock: json[0]["ethnicity_islocked"].stringValue)!)
                        }
                        
                        if let data:String = json[0]["user_language"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Language", detail: data, lock: json[0]["language_islocked"].stringValue)!)
                        }
                        
                        if let data:String = json[0]["user_branch"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Branch", detail: data, lock: json[0]["branch_islocked"].stringValue)!)
                        }
                        
                        if let user_type:String = json[0]["user_type"].stringValue {
                            if user_type != "Military Dependent" {
                                
                                if let data:String = json[0]["user_paygrade"].stringValue {
                                    self.profileDetails.append(ProfileValueModel(name: "Paygrade", detail: data, lock: json[0]["paygrade_islocked"].stringValue)!)
                                }
                                
                                if let data:String = json[0]["user_rank"].stringValue {
                                    self.profileDetails.append(ProfileValueModel(name: "Rank", detail: data, lock: json[0]["rank_islocked"].stringValue)!)
                                }
                                
                                if let data:String = json[0]["user_job"].stringValue {
                                    self.profileDetails.append(ProfileValueModel(name: "Job", detail: data, lock: json[0]["job_islocked"].stringValue)!)
                                }
                            }
                        }
                                                
                        if let data:String = json[0]["user_has_children"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Children", detail: data, lock: "0")!)
                        }
                        if let data:String = json[0]["user_interest"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Interested In", detail: data, lock: "0")!)
                        }
                        if let data:String = json[0]["user_relationship"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Relationship", detail: data, lock: json[0]["relationship_islocked"].stringValue)!)
                        }
                        
                       self.createInfoView()
                        /*if let value = json[0]["user_ispublic"].string {
                         if value == "1" {
                         /* let image = UIImage(named: "profile_lock.png")
                         self.imageView = UIImageView(image: image!)
                         self.imageView.frame = CGRect(x: self.view.frame.width/2-58.0, y: 100.0, width: 116.0, height: 100.0)
                         self.imageView.tag = 7
                         self.view.addSubview(self.imageView)*/
                         //self.tableView.scrollEnabled = false
                         //self.profileDetails.removeAll()
                         self.tableView.reloadData()
                         } else {
                         if self.imageView != nil &&  self.imageView.tag == 7 {
                         self.imageView.removeFromSuperview()
                         self.imageView.tag = 3
                         }
                         self.tableView.scrollEnabled = true
                         self.tableView.reloadData()
                         }
                         }*/
                        
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    self.cust.hideLoadingCircle()
                    print(error)
                }
        }
    }
    
    
    /**
     Web service call to all information related to login user
     */
    func fetMyPosts() {
        let userID = General.loadSaved("user_id")
        self.cust.showLoadingCircle()
        
        Alamofire.request(.POST, Urls_UI.MY_POST_LIST_INDEX, parameters: ["userid":userID,"index":"0","max":"5"])
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        self.postDetails.removeAll()
                        self.cust.hideLoadingCircle()
                        
                        
                        let json = JSON(value)
                        print("json for edit profile:\(json)")
                        
                        let count = json["data"].array?.count
                        if(count>0){
                            for ind in 0...count!-1{
                                
                                let post_date = json["data"][ind]["post_date"].stringValue
                                let post_type = json["data"][ind]["post_type"].stringValue
                        
                                let post_content = json["data"][ind]["post_content"].stringValue
                                let video_thumb = json["data"][ind]["video_thumb"].stringValue
                                let photo_video = json["data"][ind]["photo_video"].stringValue
                                let post_caption = json["data"][ind]["post_caption"].stringValue
                                
                                let like_count = json["data"][ind]["like_count"].stringValue
                                let comment_count = json["data"][ind]["comment_count"].stringValue
                                let is_like = json["data"][ind]["is_like"].stringValue
                                let post_id = json["data"][ind]["post_id"].stringValue
                                //let video_thumb = json["data"][ind]["video_thumb"].stringValue
                                
                                self.postDetails.append(MyPostValueModel(post_date: post_date, post_type: post_type, post_content: post_content, video_thumb: video_thumb, photo_video: photo_video, post_caption: post_caption,like_count:like_count,comment_count: comment_count,is_like: is_like,post_id:post_id)!)
                                
                            }
                        }

                        
                        self.createPostView()
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    self.cust.hideLoadingCircle()
                    print(error)
                }
        }
    }
    
    //TODO: - Web service / API implementation
    
    func fetchFollowesAndFollowingCount(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.FOLLOWERS_FOLOWING_COUNT, multipartFormData: {
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
                                /**/
                               // self.lblFollowingCount.text = "0"
                                //self.lblFollowersCount.text = "0"
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                    } else {
                                        print("You are in successful block")
                                        let count = json["data"].array?.count
                                        if(count>0){
                                            for ind in 0...count!-1{
                                                self.lblFollowersCount.text = json["data"][ind]["follower_count"].stringValue
                                                self.lblFollowingCount.text = json["data"][ind]["following_count"].stringValue
                                            }
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
                    self.cust.hideLoadingCircle()
                    print(encodingError)
                }
        })
    }
    
    
    
    
    /**
     Like to specific post will be here
     
     - parameter params: userid, postid, token
     */
    
    func likePost(params: [String: AnyObject], completion : (Bool) -> ()) {
        
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
                                         completion(false)
                                    } else {
                                        print("You are in successful block")
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                        
                                        if(self.postDetails.count>0){
                                            for ind in 0...self.postDetails.count-1{
                                                let data = self.postDetails[ind]
                                                print("post_id 2:\(post_id)")
                                                if(data.post_id == post_id){
                                                    data.is_like = "1"
                                                    data.like_count = json["like_count"].stringValue
                                                     completion(true)
                                                    break;
                                                }
                                            }//For ends
                                            //self.tblMain.reloadData()
                                        }
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                             completion(false)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                     completion(false)
                    print(encodingError)
                }
        })
    }
    
    
    
    /**
     Unlike to previously like post
     
     - parameter params: userid, postid, token
     */
    
    func unLikePost(params: [String: AnyObject], completion : (Bool) -> ()) {
        
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
                                        completion(false)
                                    } else {
                                        print("You are in successful block")
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                        if(self.postDetails.count>0){
                                            for ind in 0...self.postDetails.count-1{
                                                let data = self.postDetails[ind]
                                                print("post_id 2:\(post_id)")
                                                if(data.post_id == post_id){
                                                    data.is_like = "0"
                                                    data.like_count = json["like_count"].stringValue
                                                    completion(true)
                                                    break;
                                                }
                                            }//For ends
                                            //self.tblMain.reloadData()
                                        }
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                            completion(false)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    completion(false)
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
                                        self.fetMyPosts()
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
