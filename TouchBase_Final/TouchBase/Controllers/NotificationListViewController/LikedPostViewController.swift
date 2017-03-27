//
//  LikedPostViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 04/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LikedPostViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
     var postDetails = [PostValueModel]()
    
    
    //var displayNameArray : [String] = []
    //var post_typeArray : [String] = []
//TODO: - Controls
    
    @IBOutlet weak var lblNoLike: UILabel!
    
    @IBOutlet weak var tblMain: UITableView!
//TODO: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tblMain.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //MARK: - Web service call to read pending notification
        
        
        // 1. Read Like Notification API Call
        let user_id = General.loadSaved("user_id")
       // let token_id = General.loadSaved("user_token")
        let params: [String: AnyObject] = ["userid": user_id]
        doReadMyLikeNotification(params)
       
        
        //MARK: Web service to fetch list of likes
        let listParam: [String: AnyObject] = ["userid": user_id]
        fetchLikeUserList(listParam)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - UITableViewDatasource method implementation
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postDetails.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! PostNotificationTableViewCell
        let data = postDetails[indexPath.row]
        

        
        let username = data.user_fullname
        let attributedString = NSMutableAttributedString(string:"\(username)")
        attributedString.addAttributes([NSFontAttributeName : UIFont(name: cust.FontName, size: cust.FontSizeAttri)!], range: NSMakeRange(0, username.characters.count))
        attributedString.addAttributes([NSForegroundColorAttributeName:cust.themeButtonBackgroundColor], range: NSMakeRange(0, username.characters.count))
        
        var postType : String = String()
        var postPic : String = String()
        
        if(data.post_content != ""){
            postType = "Status"
            postPic = ""
        }else if(data.video_thumb != ""){
            postType = "Video"
            postPic = data.video_thumb
        }else{
            postType = "Photo"
            postPic = data.photo_video
        }
        
        let secondText = " Likes your \(postType)."
        let secondString = NSMutableAttributedString(string:"\(secondText)")
        secondString.addAttributes([NSFontAttributeName : UIFont(name: cust.FontName, size: cust.FontSizeText)!], range: NSMakeRange(0, secondText.characters.count))
        
        attributedString.appendAttributedString(secondString)
        
        cell.lblTitle.attributedText = attributedString
        
        cell.btnPost.setTitle("", forState: .Normal)
        cell.btnUser.setTitle("", forState: .Normal)
        cell.imgUser.image = nil
        cell.imgPost.image = nil
        //MARK: Post Details
        if(postPic != ""){
        let postUr = NSURL(string: Urls.POSTVideo_Base_URL + postPic)
            //cell.btnPost.hnk_setImageFromURL(postUr!)
        cell.imgPost.sd_setImageWithURL(postUr, placeholderImage: UIImage(named: "pick_camera_icon"), options: SDWebImageOptions.RefreshCached)
        }else{
            cell.btnPost.setTitle("Status", forState: UIControlState.Normal)
        }
        
        cell.btnPost.tag = indexPath.row
        cell.btnPost.userInteractionEnabled = true
        cell.btnPost.addTarget(self, action: #selector(LikedPostViewController.btnPostDetailClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        //MARK: Profile Details
        let pic = data.user_profile_pic
        let ur = NSURL(string: Urls.ProfilePic_Base_URL + pic)
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width/2
        cell.imgUser.clipsToBounds = true
         cell.imgUser.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "avatar_thumbnail.jpg"), options: SDWebImageOptions.RefreshCached)
        
        cell.btnUser.tag = indexPath.row
        cell.btnUser.userInteractionEnabled = true
        cell.btnUser.addTarget(self, action: #selector(LikedPostViewController.btnOtherUserProfileClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell
    }
    
    
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
        
        //MARK: User info
        userinfoCotainerSingleton.userinfo.userID = data.author
        userinfoCotainerSingleton.userinfo.country = user_dictonary["user_loc_country"] as? String
        userinfoCotainerSingleton.userinfo.dogTag_batch = user_dictonary["dogtag_batch"] as? String
        userinfoCotainerSingleton.userinfo.fullname = user_dictonary["user_fullname"] as? String
        userinfoCotainerSingleton.userinfo.location = user_dictonary["user_loc_city_state"] as? String
        userinfoCotainerSingleton.userinfo.profileurl = user_dictonary["user_profile_pic"] as? String
        userinfoCotainerSingleton.userinfo.status = user_dictonary["user_branch"] as? String
        userinfoCotainerSingleton.userinfo.abbrivation = user_dictonary["abbreviation"] as? String
        print(" data.abbreviation:\( data.abbreviation)")
        self.navigationController?.pushViewController(postDTVC, animated: true)
        
    }
    
    
