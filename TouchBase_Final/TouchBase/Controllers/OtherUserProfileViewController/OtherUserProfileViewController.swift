//
//  OtherUserProfileViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 19/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Mixpanel

class OtherUserProfileViewController: UIViewController {
    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var friendID : String = String()
    
    var deviceWidth : CGFloat = CGFloat()
    var deviceHeight : CGFloat = CGFloat()
    var max = 5
    var profileDetails = [ProfileValueModel]()
    var postDetails = [MyPostValueModel]()
    
    var isCompleteLock : Bool = Bool()
    var isFollowing : Bool = Bool()
    
    var otherUserInfo : [String: AnyObject] = [String: AnyObject]()
    
//TODO: - Controls
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var btnFollowOutlet: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
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
    
    
    
//TODO: - Let's code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        deviceWidth = self.view.frame.width
        deviceHeight = self.view.frame.height
        
        self.imgFlag.hidden = true
        
        //MARK: Web service initialization
        self.initUserInfo()
        //MARK: Web service / API to fetch followers and following Count
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
          self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        //is_paid = 1, branch_id
        
       /* let is_paid = General.loadSaved("is_paid")
        var branch_id : String = String()
        if(is_paid == "1"){
            branch_id = ""
        }else{
            branch_id = General.loadSaved("branch_id")
        }*/
        //,"is_paid":is_paid,"branch_id":branch_id
        
        
        //MARK: Display user information
        let params1: [String: AnyObject] = ["user_id": userID, "token_id": token,"friend_id":friendID]
        otherUserProfile(params1){response in
            if(response){
                self.initLoginUserInfo()
                
                self.btnInfoOutlet.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
            }else{
                print("otherUserProfile response fail")
            }
        }
        
        
       
        
        self.imgInfoTap.image = UIImage(named: "img_selected-tab\(self.delObj.deviceName)")
        self.imgUpdateTap.image = UIImage(named: "img_selected-tab\(self.delObj.deviceName)")
        
        //MARK: Initially setup scrollview content size to device
        self.mainScrollview.contentSize = CGSizeMake(self.mainScrollview.frame.width,self.deviceHeight)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - Function
    
    func initUserInfo(){
        
        //name
        self.lblUserName.text = ""
        
        //address
        self.lblLocation.text = ""
        
        //country
        self.lblCountry.text = ""
        
        //status
        self.lblSection.text = ""
        
        
        //User profile
        self.imgUserPic.image = UIImage(named: "avatar_thumbnail.jpg")
        self.imgUserPic.layer.cornerRadius = self.imgUserPic.frame.size.width/2
        self.imgUserPic.clipsToBounds = true
        
        //Followers
        self.lblFollowersCount.text = "0"
        
        //Following
        self.lblFollowingCount.text = "0"
    }
    
    
    func initLoginUserInfo(){
        
        //name
        var firstname = otherUserInfo["user_fullname"] as? String
        if(firstname != ""){
            firstname = firstname?.capitalizedString
        }
        self.lblUserName.text = firstname
        
        //address
        var location = otherUserInfo["user_loc_city_state"] as? String
        if(location != ""){
            //location = location?.capitalizedString
        }
        self.lblLocation.text = location
        
        //country
        var country = otherUserInfo["user_loc_country"] as? String
        if(country != ""){
            country = country?.capitalizedString
        }
        self.lblCountry.text = country
        
        //status
        var status = otherUserInfo["user_branch"] as? String
        if(status != ""){
            status = status?.capitalizedString
        }
        self.lblSection.text = status
        
        //Following or not
        let is_follower = otherUserInfo["is_follower"] as? String
        if(is_follower == "1"){
                self.btnFollowOutlet.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
                self.btnFollowOutlet.setTitle("Following", forState: .Normal)
            isFollowing = true
        }else{
            let is_requested = otherUserInfo["is_requested"] as? String
            if(is_requested == "1"){
                self.btnFollowOutlet.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
                self.btnFollowOutlet.setTitle("Requested", forState: .Normal)
                isFollowing = false
            }else{
                self.btnFollowOutlet.backgroundColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
                self.btnFollowOutlet.setTitle("+ Follow", forState: .Normal)
                isFollowing = false
            }
            
        }
        
        //Flag
        let flag = otherUserInfo["abbrivation"] as? String
        if(flag != ""){
            self.imgFlag.hidden = false
            self.imgFlag.image = UIImage(named: "\(flag!).png")
        }
        
        
        //DogTag 
        var dogTag =  otherUserInfo["dogtag_batch"] as? String
        if(dogTag != ""){
            self.imgDogTags.image = UIImage(named: "\(dogTag!)\(self.delObj.deviceName)")
        }else{
            dogTag = "19"
             self.imgDogTags.image = UIImage(named: "img_dogtagBG\(self.delObj.deviceName)")
        }
        if(dogTag == "19"){
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
        
        
        //User profile
        let pic = otherUserInfo["user_profile_pic"] as? String
        let ur = NSURL(string: Urls.ProfilePic_Base_URL + pic!)
        self.imgUserPic.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "avatar_thumbnail.jpg"), options: SDWebImageOptions.RefreshCached)
        self.imgUserPic.layer.cornerRadius = self.imgUserPic.frame.size.width/2
        self.imgUserPic.clipsToBounds = true
        
