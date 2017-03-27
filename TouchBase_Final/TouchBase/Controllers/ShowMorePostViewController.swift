//
//  ShowMorePostViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 12/12/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ShowMorePostViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let postFont = UIFont(name: "Swiss721BT-Light", size: 14)
    var postDetails = [MyPostValueModel]()
    var CallToWS : Bool = Bool()
    var stopHere : Bool = Bool()
    let min = "6"
    //TODO: - Controls
    @IBOutlet weak var lblNoPost: UILabel!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    
    //TODO: - Let's Code
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        self.tblMain.tableFooterView = UIView()
        
        self.tblMain.rowHeight = UITableViewAutomaticDimension
        self.tblMain.estimatedRowHeight = 150
        
        //MARK: Web service / API to fetch followers request
        
        //Index
        var tmpIndex : String = String()
        if(self.postDetails.count>0){
            tmpIndex = String(self.postDetails.count + Int(min)!)
        }else{
            tmpIndex = min
        }
        
        let params: [String: AnyObject] = ["userid": self.delObj.carryUserID, "index": tmpIndex,"max":"10" ]
        self.postDetails.removeAll()
        
        fetMyPosts(params)
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        initialization()
        
        //MARK: Delegation
        if(self.delObj.isSomeThingEdited){
            let carryPostID = self.delObj.carryPostID
            let ct = postDetails.count
            if(ct>0){
                for pos in 0...ct-1{
                    let postdt = postDetails[pos]
                    if(carryPostID == postdt.post_id){
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
    
    
//TODO: Function
    
    func initialization(){
        
        //Back
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
    }

    
    
//TODO: - UITableVIewDataSource method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postDetails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! HomeTableViewCell
        
        cell.selectionStyle = .None
        
        //MARK: Check for more option
       
        let loginUID = General.loadSaved("user_id")
        
        if loginUID != self.delObj.carryUserID{
             cell.btnMoreWidthConstraint.active = false
            cell.btnOption.hidden = true
        }
        
        
        let data = postDetails[indexPath.row]
        
        //MARK: - POST data
        cell.btnLikes.setTitle("\(data.like_count) Likes", forState: UIControlState.Normal)
        cell.btnComment.setTitle("\(data.comment_count) Comment", forState: UIControlState.Normal)
        
        cell.lblPost.hidden = true
        
        //MARK: Convert date
        let tmmpDate = General.convertDateToUserTimezone(data.post_date)
        print("tmmpDate:\(tmmpDate)")
        
        cell.lblPostDate.text = tmmpDate //data.post_date
        if(data.post_content != ""){
            
            //Remove space for caption
            cell.postTopConstraint.active = true
            cell.postTopConstraint.constant = 8
            cell.lblPost.text = data.post_content
            //cell.topConstraint.active = true
            cell.imgPost.hidden = true
            cell.imgVidThumb.hidden = true
            cell.imgPost.frame.size.height = 0.0
            cell.bottomConstraint.active = false
            
            cell.lblPost.hidden = false
            cell.lblCaption.hidden = true
            
            cell.imgPost.updateConstraints()
            
            self.view.layoutIfNeeded()
            
        }else{
             cell.postTopConstraint.active = false
          //  cell.topConstraint.active = false
            cell.imgPost.hidden = false
            cell.bottomConstraint.active = true
            //Uncomment to generate Thumbnail
            
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
        
        
        if(data.is_like == "0"){
            //previosuly not like, now go and Like post
            cell.btnLikes.tag = Int(data.post_id)!
            cell.btnLikes.addTarget(self, action: #selector(HomeTabViewController.btnLikePostClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.btnLikes.setImage(UIImage(named: "img_star\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            
        }else{
            //previously like post now go and Unlikes or never like
            cell.btnLikes.setImage(UIImage(named: "star-selected\(self.delObj.deviceName)"), forState: UIControlState.Normal)
            cell.btnLikes.tag = Int(data.post_id)!
            cell.btnLikes.addTarget(self, action: #selector(ShowMorePostViewController.btnLikePostClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(ShowMorePostViewController.cellMoreOptionClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.btnComment.tag = indexPath.row
        cell.btnComment.addTarget(self, action: #selector(ShowMorePostViewController.CommentButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell
    }
    
    //Detect last cell
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastSectionIndex : NSInteger = tblMain.numberOfSections - 1
        let lastRowIndex : NSInteger = tblMain.numberOfRowsInSection(lastSectionIndex) - 1
        print("\(postDetails.count) last cell")
        if(lastRowIndex > 4 ){
            if (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex) && !stopHere{
                print("You are at last cell")
                
                //Activity Indicator
                
                let spinner : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                spinner.frame = CGRectMake(0, 0, 44, 44)
                spinner.startAnimating()
                self.tblMain.tableFooterView = spinner
                
                //MARK: Web service / API to fetch followers request
                
                //Index
                var tmpIndex : String = String()
                if(self.postDetails.count>0){
                    tmpIndex = String(self.postDetails.count + Int(min)!)
                }else{
                    self.postDetails.removeAll()
                    tmpIndex = min
                }
                
                let params: [String: AnyObject] = ["userid": self.delObj.carryUserID, "index": tmpIndex,"max":"10" ]
                fetMyPosts(params)
                
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.navigateToDetailView(indexPath.row)
    }
    
    
    func navigateToDetailView(indx : Int){
        let postDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPostDetailContainerViewController") as! PostDetailContainerViewController
        let index = indx //sender.tag
        let data = self.postDetails[index]
        DataContainerSingleton.sharedDataContainer.postID = data.post_id
        DataContainerSingleton.sharedDataContainer.postContent = data.post_content
        DataContainerSingleton.sharedDataContainer.postCommentCount = data.comment_count
        DataContainerSingleton.sharedDataContainer.postImage = data.photo_video
        DataContainerSingleton.sharedDataContainer.postLikeCount = data.like_count
        DataContainerSingleton.sharedDataContainer.isPostLike = data.is_like
        DataContainerSingleton.sharedDataContainer.postCaption = data.post_caption
        DataContainerSingleton.sharedDataContainer.video_thumb = data.video_thumb
        let uid = General.loadSaved("user_id")
        DataContainerSingleton.sharedDataContainer.postAuthor = uid
        DataContainerSingleton.sharedDataContainer.postDate = data.post_date
        self.delObj.carryPostID = data.post_id
        
        userinfoCotainerSingleton.userinfo.fullname = userDetailsSingleton.userDT.fullname
        userinfoCotainerSingleton.userinfo.country = userDetailsSingleton.userDT.country
        userinfoCotainerSingleton.userinfo.location = userDetailsSingleton.userDT.location
        userinfoCotainerSingleton.userinfo.status = userDetailsSingleton.userDT.status
        userinfoCotainerSingleton.userinfo.dogTag_batch = userDetailsSingleton.userDT.dogTag_batch
        userinfoCotainerSingleton.userinfo.abbrivation = userDetailsSingleton.userDT.abbrivation
        userinfoCotainerSingleton.userinfo.profileurl = userDetailsSingleton.userDT.profileurl
        
        
        
        self.navigationController?.pushViewController(postDTVC, animated: true)
    }
//TODO: UIButton Action.
    
   
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**
     Button for 3 dot's
     
     - parameter sender: cell button
     */
    @IBAction func cellMoreOptionClick(sender:UIButton){
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
  
    /**
     Comment button is click
     
     - parameter sender: cell Comment
     */
   @IBAction func CommentButtonClick(sender:AnyObject){
        self.navigateToDetailView(sender.tag)
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
    
//TODO: Web service / API implementation
    
    /**
     Web service call to all information related to login user
     */
    func fetMyPosts(params: [String: AnyObject]) {
        if !CallToWS{
            
            if(self.postDetails.count==0){
                self.cust.showLoadingCircle()
            }
            self.CallToWS = true
            print("fetMyPosts params:\(params)")
            
            Alamofire.request(.POST, Urls_UI.MY_POST_LIST_INDEX, parameters: params)
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                       self.cust.hideLoadingCircle()
                        
                        
                        let json = JSON(value)
                        print("json for fetMyPosts:\(json)")
                        
                        let count = json["data"].array?.count
                        if(count>0){
                             self.stopHere = false
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
                        }else{
                            self.stopHere = true
                        }
                        self.CallToWS = false
                        self.tblMain.tableFooterView = nil
                        self.tblMain.reloadData()
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    self.CallToWS = false
                    self.tblMain.tableFooterView = nil
                    self.cust.hideLoadingCircle()
                    print(error)
                }
        }
            
        }else{
            print("We are still waiting for response")
        }
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
                                        //Remove that complete record from model
                                        
                                        if(self.postDetails.count>0){
                                            for ind in 0...self.postDetails.count-1{
                                                let data = self.postDetails[ind]
                                                print("post_id 2:\(post_id)")
                                                if(data.post_id == post_id){
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
                                                if(self.delObj.carryPostID == postdt.post_id){
                                                    postdt.like_count = like_count
                                                    postdt.comment_count = comment_count
                                                    postdt.is_like = is_like
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


    
    

}
