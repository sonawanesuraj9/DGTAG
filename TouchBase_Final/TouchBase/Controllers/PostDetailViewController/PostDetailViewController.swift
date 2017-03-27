//
//  PostDetailViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 01/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
 import AVKit
import AVFoundation


class PostDetailViewController: UIViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let postFont = UIFont(name: "Swiss721BT-Light", size: 14)
    var is_textEdited : Bool = Bool()
    var postDetails = [PostValueModel]()
    var commentDetails = [CommentListValueModel]()
    let placeholderTextColor : UIColor = UIColor.lightGrayColor()
    var vidURL : String = String()
    var isCommentEdit : Bool = Bool()
    var editCommentID : String = String()
    var player : AVPlayer!
//TODO: - Controls
    
    @IBOutlet weak var tblMain: UITableView!
    
    //CommentView
    @IBOutlet weak var viewCommentBox: UIView!
    @IBOutlet weak var txtComment: UITextView!
    
    @IBOutlet weak var btnSendOutlet: UIButton!
    
    
//TODO: - Let's Code    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // let data = postDetails[1]
       // print("data carry:\(data)")
        // Do any additional setup after loading the view.
        
        //MARK: Fetch Comments for Post
        
        //MARK: Web service / API to unlike post
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let postId = DataContainerSingleton.sharedDataContainer.postID
        let params: [String: AnyObject] = ["userid": userID, "token_id": token,"post_id":postId! ]
        self.fetchCommentList(params)
        
        self.tblMain.rowHeight = UITableViewAutomaticDimension
         self.tblMain.estimatedRowHeight = 150
        
        //MARK: Notifcation implementation
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostDetailViewController.methodOfReceivedNotification(_:)), name:"PostReloadPostDetailScreen", object: nil)

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
        let postId = DataContainerSingleton.sharedDataContainer.postID
        let params: [String: AnyObject] = ["userid": userID, "token_id": token,"post_id":postId!]
        self.fetchCommentList(params)
        
       
        let paramsRead: [String: AnyObject] = ["userid": userID,"post_id":postId!]
        doReadMyCommentNotification(paramsRead)

    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.delObj.screenTag = 4
        initialization()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if(tblMain.contentSize.height > tblMain.frame.size.height){
            let offset : CGPoint = CGPointMake(0,tblMain.contentSize.height - tblMain.frame.size.height)
            self.tblMain.setContentOffset(offset, animated: false)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - Function
    func initialization(){
        self.txtComment.layer.cornerRadius = 5
        self.txtComment.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.txtComment.layer.borderWidth = 0.5
        initPlaceholderForTextView()
        self.btnSendOutlet.setImage(UIImage(named: "img_send-message\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    func initPlaceholderForTextView(){
        txtComment.text = "Write a comment..."
        txtComment.textColor = placeholderTextColor
        is_textEdited = false
        txtComment.autocorrectionType = .Yes
        txtComment.delegate = self
        
    }
    
    
    
//TODO: - UIButton Action
    
    @IBAction func btnMoreClick(sender:UIButton){
        print(sender.tag-1)
        let data = commentDetails[sender.tag-1]
        
        
        
        let cmt_user_id = data.cmt_user_id
        let userID = General.loadSaved("user_id")
        
        //let postAuthorId = DataContainerSingleton.sharedDataContainer.postAuthor
        let actionAlert = UIAlertController(title: "", message: "Perform action", preferredStyle: .ActionSheet)
        if(cmt_user_id == userID){
            //MARK: Login user is comment owner
           
             actionAlert.addAction(UIAlertAction(title: "Edit Comment", style: .Default, handler: { (value:UIAlertAction) in
            //Perform delete action here
            self.isCommentEdit = true
            self.txtComment.text = data.comment
            self.editCommentID = data.cmt_id
            self.txtComment.textColor = UIColor.blackColor()
            self.is_textEdited = true
        }))
             actionAlert.addAction(UIAlertAction(title: "Delete Comment", style: .Default, handler: { (value:UIAlertAction) in
            //Perform delete action here
            
            let userID = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            let commentID = data.cmt_id
            
            let params: [String: AnyObject] = ["userid": userID, "token_id": token,"comment_id":commentID ]
            print("params:\(params)")
            self.DeleteComment(params)
            
        }))
        }else{
            
            //MARK: Login user is post owner
            actionAlert.addAction(UIAlertAction(title: "Delete Comment", style: .Default, handler: { (value:UIAlertAction) in
                //Perform delete action here
                
                let userID = General.loadSaved("user_id")
                let token = General.loadSaved("user_token")
                let commentID = data.cmt_id
                
                let params: [String: AnyObject] = ["userid": userID, "token_id": token,"comment_id":commentID ]
                print("params:\(params)")
                self.DeleteComment(params)
                
            }))
        }
        
        
        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnSendClick(sender: AnyObject) {
        //MARK: Web service / API to unlike post
        if(is_textEdited){
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let postId = DataContainerSingleton.sharedDataContainer.postID
        let comment = self.cust.trimString(self.txtComment.text!)
            if(isCommentEdit){
                //MARK: IF user editing his/her own comment
                let params: [String: AnyObject] = ["comment_id":self.editCommentID, "comment": self.txtComment.text! ]
                print("params:\(params)")
                self.editComment(params)
            }else{
                let params: [String: AnyObject] = ["userid": userID, "token_id": token,"post_id":postId!,"comment":comment ]
                
                self.postNewComment(params)
            }
        
        }
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
            
            if(DataContainerSingleton.sharedDataContainer.isPostLike == "0"){
                 self.likePost(params)
            }else{
                self.unLikePost(params)
            }
            
            
        }
        
        
    }
    
    
//TODO: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == placeholderTextColor{
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            is_textEdited = true
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == txtComment{
            if textView.text.isEmpty{
                
                txtComment.text = "Write a comment..."
                txtComment.textColor = placeholderTextColor
                is_textEdited = false
            }
            
        }
    }

//TODO: - UITableViewDatasource Method implementation
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.commentDetails.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! PostDetailTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
           
            
            //MARK: UserDetails
            
            cell.lblName.text = userinfoCotainerSingleton.userinfo.fullname
            cell.lblCountry.text = userinfoCotainerSingleton.userinfo.country
            cell.lblLocation.text = userinfoCotainerSingleton.userinfo.location
            cell.lblSection.text = userinfoCotainerSingleton.userinfo.status
            
            
            //dogTag
            let dogTag = userinfoCotainerSingleton.userinfo.dogTag_batch
            if(dogTag == "19"){
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
            
            if(dogTag != "" && dogTag != nil){
                cell.imgDogTags.image = UIImage(named: "\(dogTag!)\(self.delObj.deviceName).png")
            }else{
                 cell.imgDogTags.image = UIImage(named: "img_dogtagBG\(self.delObj.deviceName)")
            }
            
            //flag
            let flag = userinfoCotainerSingleton.userinfo.abbrivation
            if(flag != "" && flag != nil){
                cell.imgFlag.image = UIImage(named: "\(flag!).png")
            }
            
            
            let pic = userinfoCotainerSingleton.userinfo.profileurl
            let picUR = NSURL(string: Urls.ProfilePic_Base_URL + pic!)
            cell.imgProfile.sd_setImageWithURL(picUR, placeholderImage: UIImage(named: "avatar_thumbnail.jpg"), options: SDWebImageOptions.RefreshCached)
                
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
            cell.imgProfile.clipsToBounds = true
           
            
            //MARK: Post Details
            
            let likeCount = DataContainerSingleton.sharedDataContainer.postLikeCount
            let commentCount = DataContainerSingleton.sharedDataContainer.postCommentCount
            let postID = DataContainerSingleton.sharedDataContainer.postID
            let postContent = DataContainerSingleton.sharedDataContainer.postContent
            let postCaption = DataContainerSingleton.sharedDataContainer.postCaption
            let postImage = DataContainerSingleton.sharedDataContainer.postImage
            let postIsLike = DataContainerSingleton.sharedDataContainer.isPostLike
            let postDate =  DataContainerSingleton.sharedDataContainer.postDate
            let videoThumb = DataContainerSingleton.sharedDataContainer.video_thumb
            
            self.vidURL = postImage!
             cell.imgVideoPlayIcon.hidden = true
            
            //MARK: Convert date
            let tmmpDate = General.convertDateToUserTimezone(postDate!)
            print("tmmpDate:\(tmmpDate)")
            
            cell.lblPostDate.text = tmmpDate //postDate
            
            if(postContent != ""){
                //MARK: Only status
                cell.imgVideoPlayIcon.hidden = true
                cell.imgPost.hidden = true
                cell.imgPost.frame.size.height = 0
                cell.bottomConstraint.active = false
                //cell.imgPost.removeFromSuperview()
                cell.txtPost.hidden = true
                cell.lblContent.text = postContent
                cell.lblContent.hidden = false
                //cell.txtPost.text = postContent
            }else if(postCaption != ""){
                //MARK: Image/video with caption
                cell.bottomConstraint.active = true
                if(videoThumb != ""){
                    //MARK: Video present
                    let ur = NSURL(string: Urls.POSTVideo_Base_URL + videoThumb!)
                    cell.imgPost.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "pick_video_icon"), options: SDWebImageOptions.RefreshCached)
                    
                    cell.imgVideoPlayIcon.hidden = false
                    //Add Action
                    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PostDetailViewController.imageTapped(_:)))
                    cell.imgPost.userInteractionEnabled = true
                    cell.imgPost.addGestureRecognizer(tapGestureRecognizer)
                    cell.imgPost.contentMode = UIViewContentMode.ScaleAspectFit
                    
                }else{
                    //MARK: video not present
                    cell.imgPost.hidden = false
                    cell.imgVideoPlayIcon.hidden = true
                    let ur = NSURL(string: Urls.POSTVideo_Base_URL + postImage!)
                    cell.imgPost.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "pick_camera_icon"), options: SDWebImageOptions.RefreshCached)
                    cell.imgPost.contentMode = UIViewContentMode.ScaleAspectFit
                }
                
                cell.txtPost.hidden = false
                cell.lblContent.hidden = true
                cell.txtPost.text = postCaption
            }else{
                //Only iamge or video available
                if(videoThumb != ""){
                    //MARK: Video present
                    cell.imgVideoPlayIcon.hidden = false
                    let ur = NSURL(string: Urls.POSTVideo_Base_URL + videoThumb!)
                    cell.imgPost.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "pick_video_icon"), options: SDWebImageOptions.RefreshCached)
                    
                    cell.imgPost.contentMode = UIViewContentMode.ScaleAspectFit
                    //Add Action
                    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PostDetailViewController.imageTapped(_:)))
                    cell.imgPost.userInteractionEnabled = true
                    cell.imgPost.addGestureRecognizer(tapGestureRecognizer)
                    
                }else{
                    //MARK: video not present
                    cell.imgPost.hidden = false
                    cell.imgVideoPlayIcon.hidden = true
                    let ur = NSURL(string: Urls.POSTVideo_Base_URL + postImage!)
                    cell.imgPost.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "pick_camera_icon"), options: SDWebImageOptions.RefreshCached)
                    cell.imgPost.contentMode = UIViewContentMode.ScaleAspectFit
                }
                
                cell.txtPost.hidden = true
                cell.lblContent.hidden = true
                print("You have only image or video")
            }
         
           
            //cell.imgPost.contentMode = UIViewContentMode.ScaleAspectFit
            
            if(postIsLike == "0"){
                //MARK: Post is liked
                cell.btnLikes.tag = Int(postID!)!
                cell.btnLikes.addTarget(self, action:#selector(PostDetailViewController.btnLikePostClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.btnLikes.setImage(UIImage(named: "img_star\(self.delObj.deviceName)"), forState: UIControlState.Normal)
                
            }else{
                //MARK: Post does not liked
                cell.btnLikes.tag = Int(postID!)!
                cell.btnLikes.addTarget(self, action: #selector(PostDetailViewController.btnLikePostClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.btnLikes.setImage(UIImage(named: "star-selected\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            }
            cell.btnLikes.setTitle("\(likeCount!) Likes", forState: UIControlState.Normal)
            cell.btnComments.setTitle("\(commentCount!) Comments", forState: UIControlState.Normal)
            
            return cell
        }else{
         let cell = tableView.dequeueReusableCellWithIdentifier("CellID1", forIndexPath: indexPath) as! CommentOnPostTableViewCell
             cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            //MARK: Comment Details
            let index = indexPath.row - 1
            let commentData = commentDetails[index]
            cell.lblOtherName.text = commentData.user_fullname
            cell.lblBranch.text = commentData.user_branch
            cell.lblCountry.text = commentData.user_country
            cell.lblLocation.text = commentData.user_city + ", " + commentData.user_state
            
            //FLAG
            let flag = commentData.abbrivation
            if(flag != "" ){
                cell.imgFlag.image = UIImage(named: "\(flag).png")
            }
            
            //DogTags
            var dogTag = commentData.dogtag_batch
            if(dogTag == "19"){
                cell.lblOtherName.textColor = UIColor.blackColor()
                cell.lblLocation.textColor = UIColor.blackColor()
                cell.lblCountry.textColor = UIColor.blackColor()
                cell.lblBranch.textColor = UIColor.blackColor()
            }else{
                cell.lblOtherName.textColor = UIColor.whiteColor()
                cell.lblLocation.textColor = UIColor.whiteColor()
                cell.lblCountry.textColor = UIColor.whiteColor()
                cell.lblBranch.textColor = UIColor.whiteColor()
            }
            
            if(dogTag != ""){
                cell.imgDogTag.image = UIImage(named: "\(dogTag)\(self.delObj.deviceName)")
            }else{
                dogTag = "19"
                cell.imgDogTag.image = UIImage(named: "\(dogTag)\(self.delObj.deviceName)")

            }
            
            //More option
            let moreopt = commentData.cmt_user_id
            let userID = General.loadSaved("user_id")
            let postAuthorId = DataContainerSingleton.sharedDataContainer.postAuthor
            if(moreopt == userID){
                cell.btnMore.hidden = false
            }else if(postAuthorId == userID){
                 cell.btnMore.hidden = false
            }else{
                cell.btnMore.hidden = true
                
                //IF posted user is same, then allow that to delete other user's comment
                /*if(userID == userinfoCotainerSingleton.userinfo.userID){
                    cell.btnMore.hidden = false
                }else{
                    cell.btnMore.hidden = true
                }*/
                
            }
            
            
            cell.lblComment.text = commentData.comment
            
            
            let pic = commentData.user_profile_pic
            let ur = NSURL(string: Urls.ProfilePic_Base_URL + pic)
            cell.imgOtherProfile.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "pick_camera_icon"), options: SDWebImageOptions.RefreshCached)
            cell.imgOtherProfile.layer.cornerRadius = cell.imgOtherProfile.frame.size.width/2
            cell.imgOtherProfile.clipsToBounds = true
            
            cell.btnMore.tag = indexPath.row
            cell.btnMore.addTarget(self, action: #selector(PostDetailViewController.btnMoreClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
    }
    
    func imageTapped(img: AnyObject)
    {
        // Your action
        print("vidURL:\(Urls.POSTVideo_Base_URL + vidURL)")
        self.displayVideoViewController( Urls.POSTVideo_Base_URL + vidURL)
        
    }
    
    func displayVideoViewController(vidURL:String){
        let videoURL = NSURL(string: vidURL)
        self.player = AVPlayer(URL: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
            playerViewController.player?.actionAtItemEnd
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(PostDetailViewController.playerItemDidReachEnd(_:)),
                                                             name: AVPlayerItemDidPlayToEndTimeNotification,
                                                             object: self.player.currentItem)
        }
    }
    
    
    func playerItemDidReachEnd(notification: NSNotification) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player.currentItem)
       // self.player.seekToTime(kCMTimeZero)
        // self.player.play()
    }
    
    
  /*  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
       // print("cell height changed to:\(self.delObj.dashCellHeight)")
        if(indexPath.row == 0){
            var outHeight : CGFloat =  CGFloat()
            let postCaption = DataContainerSingleton.sharedDataContainer.postCaption
            let postContent = DataContainerSingleton.sharedDataContainer.postContent
            let wid = self.tblMain.frame.width - 16
            var  txtOut : String = String()
            
            if(postContent != ""){
                txtOut = postContent!
                let height = heightForView(txtOut, font: postFont!, width: wid)
                outHeight = height + 180 //+ ((UIScreen.mainScreen().bounds.width*5)/8)
                
            }else if(postCaption != ""){
                txtOut = postCaption!
                let height = heightForView(txtOut, font: postFont!, width: wid)
                outHeight = ((UIScreen.mainScreen().bounds.width*5)/8) + 160 + height
            }else{
                //Only iamge or video available
                outHeight = ((UIScreen.mainScreen().bounds.width*5)/8) + 160
            }
            
            
            
            print("outHeight>> \(outHeight)")
            return outHeight
            
        }else{
            return self.delObj.commentCellHeight
        }
        
    }*/
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    
//TODO: Web Service / API implementation
    
    /**
     Unlike to previously like post
     
     - parameter params: userid, postid, token
     */
    
    func fetchCommentList(params: [String: AnyObject]) {
        
        //self.view.userInteractionEnabled = false
        print(params)
        
        let spinner : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.frame = CGRectMake(0, 0, 44, 44)
        spinner.startAnimating()
        self.tblMain.tableFooterView = spinner
        
        //self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.COMMENT_LIST, multipartFormData: {
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
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                print("JSON: \(json)")
                                self.tblMain.tableFooterView = nil
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                    } else {
                                        print("You are in successful block")
                                        let count = json["data"].array?.count
                                        self.commentDetails.removeAll()
                                        if(count>0){
                                            for ind in 0...count!-1{
                                                let cmt_user_id = json["data"][ind]["cmt_user_id"].stringValue
                                                let comment = json["data"][ind]["comment"].stringValue
                                                let cmt_date = json["data"][ind]["cmt_date"].stringValue
                                                let user_fullname = json["data"][ind]["user_fullname"].stringValue
                                                let user_profile_pic = json["data"][ind]["user_profile_pic"].stringValue
                                                
                                                let user_city = json["data"][ind]["city"].stringValue
                                                let user_state = json["data"][ind]["state_abbr"].stringValue
                                                let dogtag_batch = json["data"][ind]["dogtag_batch"].stringValue
                                                let cmt_id = json["data"][ind]["cmt_id"].stringValue
                                                let is_comment = json["data"][ind]["is_comment"].stringValue
                                                
                                                 let user_country = json["data"][ind]["country"].stringValue
                                                 let abbrivation = json["data"][ind]["abbreviation"].stringValue
                                                let branch_name = json["data"][ind]["branch_name"].stringValue
                                                
                                                self.commentDetails.append(CommentListValueModel(postID: DataContainerSingleton.sharedDataContainer.postID!, cmt_user_id: cmt_user_id, comment: comment, cmt_date: cmt_date, user_fullname: user_fullname, user_profile_pic: user_profile_pic,user_city: user_city,user_state: user_state,dogtag_batch: dogtag_batch,cmt_id: cmt_id,is_comment: is_comment,user_country: user_country,user_branch: branch_name,abbrivation: abbrivation)!)
                                            }
                                            DataContainerSingleton.sharedDataContainer.postCommentCount = String(count!)
                                            self.tblMain.reloadData()
                                            
                                            //MARK: Move tableview to last
                                            /*if(self.tblMain.contentSize.height > self.tblMain.frame.size.height){
                                                let offset : CGPoint = CGPointMake(0,self.tblMain.contentSize.height - self.tblMain.frame.size.height)
                                                self.tblMain.setContentOffset(offset, animated: false)
                                            }*/
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
    
    func postNewComment(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.ADD_NEW_COMMENT, multipartFormData: {
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
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                self.cust.hideLoadingCircle()
                                print("JSON: \(json)")
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                    } else {
                                        print("You are in successful block")
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                        let count = json["data"].array?.count
                                        
                                        if(count>0){
                                            for ind in 0...count!-1{
                                                let cmt_user_id = json["data"][ind]["cmt_user_id"].stringValue
                                                let comment = json["data"][ind]["comment"].stringValue
                                                let cmt_date = json["data"][ind]["cmt_date"].stringValue
                                                let user_fullname = json["data"][ind]["user_fullname"].stringValue
                                                let user_profile_pic = json["data"][ind]["user_profile_pic"].stringValue
                                                
                                                self.txtComment.text = ""
                                                
                                                
                                                let city = json["data"][ind]["city"].stringValue
                                                let state = json["data"][ind]["state_abbr"].stringValue
                                                let dogtag_batch = json["data"][ind]["dogtag_batch"].stringValue
                                                let cmt_id = json["data"][ind]["id"].stringValue
                                                let country = json["data"][ind]["country"].stringValue
                                                let branch_name = json["data"][ind]["branch_name"].stringValue
                                                let abbreviation = json["data"][ind]["abbreviation"].stringValue
                                                
                                                
                                                
                                                self.commentDetails.append(CommentListValueModel(postID: DataContainerSingleton.sharedDataContainer.postID!, cmt_user_id: cmt_user_id, comment: comment, cmt_date: cmt_date, user_fullname: user_fullname, user_profile_pic: user_profile_pic,user_city:city,user_state:state,dogtag_batch:dogtag_batch,cmt_id: cmt_id,is_comment:"1",user_country: country,user_branch:branch_name,abbrivation:abbreviation)!)
                                            }
                                           
                                        }
                                        let tmpCount = json["comment_count"].stringValue
                                        print("tmpCount:\(tmpCount)")
                                        
                                        //MARK: Delegation method
                                        self.delObj.isSomeThingEdited = true
                                        
                                        DataContainerSingleton.sharedDataContainer.postCommentCount = tmpCount
                                        self.txtComment.resignFirstResponder()
                                        self.tblMain.reloadData()
                                        //MARK: Move tableview to last
                                        if(self.tblMain.contentSize.height > self.tblMain.frame.size.height){
                                            let offset : CGPoint = CGPointMake(0,self.tblMain.contentSize.height - self.tblMain.frame.size.height)
                                            self.tblMain.setContentOffset(offset, animated: false)
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
     Edit to Comment
     
     - parameter params: commentID, updated message
     */
    
    func editComment(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.EDIT_COMMENT, multipartFormData: {
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
                        let comment_id : String =  (params["comment_id"] as? String)!
                        let comment : String =  (params["comment"] as? String)!
                        print("comment_id 1:\(comment_id)")
                        
                        self.view.userInteractionEnabled = true
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                self.cust.hideLoadingCircle()
                                print("JSON: \(json)")
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                    } else {
                                        print("You are in successful block")
                                        //GeneralUI_UI.alert(json["message"].stringValue)
                                        
                                        if(self.commentDetails.count>0){
                                            for ind in 0...self.commentDetails.count-1{
                                                let data = self.commentDetails[ind]
                                                print("comment_id 2:\(comment_id)")
                                                if(data.cmt_id == comment_id){
                                                   data.comment = comment
                                                    self.isCommentEdit = false
                                                    self.initPlaceholderForTextView()
                                                    break;
                                                }
                                            }//For ends
                                            //self.tblMain.reloadData()
                                        }
                                        
                                        self.txtComment.resignFirstResponder()
                                        self.tblMain.reloadData()
                                        //MARK: Move tableview to last
                                        /*if(self.tblMain.contentSize.height > self.tblMain.frame.size.height){
                                            let offset : CGPoint = CGPointMake(0,self.tblMain.contentSize.height - self.tblMain.frame.size.height)
                                            self.tblMain.setContentOffset(offset, animated: false)
                                        }*/
                                        
                                        
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
     Delete Comment will be here
     
     - parameter params: userid, CommentID, token
     */
    
    func DeleteComment(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        
        Alamofire.upload(.POST, Urls_UI.DELETE_MY_COMMENT, multipartFormData: {
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
                        let comment_id : String =  (params["comment_id"] as? String)!
                        print("comment_id 1:\(comment_id)")
                        
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
                                       
                                        let count = self.commentDetails.count
                                        if(count>0){
                                            for ind in 0...count-1{
                                                let data = self.commentDetails[ind]
                                                if(data.cmt_id == comment_id){
                                                    
                                                    //Reduce comment count by 1
                                                    //MARK: Delegation method
                                                    self.delObj.isSomeThingEdited = true
                                                    
                                                    self.commentDetails.removeAtIndex(ind)
                                                     DataContainerSingleton.sharedDataContainer.postCommentCount = String(self.commentDetails.count)
                                                    break
                                                }
                                            }
                                        }
                                        
                                        self.tblMain.reloadData()
                                        
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
     Like to specific post will be here
     
     - parameter params: userid, postid, token
     */
    
    func likePost(params: [String: AnyObject]) {
        
        //self.view.userInteractionEnabled = false
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
                                        
                                        let oldLikeCount = DataContainerSingleton.sharedDataContainer.postLikeCount
                                        let newLikeCount = Int(oldLikeCount!)! + 1
                                        DataContainerSingleton.sharedDataContainer.postLikeCount = String(newLikeCount)
                                        DataContainerSingleton.sharedDataContainer.isPostLike = "1"
                                        
                                        //MARK: Delegation method
                                        self.delObj.isSomeThingEdited = true
                                        
                                         self.tblMain.reloadData()
                                       
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
    
    func unLikePost(params: [String: AnyObject]) {
        
       // self.view.userInteractionEnabled = false
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
                                        let oldLikeCount = DataContainerSingleton.sharedDataContainer.postLikeCount
                                        let newLikeCount = Int(oldLikeCount!)! - 1
                                        DataContainerSingleton.sharedDataContainer.postLikeCount = String(newLikeCount)
                                         DataContainerSingleton.sharedDataContainer.isPostLike = "0"
                                        
                                        //MARK: Delegation method
                                        self.delObj.isSomeThingEdited = true
                                      
                                        self.tblMain.reloadData()
                                        
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
    
    
    func doReadMyCommentNotification(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.READ_EACH_COMMENT_COUNT, multipartFormData: {
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
                                
                                print("doReadMyCommentNotification JSON: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                       // GeneralUI_UI.alert(json["message"].string!)
                                    } else {
                                        print("You are in successful block")
                                        //GeneralUI_UI.alert(json["message"].string!)
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    self.view.userInteractionEnabled = true
                    print(encodingError)
                }
        })
    }
    
    
    
}