//TODO: - UIButton Action
    
    @IBAction func btnPostDetailClick(sender:UIButton){
        let postDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPostDetailContainerViewController") as! PostDetailContainerViewController
        let index = sender.tag
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
        
        //MARK: User info
        userinfoCotainerSingleton.userinfo.userID = data.author
        userinfoCotainerSingleton.userinfo.country = user_dictonary["user_loc_country"] as? String
        userinfoCotainerSingleton.userinfo.dogTag_batch = user_dictonary["dogtag_batch"] as? String
        userinfoCotainerSingleton.userinfo.fullname = user_dictonary["user_fullname"] as? String
        userinfoCotainerSingleton.userinfo.location = user_dictonary["user_loc_city_state"] as? String
        userinfoCotainerSingleton.userinfo.profileurl = user_dictonary["user_profile_pic"] as? String
        userinfoCotainerSingleton.userinfo.status = user_dictonary["user_branch"] as? String
        userinfoCotainerSingleton.userinfo.abbrivation = user_dictonary["abbreviation"] as? String
        print(" data.abbreviation:\( data.abbreviation)")
        self.navigationController?.pushViewController(postDTVC, animated: true)
        
    }
    
    
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
    
    
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
//TODO: - Web service / API implementation
    
    
    /**
     Fetch like post notification
     
     - parameter params: userid
     */
    
    func fetchLikeUserList(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.FETCH_LIKE_NOTIFICATION, multipartFormData: {
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
                                
                                self.postDetails.removeAll()
                                
                                print("JSON: \(json)")
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        //GeneralUI_UI.alert(json["message"].stringValue)
                                        
                                        self.tblMain.hidden = true
                                        self.lblNoLike.text = "No Like Notification"
                                        self.lblNoLike.hidden = false
                                        
                                        
                                    } else {
                                        print("You are in successful block")
                                       
                                        let count = json["data"].count
                                        
                                        if(count>0){
                                            for ind in 0...count-1 {
                                                //in success
                                                print("index\(ind)")
                                                //user data
                                                let user_id = json["data"][ind]["like_user_id"].stringValue
                                                let user_fullname = json["data"][ind]["user_fullname"].stringValue
                                                let country = json["data"][ind]["user_loc_country"].stringValue
                                                let city = json["data"][ind]["user_loc_city"].stringValue
                                                let state = json["data"][ind]["user_loc_state_abbr"].stringValue //json["data"][ind]["user_ht_state_abbr"].stringValue
                                                let branch_name = json["data"][ind]["user_branch"].stringValue
                                                let user_profile_pic = json["data"][ind]["user_profile_pic"].stringValue
                                                let dog_tag = json["data"][ind]["dogtag_batch"].stringValue
                                                let abbreviation = json["data"][ind]["user_loc_abbreviation"].stringValue
                                                
                                                //post data
                                                let postid = json["data"][ind]["post_id"].stringValue
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
                                            self.tblMain.hidden = false
                                            self.tblMain.reloadData()
                                            
                                        }else{
                                            self.tblMain.hidden = true
                                            self.lblNoLike.text = "No Like Notification"
                                            self.lblNoLike.hidden = false
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
    
    
    func doReadMyLikeNotification(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.READ_LIKE_COUNT, multipartFormData: {
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