        //Followers
        
        self.lblFollowersCount.text = otherUserInfo["follower_count"] as? String
        
        //Following
        self.lblFollowingCount.text = otherUserInfo["following_count"] as? String
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
        //MARK: Check if user has lock all fields
        if(isCompleteLock && !isFollowing){
            
            let lockImage = UIImageView()
            let bottomViewHeight = deviceHeight - (self.topView.frame.height)
            self.bottomView.frame.size.height = bottomViewHeight
            
            lockImage.frame = CGRectMake(0, 10 , 161, 135)
            lockImage.center.x = bottomView.center.x
            lockImage.center.y = bottomView.center.y/2.2
            
            lockImage.image = UIImage(named: "prof_lock")
            self.bottomView.addSubview(lockImage)
            self.bottomView.backgroundColor = UIColor.whiteColor()
            self.mainScrollview.contentSize = CGSizeMake(self.mainScrollview.frame.width,(self.topView.frame.origin.y + self.topView.frame.height) + bottomViewHeight)
        }else{
        var yPos : CGFloat = CGFloat()
        var outHeight : CGFloat = CGFloat()
        
        let count = self.profileDetails.count
        let leftFrameWidth = deviceWidth*0.4062
        let rightFrameWidth = deviceWidth*0.5937
        if(count>0){
            for ind in 0...count-1{
            print(ind)
            
            yPos = yPos + outHeight + 8
            // = (CGFloat(ind)*35)+8
            //print("**\(yPos)")
            
            let data = self.profileDetails[ind]
            var textOut : String = String()
            //var outHeight : CGFloat = CGFloat()
            print("data.lock:\(data.lock)")
               
                if(data.lock == "1"){
                    textOut = ""
                }else{
                    textOut = data.detail
                }
            
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
            leftLabel.text = data.name
            let labelTemp = data.detail
            if(labelTemp != ""){
               // labelTemp = labelTemp.firstCharacterUpperCase()
                labelTemp.capitalizedString
                
            }
                if(data.lock == "1"){
                     rightLabel.text = "Private"
                    rightLabel.font = UIFont(name: cust.FontNameItalic, size: cust.FontSizeText)
                }else{
                     rightLabel.text = labelTemp
                }
           
            
            
            
            
            bottomView.addSubview(leftLabel)
            bottomView.addSubview(rightLabel)
            
            
            // self.bottomView.addSubview(outView)
         }
        }
        self.bottomView.backgroundColor = UIColor.whiteColor()
        self.mainScrollview.contentSize = CGSizeMake(self.mainScrollview.frame.width,(self.topView.frame.origin.y + self.topView.frame.height) + yPos + 40)
        }
    }
    
    
    /**
     Dynamically creates User's post view
     */
    func createPostView(){
        removeControllsFromSubView()
        
        //MARK: Check if user has lock all fields
        if(isCompleteLock && !isFollowing){
            
            let lockImage = UIImageView()
            let bottomViewHeight = deviceHeight - (self.topView.frame.height)
            self.bottomView.frame.size.height = bottomViewHeight
            
            lockImage.frame = CGRectMake(0, 10 , 161, 135)
            lockImage.center.x = bottomView.center.x
            lockImage.center.y = bottomView.center.y/2.2
            
            lockImage.image = UIImage(named: "prof_lock")
            self.bottomView.addSubview(lockImage)
            self.bottomView.backgroundColor = UIColor.whiteColor()
            self.mainScrollview.contentSize = CGSizeMake(self.mainScrollview.frame.width,(self.topView.frame.origin.y + self.topView.frame.height) + bottomViewHeight)
        }else{
        
        var yPos : CGFloat = CGFloat()
        var firstHeight : CGFloat = CGFloat()
        var imageHeight : CGFloat = CGFloat()
        //var secondHeight : CGFloat = CGFloat()
        
        let count = self.postDetails.count
        if(count>0){
            
            //
            for ind in 0...count-1{
                print(ind)
                
                /**/
                //1
                yPos = yPos + firstHeight + 8 + imageHeight //+ 30
                var imageFlag : Bool = Bool()
                //2
                let data = self.postDetails[ind]
                var textOut : String = String()
                
                
                //3
                if(data.post_content != ""){
                    imageFlag = false
                    imageHeight = 20
                    textOut = data.post_content
                }else if(data.post_caption != ""){
                    imageFlag = true
                    imageHeight = UIScreen.mainScreen().bounds.width //((UIScreen.mainScreen().bounds.width*5)/8)
                    textOut = data.post_caption
                }else{
                    imageFlag = true
                    imageHeight = UIScreen.mainScreen().bounds.width //((UIScreen.mainScreen().bounds.width*5)/8)
                    textOut = ""
                }
                
                //Determine Height
                let getHeight = heightForView(textOut, font: UIFont(name: cust.FontName, size: cust.FontSizeText)!, width: deviceWidth-24)
                firstHeight = getHeight + 80
                
                /*if(getHeight<80){
                    firstHeight = 80
                }else{
                    firstHeight = getHeight
                    
                }*/
                
                //Remove previous view if any
                var mySubview:MyCustomView!
                if(mySubview != nil && !mySubview.view.hidden)
                {
                    mySubview.view.removeFromSuperview()
                }
                
                
                //Set frame to new view
                mySubview = MyCustomView(frame: CGRect(x:0,y:yPos, width:deviceWidth, height:firstHeight + imageHeight))
                mySubview.imgVideoIcon.hidden = true
                if(data.post_content != ""){
                    mySubview.lblContent.text = textOut
                    mySubview.titleLabel.hidden = true
                    mySubview.lblContent.hidden = false
                    mySubview.imgVideoIcon.hidden = true
                    
                    mySubview.imageBottomConstraint.active = false
                    
                    
                    mySubview.postCaptionHeight.active = true
                    mySubview.postCaptionHeight.constant = 0.0
                    //mySubview.blackView.hidden = true
                }else
                {
                    mySubview.postCaptionHeight.active = false
                    mySubview.imageBottomConstraint.active = true
                    
                    
                    mySubview.titleLabel.hidden = false
                    mySubview.lblContent.hidden = true
                    mySubview.titleLabel.text = textOut
                    if(data.video_thumb != ""){
                        mySubview.imgVideoIcon.hidden = false

                    }else{
                        mySubview.imgVideoIcon.hidden = true

                    }
                    
                    //mySubview.blackView.hidden = false
                } //"My custom title"
                
                //Check image is nil or not
                if(!imageFlag){
                    mySubview.myImage.hidden = true
                }else{
                    
                    var imgPostString = String()
                    var placeholderName = String()
                    if(data.video_thumb != ""){
                        imgPostString = data.video_thumb
                        mySubview.myImage.contentMode = UIViewContentMode.ScaleAspectFit
                        
                        placeholderName = "pick_video_icon"
                    }else{
                        imgPostString = data.photo_video
                        mySubview.myImage.contentMode = UIViewContentMode.ScaleAspectFill
                         placeholderName = "pick_camera_icon"
                    }
                    
                    
                    let ur = NSURL(string: Urls.POSTVideo_Base_URL + imgPostString)
                    mySubview.myImage.sd_setImageWithURL(ur, placeholderImage: UIImage(named: placeholderName), options: SDWebImageOptions.RefreshCached)
                    
                    mySubview.myImage.contentMode = UIViewContentMode.ScaleAspectFit
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
                mySubview.btnComment.addTarget(self, action: #selector(OtherUserProfileViewController.CommentButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                mySubview.backgroundColor = UIColor.purpleColor()
                
                mySubview.btnMoreOption.hidden = true
                
                self.bottomView.addSubview(mySubview)
               
                
            }
            self.bottomView.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 232/255, alpha: 1.0)
            let ht = firstHeight + imageHeight //CGFloat(secondHeight*CGFloat(count))
            
            
            //MARK: Show More button data
            var showMoreHeight : CGFloat = CGFloat()
            if(postDetails.count == max){
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
            btnShowMore.addTarget(self, action: #selector(OtherUserProfileViewController.btnShowMoreClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            if(postDetails.count == max){
                self.bottomView.addSubview(btnShowMore)
            }

            
            self.mainScrollview.contentSize = CGSizeMake(self.mainScrollview.frame.width,(self.topView.frame.origin.y + self.topView.frame.height) + yPos + ht + 20 + showMoreHeight)
        }else{
            print("Hurryyy...No post")
             self.mainScrollview.contentSize = CGSizeMake(self.mainScrollview.frame.width,self.mainScrollview.frame.height-topView.frame.size.height)
        }
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
    
    
    //3rd View Click
    @IBAction func btnFollowersClick(sender: AnyObject) {
        
        
        let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idFollowersViewController") as! FollowersViewController
        noti.friendID = friendID
        if(self.navigationController != nil){
            self.navigationController?.pushViewController(noti, animated: true)
        }else{
            self.presentViewController(noti, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnFollowingClick(sender: AnyObject) {
        let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idFollowingViewController") as! FollowingViewController
        noti.friendID = friendID
        if(self.navigationController != nil){
            self.navigationController?.pushViewController(noti, animated: true)
        }else{
            self.presentViewController(noti, animated: true, completion: nil)
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
        DataContainerSingleton.sharedDataContainer.postAuthor = otherUserInfo["user_id"] as? String
        
        //MARK: User info
        userinfoCotainerSingleton.userinfo.userID = otherUserInfo["user_id"] as? String
        userinfoCotainerSingleton.userinfo.country = otherUserInfo["user_loc_country"] as? String
        userinfoCotainerSingleton.userinfo.dogTag_batch = otherUserInfo["dogtag_batch"] as? String
        userinfoCotainerSingleton.userinfo.fullname = otherUserInfo["user_fullname"] as? String
        userinfoCotainerSingleton.userinfo.location = otherUserInfo["user_loc_city_state"] as? String
        userinfoCotainerSingleton.userinfo.profileurl = otherUserInfo["user_profile_pic"] as? String
        userinfoCotainerSingleton.userinfo.status = otherUserInfo["user_branch"] as? String
        userinfoCotainerSingleton.userinfo.abbrivation = otherUserInfo["abbrivation"] as? String
        
        if(self.navigationController != nil){
            self.navigationController?.pushViewController(postDTVC, animated: true)
        }else{
            self.presentViewController(postDTVC, animated: true, completion: nil)
        }
        
    }
    

    /**
     Show More posts
     
     - parameter sender: show more buttin
     */
    @IBAction func btnShowMoreClick(sender: AnyObject){
        print("Show more click")
        let showVC = self.storyboard?.instantiateViewControllerWithIdentifier("navShowMore") as! UINavigationController
         self.delObj.carryUserID = friendID
        
        userDetailsSingleton.userDT.userID = otherUserInfo["user_id"] as? String
        userDetailsSingleton.userDT.country = otherUserInfo["user_loc_country"] as? String
        userDetailsSingleton.userDT.dogTag_batch = otherUserInfo["dogtag_batch"] as? String
        userDetailsSingleton.userDT.fullname = otherUserInfo["user_fullname"] as? String
        userDetailsSingleton.userDT.location = otherUserInfo["user_loc_city_state"] as? String
        userDetailsSingleton.userDT.profileurl = otherUserInfo["user_profile_pic"] as? String
        userDetailsSingleton.userDT.status = otherUserInfo["user_branch"] as? String
        userDetailsSingleton.userDT.abbrivation = otherUserInfo["abbrivation"] as? String
        
        self.presentViewController(showVC, animated: true, completion: nil)
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
            let userID = self.friendID//General.loadSaved("user_id")
           // let token = General.loadSaved("user_token")
            let postId = String(sender.tag)
            let params: [String: AnyObject] = ["userid": userID, "post_id":postId ]
            
            for ind in 0...self.postDetails.count-1{
                let data = self.postDetails[ind]
                if(data.post_id == postId){
                    if(data.is_like == "0"){
                        self.likePost(params){ response in
                            print("likePost:\(response)")
                            if(response){
                                print(" true")
                                let tmpCount = Int(data.like_count)
                               // tmpCount = tmpCount! + 1
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
                                //tmpCount = tmpCount! - 1
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
    
//TOOD: - Web service / API implementation
    
    /**
     Web service call to all information related to login user
     */
    func loadProfileDetails() {
        let userID = friendID//General.loadSaved("user_id")
        //let userToken = General.loadSaved("user_token")
        
        self.cust.showLoadingCircle()
        
        Alamofire.request(.POST, Urls.PROFILE_VIEW, parameters: ["user_id":userID])
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        self.profileDetails.removeAll()
                        self.cust.hideLoadingCircle()
                        
                        let json = JSON(value)
                        print("loadProfileDetails profile:\(json)")
                        if let value:String = json[0]["user_fullname"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Name", detail: value, lock: "0")!)
                        }
                        
                        if let value:String = json[0]["user_ispublic"].stringValue {
                            if(value == "1"){
                                self.isCompleteLock = true
                            }else{
                                self.isCompleteLock = false
                            }
                        }
                        
                        
                        
                        /* if let user_email = json[0]["user_email"].string {
                         self.profileDetails.append(ProfileValueModel(name: "Email Address", detail: user_email, lock: "0")!)
                         }*/
                        if let user_type:String = json[0]["user_type"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "User type", detail: user_type, lock: json[0]["type_islocked"].string!)!)
                        }
                        if let data:String = json[0]["user_service_status"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Service status", detail: data, lock: "0")!)
                        }
                        
                        if let data:String = json[0]["user_ht_country"].stringValue {
                            
                            var city = ""
                            var state = ""
                            
                            if let data2:String = json[0]["user_ht_state"].stringValue {
                                state = data2 + "\n"
                                
                                if let data3:String = json[0]["user_ht_city"].stringValue {
                                    city = data3 + ", "
                                }
                            }
                            
                            self.profileDetails.append(ProfileValueModel(name: "Hometown", detail: city + state + data, lock: json[0]["ht_country_islocked"].stringValue)!)
                        }
                        
                        
                        if let data:String = json[0]["user_loc_country"].stringValue {
                            
                            var city = ""
                            var state = ""
                            
                            if let data2:String = json[0]["user_loc_state"].stringValue {
                                state = data2 + "\n"
                                
                                if let data3:String = json[0]["user_loc_city"].stringValue {
                                    city = data3 + ", "
                                }
                            }
                            
                            self.profileDetails.append(ProfileValueModel(name: "Current Location", detail: city + state + data, lock: json[0]["loc_country_islocked"].stringValue)!)
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
                        
                        /*if let data:String = json[0]["user_military_base"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Military base", detail: data, lock: json[0]["military_base_islocked"].stringValue)!)
                        }*/
                        
                        
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
                        
                        
                        if let data:String = json[0]["user_paygrade"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Paygrade", detail: data, lock: json[0]["paygrade_islocked"].stringValue)!)
                        }
                        
                        if let data:String = json[0]["user_rank"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Rank", detail: data, lock: json[0]["rank_islocked"].stringValue)!)
                        }
                        
                        if let data:String = json[0]["user_job"].stringValue {
                            self.profileDetails.append(ProfileValueModel(name: "Job", detail: data, lock: json[0]["job_islocked"].stringValue)!)
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
        let userID = friendID//General.loadSaved("user_id")
        self.cust.showLoadingCircle()
        let maxi = String(max)
        Alamofire.request(.POST, Urls_UI.MY_POST_LIST_INDEX, parameters: ["userid":userID,"index":"0","max":maxi])
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        self.postDetails.removeAll()
                        self.cust.hideLoadingCircle()
                        
                        
                        let json = JSON(value)
                        print("json for fetch MyPosts:\(json)")
                        
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
                                
                                self.postDetails.append(MyPostValueModel(post_date: post_date, post_type: post_type, post_content: post_content, video_thumb: video_thumb, photo_video: photo_video, post_caption: post_caption,like_count:like_count,comment_count: comment_count,is_like: is_like,post_id:post_id )!)
                                
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
                                        let likeCount = json["like_count"].stringValue
                                        if(self.postDetails.count>0){
                                            for ind in 0...self.postDetails.count-1{
                                                let data = self.postDetails[ind]
                                                print("post_id 2:\(post_id)")
                                                if(data.post_id == post_id){
                                                    data.is_like = "1"
                                                    data.like_count = likeCount
                                                   /* var tmpLikeCt = Int(data.like_count)
                                                    tmpLikeCt = tmpLikeCt! + 1
                                                    data.like_count = String(tmpLikeCt!)*/
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
                                        let likeCount = json["like_count"].stringValue
                                        if(self.postDetails.count>0){
                                            for ind in 0...self.postDetails.count-1{
                                                let data = self.postDetails[ind]
                                                print("post_id 2:\(post_id)")
                                                if(data.post_id == post_id){
                                                    data.is_like = "0"
                                                    var tmpLikeCt = Int(data.like_count)
                                                    tmpLikeCt = tmpLikeCt! - 1
                                                    data.like_count = likeCount
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
        Other user's profile
     
     - parameter params: userid, friend_id, token
     */
    
    func otherUserProfile(params: [String: AnyObject], completion : (Bool) -> ()) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.OTHER_USER_PROFILE, multipartFormData: {
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
                                
                                print("otherUserProfile JSON: \(json)")
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        if(json["message"].stringValue.containsString("You are not allow to access this profile")){
                                            
                                            //*
                                            
                                            let uid = General.loadSaved("user_id")
                                            Mixpanel.mainInstance().identify(distinctId: uid)
                                            Mixpanel.mainInstance().track(event: "User prompted to Upgrade",
                                                properties: ["User prompted to Upgrade" : "User prompted to Upgrade"])
 
                                            
                                            let premAlert = UIAlertController(title: "DogTags", message: self.delObj.notPremiumMessage, preferredStyle: UIAlertControllerStyle.Alert)
                                            premAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                                                //
                                                //Display message and return back user
                                                
                                                if(self.navigationController != nil){
                                                    self.navigationController?.popViewControllerAnimated(true)
                                                }else{
                                                    self.dismissViewControllerAnimated(true, completion: nil)
                                                }
                                            }))
                                            premAlert.addAction(UIAlertAction(title: "Purchase", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                                                //
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navUpgrade") as! UINavigationController
                                                self.presentViewController(noti, animated: true, completion: nil)
                                            }))
                                            
                                            self.presentViewController(premAlert, animated: true, completion: nil)

                                            //*
                                            
                                            
                                        }else{
                                            
                                            GeneralUI_UI.alert(json["message"].stringValue)
                                        }
                                        
                                        completion(false)
                                    } else {
                                        print("You are in successful block")
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                       
                                        let count = json["data"].array?.count
                                        print("111:\(count)")
                                        
                                        if(count>0){
                                            
                                            for ind in 0...count!-1{
                                                self.otherUserInfo["user_branch"] = json["data"][ind]["user_branch"].stringValue
                                                
                                                self.otherUserInfo["user_profile_pic"] = json["data"][ind]["user_profile_pic"].stringValue
                                                
                                                self.otherUserInfo["following_count"] = json["data"][ind]["following_count"].stringValue
                                                
                                                self.otherUserInfo["follower_count"] = json["data"][ind]["follower_count"].stringValue
                                                
                                                self.otherUserInfo["user_loc_country"] = json["data"][ind]["user_loc_country"].stringValue
                                                
                                                self.otherUserInfo["user_loc_city_state"] =
                                                    json["data"][ind]["user_loc_city"].stringValue + ", " +
                                                    json["data"][ind]["user_loc_state_abbr"].stringValue
                                                //user_loc_state
                                                self.otherUserInfo["user_fullname"] = json["data"][ind]["user_fullname"].stringValue
                                                
                                                 self.otherUserInfo["is_follower"] = json["data"][ind]["is_follower"].stringValue
                                                
                                                self.otherUserInfo["dogtag_batch"] = json["data"][ind]["dogtag_batch"].stringValue
                                                self.otherUserInfo["abbrivation"] = json["data"][ind]["user_loc_abbreviation"].stringValue
                                                self.otherUserInfo["is_requested"] = json["data"][ind]["is_requested"].stringValue
                                                
                                                self.otherUserInfo["user_id"] = json["data"][ind]["user_id"].stringValue
                                            }
                                           
                                        }
                                        
                                        
                                        print("otherUserInfo:\(self.otherUserInfo)")
                                        completion(true)
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                            self.cust.hideLoadingCircle()
                            completion(false)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    completion(false)
                    self.cust.hideLoadingCircle()
                    print(encodingError)
                }
        })
    }
    
    
    func followUser(follower: String, button: UIButton) {
        
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        //let is_paid = General.loadSaved("is_paid")
        //var branch_id : String = String()
        
       /* if(is_paid == "1"){
            branch_id = ""
        }else{
            branch_id = General.loadSaved("branch_id")
        }*/
        //,"is_paid":is_paid,"branch_id":branch_id
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
                        self.btnFollowOutlet.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
                        self.btnFollowOutlet.setTitle("Requested", forState: .Normal)
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    self.cust.hideLoadingCircle()
                    print(error)
                }
        }
    }
    
    
    func unfollowFollowingUser(follower: String, button: UIButton) {
        
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        self.cust.showLoadingCircle()
        Alamofire.request(.POST, Urls.UNFOLLOW_USER, parameters: ["user_id": userID, "token_id": token, "follow_id": follower])
            .responseJSON { response in
                
                self.removeAllOverlays()
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(json)
                        if let status:String = json["status"].stringValue {
                            if status != "0" {
                                GeneralUI_UI.alert(json["message"].stringValue)
                            } else {
                                print("You are in successful block")
                               self.otherUserInfo["is_follower"] = "0"
                               
                                self.btnFollowOutlet.backgroundColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
                                self.btnFollowOutlet.setTitle("+ Follow", forState: .Normal)
                            }
                        }

                        
                        
                        
                        
                        self.cust.hideLoadingCircle()
                        GeneralUI.alert(json["message"].stringValue)
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    self.cust.hideLoadingCircle()
                    print(error)
                }
        }

    }


    
    
//TODO: UIButton Action
    
    @IBAction func btnFollowClick(sender: UIButton) {
        
        let veriStatus = General.loadSaved("verification_pending")
        
        if(veriStatus == "1"){
            //MARK: Account is approved
            let is_follower = otherUserInfo["is_follower"] as? String
            if(is_follower == "1"){
                //Unfollow Service
                self.unfollowFollowingUser(String(friendID), button: sender)
                //GeneralUI.alert("You are already following")
            }else{
                self.followUser(String(friendID), button: sender)
            }
        }else{
            //MARK: Account is approved
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
    

}
