//
//  MulitimediaPostContainerVC.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 31/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Alamofire
import SwiftyJSON
import SwiftOverlays

import AssetsLibrary
import TwitterKit
import Fabric
import Mixpanel

class MulitimediaPostContainerVC: UIViewController,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,FBSDKSharingDelegate,TOCropViewControllerDelegate {
    
    //TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
   
    private var imagePickerController: UIImagePickerController!
    var videoData : NSData = NSData()
    var videoURL : NSURL = NSURL()
    
    
    var facebookvideo : FBSDKShareVideo = FBSDKShareVideo()
    
    let MAX_VIDEO_DURATION = 30.0
    
    
    let placeholderTextColor : UIColor = UIColor.lightGrayColor()
    
    var is_videoUpload : Bool = Bool()
    var is_imageUpload : Bool = Bool()
    let imgPicker : UIImagePickerController = UIImagePickerController()
    let vidPicker : UIImagePickerController = UIImagePickerController()
    let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    let vidTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    
    var is_photoSelect : Bool = Bool()
    var postImage : UIImage = UIImage()
    var pick_videoPath : NSURL = NSURL()
    var is_textEdited : Bool = Bool()
    var is_orgVideoRemove : Bool = Bool()
    var orgWidth : CGFloat = CGFloat()
    
    var postID : String = String()
    //TODO: - Controls
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var btnDoneOutlet: UIButton!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var btnVideoOutlet: UIButton!
    @IBOutlet weak var btnPhotoOutlet: UIButton!
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var imgDogTag: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    
    @IBOutlet weak var imgVideoTrangle: UIImageView!
    @IBOutlet weak var imgPhotoTrangle: UIImageView!
    //Multimedia
    @IBOutlet weak var imgMultimedia: UIImageView!
    @IBOutlet weak var txtCaption: UITextView!
    @IBOutlet weak var imgVideo: UIImageView!
    
    //TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.imgMultimedia.userInteractionEnabled = true
        self.imgMultimedia.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(MulitimediaPostContainerVC.askToChangeImage))
        
        self.imgVideo.userInteractionEnabled = true
        self.imgVideo.addGestureRecognizer(vidTapGesture)
        vidTapGesture.addTarget(self, action: #selector(MulitimediaPostContainerVC.askToCaptureVideo))
        
        btnPhotoOutlet.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initialization()
        initPlaceholderForTextView()
        
        //MARK: - Display user info
        initLoginUserInfo()
        //is_photoSelect = true
        
        //MARK: user come across this step from edit post
        if(self.delObj.isPostEditEnable){
            initEditPost()
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        orgWidth = UIScreen.mainScreen().bounds.width/2 //self.btnFacebook.frame.size.width
        print("orgWidth:\(orgWidth)")
    }
    
    
    
    
    //TODO: - Function
    
    func initEditPost(){
        print("111 >> \(postContainerSingleton.postData.postCaption)")
        self.txtCaption.text = postContainerSingleton.postData.postCaption
        self.txtCaption.textColor = UIColor.blackColor()
        is_textEdited = true
        self.btnDoneOutlet.hidden = false
        let pic = postContainerSingleton.postData.postImage
        let vidThumb = postContainerSingleton.postData.vid_thumb
        
        if((pic != nil && pic != "" && !is_imageUpload) || (vidThumb != nil && vidThumb != "" && !is_videoUpload)){
            if(vidThumb != ""){
                let ur = NSURL(string: Urls.POSTVideo_Base_URL + vidThumb!)
                if(!self.is_orgVideoRemove){
                    self.imgVideo.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "pick_camera_icon"), options: SDWebImageOptions.RefreshCached)
                }
               
                self.imgVideo.contentMode = UIViewContentMode.ScaleAspectFit
                is_videoUpload = true
                //is_orgVideoRemove = false
                
                let fullVid = postContainerSingleton.postData.postImage
                let vidUrl = NSURL(string: Urls.POSTVideo_Base_URL + fullVid!)
                self.myVideo(vidUrl!)
                
                
                /*MARK: Display video tab*/
                
                self.btnPhotoOutlet.backgroundColor = cust.lightButtonBackgroundColor
                self.btnVideoOutlet.backgroundColor = cust.darkButtonBackgroundColor
                imgVideoTrangle.hidden = false
                imgPhotoTrangle.hidden = true
                
                //self.imgVideo.image = UIImage(named: "videoThumb.png")
                is_photoSelect = false
                self.imgMultimedia.hidden = true
                self.imgVideo.hidden = false
                
                
            }else{
                let ur = NSURL(string: Urls.POSTVideo_Base_URL + pic!)
                self.imgMultimedia.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "pick_camera_icon"), options: SDWebImageOptions.RefreshCached)
                self.imgMultimedia.contentMode = UIViewContentMode.ScaleAspectFit
                is_imageUpload = true
            }
           
            postID = postContainerSingleton.postData.postID!
        }else{
            //MARK: New image picked
            print("new image picked ")
        }
    }
    
    
    /**
     Placeholder text for UITextView is set
     
     - returns: nothing is return
     */
    func initPlaceholderForTextView(){
        if(self.delObj.isPostEditEnable){
            self.txtCaption.text = postContainerSingleton.postData.postCaption
        }else{
            txtCaption.text = "Caption will be here..."
        }
        txtCaption.autocorrectionType = .Yes
        txtCaption.textColor = placeholderTextColor
        is_textEdited = false
        self.btnDoneOutlet.hidden = true
        txtCaption.delegate = self
        self.txtCaption.layer.borderWidth = 0.5
        self.txtCaption.layer.borderColor = placeholderTextColor.CGColor
    }
    
    
    
    
    /**
     App Initiaziation
     
     - returns: returns nothing
     */
    func initialization(){
        self.imgProfile.image = UIImage(named: "profilepic.jpg")
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.size.height / 2
        self.imgProfile.clipsToBounds = true
        // self.imgProfile.contentMode = .ScaleAspectFill
        let timezone = NSTimeZone.localTimeZone()
        print("Hey,Timezone:\(timezone.name)")
        
        //Placeholder
        if(!is_imageUpload){
            self.imgMultimedia.image = UIImage(named: "pick_camera_icon")
            self.imgMultimedia.contentMode = UIViewContentMode.ScaleAspectFit
            
        }
        
        if(!is_videoUpload){
            self.imgVideo.image = UIImage(named: "pick_video_icon")
            self.imgVideo.contentMode = UIViewContentMode.ScaleAspectFit
        }else{
           
        }
       
        
        //Back
        self.btnBack.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        
        //Social
        self.btnFacebook.setImage(UIImage(named: "img_shareon-facebook\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        self.btnTwitter.setImage(UIImage(named: "img_shareon-twitter\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        self.btnPost.setImage(UIImage(named: "img_post-message\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        
        //Imgage
        self.imgPhotoTrangle.image = UIImage(named: "img_selected-tab\(self.delObj.deviceName)")
        self.imgVideoTrangle.image = UIImage(named: "img_selected-tab\(self.delObj.deviceName)")
        self.imgDogTag.image = UIImage(named: "img_dogtagBG\(self.delObj.deviceName)")
        
        
        
    }
    
    
    
    
    /**
     Action sheet to give choice for photo selection
     */
    func askToChangeImage(){
        is_photoSelect = true
        
        let alertImage = UIAlertController(title: "Let's get a picture", message: "Choose a picture upload method", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        self.imgPicker.delegate = self
        
        if(is_imageUpload){
            let removeImageButton = UIAlertAction(title: "Remove Picture", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
                self.is_imageUpload = false
                self.imgMultimedia.image = UIImage(named: "pick_camera_icon")
                self.imgMultimedia.contentMode = UIViewContentMode.ScaleAspectFit
                //change code here
                // self.imgMultimedia.image = self.delObj.userPlaceHolderImage
            }
            alertImage.addAction(removeImageButton)
        }else{
            print("No image is selected")
        }
        
        //Add AlertAction to select image from library
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
           self.imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.imgPicker.delegate = self
           
            //self.ShowFusma()
            // self.imgPicker.allowsEditing = true
            
            self.presentViewController(self.imgPicker, animated: true, completion: nil)
        }
        
        //Check if Camera is available, if YES then provide option to camera
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                
               self.imgPicker.dismissViewControllerAnimated(true, completion: nil)
                self.imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
                
               // self.imgPicker.allowsEditing = true
               // self.ShowFusma()
                self.presentViewController(self.imgPicker, animated: true, completion: nil)
            }
            alertImage.addAction(cameraButton)
        } else {
            print("Camera not available")
            
        }
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        alertImage.addAction(libButton)
        alertImage.addAction(cancelButton)
        self.presentViewController(alertImage, animated: true, completion: nil)
    }
    
    
    /**
     Action sheet to give choice for video selection
     */
    func askToCaptureVideo()
    {
        is_photoSelect = false
        let alert = UIAlertController(title: "Let's get a Video", message: "Choose a Video upload method", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        self.vidPicker.delegate = self
        
        if(is_videoUpload){
            let removeImageButton = UIAlertAction(title: "Remove Video", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
                self.is_videoUpload = false
                self.is_orgVideoRemove = true
                self.imgVideo.image = UIImage(named: "pick_video_icon")
                self.imgVideo.contentMode = UIViewContentMode.ScaleAspectFit
                
            }
            alert.addAction(removeImageButton)
        }else{
            print("No image is selected")
        }
        
        //Add AlertAction to select image from library
        let libButton = UIAlertAction(title: "Select Video from library", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("captureVideoPressed and photo library available.")
            
            //  var imagePicker = UIImagePickerController()
            
            self.vidPicker.delegate = self
            self.vidPicker.sourceType = .PhotoLibrary;
            self.vidPicker.mediaTypes = [kUTTypeMovie as String]
            self.vidPicker.allowsEditing = true
            //self.imgPicker.showsCameraControls = true
            //self.imgPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Video
            self.presentViewController(self.vidPicker, animated: true, completion: nil)
        }
        
        //Check if Camera is available, if YES then provide option to camera
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a Video", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                
                print("captureVideoPressed and camera available.")
                
                // let imagePicker = UIImagePickerController()
                
                self.vidPicker.delegate = self
                self.vidPicker.sourceType = .Camera;
                self.vidPicker.mediaTypes = [kUTTypeMovie as String]
                self.vidPicker.allowsEditing = true
                self.vidPicker.videoMaximumDuration = NSTimeInterval(self.MAX_VIDEO_DURATION)
                self.vidPicker.showsCameraControls = true
                
               /* let cameraMediaType = AVMediaTypeVideo
                let cameraAuthorizationStatus  = AVCaptureDevice.authorizationStatusForMediaType(cameraMediaType)
                print("cameraAuthorizationStatus:\(cameraAuthorizationStatus)")
                switch cameraAuthorizationStatus {
                case .Denied: break
                case .Authorized: break
                case .Restricted: break
                    
                case .NotDetermined:
                    // Prompting user for the permission to use the camera.
                    AVCaptureDevice.requestAccessForMediaType(cameraMediaType) { granted in
                        if granted {
                            print("Granted access to \(cameraMediaType)")
                        } else {
                            print("Denied access to \(cameraMediaType)")
                        }
                    }
                }*/
                
                
                self.presentViewController(self.vidPicker, animated: true, completion: nil)
            }
            alert.addAction(cameraButton)
        } else {
            print("Camera not available")
            
        }
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    func checkCameraPermission(){
        
    }
    
    /**
     Display user details
     
     - returns: Nothing to Return
     */
    
    func initLoginUserInfo(){
        //name
        self.lblUsername.text = user_dictonary["user_fullname"] as? String
        
        //address
        self.lblLocation.text = user_dictonary["user_loc_city_state"] as? String
        
        //country
        self.lblCountry.text = user_dictonary["user_loc_country"] as? String
        
        //status
        self.lblSection.text = user_dictonary["user_branch"] as? String
        
        self.btnDoneOutlet.setTitle("Ok", forState: UIControlState.Normal)
        
        //DogTag design
        var dogTagID = user_dictonary["dogtag_batch"] as? String
        if(dogTagID == ""){
            dogTagID = "19"
        }
        if(dogTagID == "19"){
            self.lblUsername.textColor = UIColor.blackColor()
            self.lblLocation.textColor = UIColor.blackColor()
            self.lblCountry.textColor = UIColor.blackColor()
            self.lblSection.textColor = UIColor.blackColor()
        }else{
            self.lblUsername.textColor = UIColor.whiteColor()
            self.lblLocation.textColor = UIColor.whiteColor()
            self.lblCountry.textColor = UIColor.whiteColor()
            self.lblSection.textColor = UIColor.whiteColor()
        }
        self.imgDogTag.image = UIImage(named: "\(dogTagID!)\(self.delObj.deviceName)")
        

        
        
        //User profile
        self.imgProfile.image = UIImage(named: "img_profile-pic-upload\(self.delObj.deviceName)")
        
        let pic = user_dictonary["user_profile_pic"] as? String
        let ur = NSURL(string: Urls.ProfilePic_Base_URL + pic!)
        self.imgProfile.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "avatar_thumbnail.jpg"), options: SDWebImageOptions.RefreshCached)
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        self.imgProfile.clipsToBounds = true
    }
    
    
    //TODO: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == placeholderTextColor{
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            is_textEdited = true
            self.btnDoneOutlet.hidden = false
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == txtCaption{
            if textView.text.isEmpty{
                txtCaption.text = "Caption will be here..."
                txtCaption.textColor = placeholderTextColor
                is_textEdited = false
                self.btnDoneOutlet.hidden = true
            }
            
        }
    }
    
    
    
//TODO: - UIImagePickerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if(self.is_photoSelect){
            //Image upload code
            
            let pickedImage : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            postImage = pickedImage
            
            
            let cropViewController : TOCropViewController = TOCropViewController(image: pickedImage)
            cropViewController.delegate = self
            cropViewController.imageCropFrame = CGRectMake(0, 0, pickedImage.size.width, pickedImage.size.width)
            cropViewController.aspectRatioLockEnabled = true
            cropViewController.resetAspectRatioEnabled = false
            
            
            cropViewController.rotateButtonsHidden = true
            cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPreset.PresetSquare
            picker.presentViewController(cropViewController, animated: true, completion: nil)
            
           // self.presentViewController(cropViewController, animated: true, completion: nil)
            
        }else{
            
            //Video section code
          //  print("URL:>>\(info[UIImagePickerControllerEditedImage])")
            vidPicker.videoQuality = .TypeLow
            self.videoURL = (info["UIImagePickerControllerMediaURL"] as? NSURL)!
            
           // let refURl = info[UIImagePickerControllerReferenceURL] as! NSURL
             self.facebookvideo.videoURL = (info["UIImagePickerControllerMediaURL"] as? NSURL)!
            
            /* *******************  new code */
            
            let library = ALAssetsLibrary()
            library.writeVideoAtPathToSavedPhotosAlbum(self.videoURL, completionBlock: { (URL:NSURL!, error:NSError!) in
                //
                let savedAssetURL = URL
                print("asset url \(savedAssetURL)")
                
                if error != nil {
                    print("asset url \(savedAssetURL)")
                }
                else {
                    print("asset url \(URL)")
                    self.facebookvideo.videoURL = URL
                    
                    self.myVideo(self.videoURL)
                    //check file size
                    
                    
                    //Convert to data
                    do {
                        let tvideoData = try NSData(contentsOfURL: self.videoURL, options: .DataReadingMappedIfSafe)
                        print("File size before compression: \(Double(tvideoData.length / 1048576)) mb")
                    } catch {
                        print(error)
                        return
                    }
                    self.is_videoUpload = true
                    //let videoUrl = info[UIImagePickerControllerMediaURL] as! NSURL!
                    let pathString = self.videoURL.relativePath
                    
                    
                    self.imgVideo.image = GeneralUI_UI.generateVideoThumbnail(pathString!)
                    print("PathString>> \(pathString)")
                    
                    /*Video select*/
                    self.btnPhotoOutlet.backgroundColor = self.cust.lightButtonBackgroundColor
                    self.btnVideoOutlet.backgroundColor = self.cust.darkButtonBackgroundColor
                    self.imgVideoTrangle.hidden = false
                    self.imgPhotoTrangle.hidden = true
                    
                    //self.imgVideo.image = UIImage(named: "videoThumb.png")
                    self.is_photoSelect = false
                    self.imgMultimedia.hidden = true
                    self.imgVideo.hidden = false
                    
                    
                }
            })
            
            dismissViewControllerAnimated(true, completion: nil)
            /* ******************** new code ends */

        }
        
    }
    
   
    
    func videSave(ss:AnyObject){
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        is_imageUpload = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func presentCropViewController(sourceImage:UIImage){
      
    }
    
    func cropViewController(cropViewController: TOCropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        print("image crop")
        self.dismissViewControllerAnimated(true, completion: nil)
        //self.imgMultimedia.image = image
        
        self.imgMultimedia.contentMode = UIViewContentMode.ScaleAspectFit
        self.imgMultimedia.image = image
        btnPhotoOutlet.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        is_imageUpload = true
    }
    
    func cropViewController(cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        dismissViewControllerAnimated(true, completion: nil)
    }
//TODO: - Web service / API implementation
    
    func addNewImagePost(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.showTextOverlay("Uploading")
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.CREATE_NEW_POST, multipartFormData: {
            multipartFormData in
            
            let filename = GeneralUI_UI.generateRandomImageName()
            if let imageData = UIImageJPEGRepresentation(self.imgMultimedia.image!, 0.8) {
                multipartFormData.appendBodyPart(data: imageData, name: "photo_video", fileName: "\(filename).jpg", mimeType: "image/png")
            }
            
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
                                self.removeAllOverlays()
                                print("JSON: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                        GeneralUI.alert(json["message"].string!)
                                    } else {
                                        GeneralUI.alert(json["message"].string!)
                                        print("\(json["message"].string)")
                                        self.txtCaption.resignFirstResponder()
                                        self.initPlaceholderForTextView()
                                        
                                        //MARK: Mixpanel
                                        let uid = General.loadSaved("user_id")
                                        Mixpanel.mainInstance().identify(distinctId: uid)
                                        Mixpanel.mainInstance().track(event: "Photo Post",
                                            properties: ["Photo Post" : "Photo Post"])
 
                                        //MARK: User is on Home Tab screen, reload data
                                        NSNotificationCenter.defaultCenter().postNotificationName("PostReloadHomePage", object: nil)
                                        
                                        //After successful post return back to main screen
                                        self.navigationController?.popViewControllerAnimated(true)
                                    }
                                }else{
                                    GeneralUI.alert("\(json["message"].string)")
                                }
                                
                            }
                            
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                             self.view.userInteractionEnabled = true
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                     self.view.userInteractionEnabled = true
                    print(encodingError)
                }
        })
    }
    
    
    func addNewVideoPost(params: [String: AnyObject]){
        
       // cust.showLoadingCircle()
        /*let userid = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
        var parameters = [String:AnyObject]()
        parameters = ["userid":userid,
                      "token_id":token,
                      "type":"video",
                      "content":"",
                      "caption":self.txtCaption.text
        ]*/
        //let path = NSBundle.mainBundle().pathForResource("sample", ofType: "mp4")
        
        //let videodata: NSData? = NSData.dataWithContentsOfMappedFile(path!) as? NSData
        self.showTextOverlay("Uploading")
        print(params)
        //print("self.videoData:\(self.videoData)")
        
        let URL = "https://milpeeps.com/dt-admin/posts/addpost"
        //let image = UIImage(named: "image.png")
        self.view.userInteractionEnabled = false
        Alamofire.upload(.POST, URL, multipartFormData: {
            multipartFormData in
            let filename = GeneralUI_UI.generateRandomImageName()
            multipartFormData.appendBodyPart(data: self.videoData, name: "photo_video", fileName: "\(filename).mov", mimeType: "video/MOV")
            
            if let imageData = UIImageJPEGRepresentation(self.imgVideo.image!, 0.8) {
                multipartFormData.appendBodyPart(data: imageData, name: "video_thumb", fileName: "\(filename)_thumb.jpg", mimeType: "image/png")
            }
            
            for (key, value) in params {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            }, encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    print("s")
                    
                    upload.responseJSON {
                        response in
                        print("response.request:\(response.request)")  // original URL request
                        print("response.response:\(response.response)") // URL response
                        print("response.data:\(response.result.value)")     // server data
                        print("response.result:\(response.result)")   // result of response serialization
                        
                        if let value = response.result.value {
                            self.removeAllOverlays()
                            self.cust.hideLoadingCircle()
                            print("JSON: \(value)")
                             self.view.userInteractionEnabled = true
                            
                            let json = JSON(value)
                            GeneralUI.alert(json["message"].stringValue)
                            
                            //MARK: Mixpanel
                            let uid = General.loadSaved("user_id")
                            Mixpanel.mainInstance().identify(distinctId: uid)
                            Mixpanel.mainInstance().track(event: "Video Post",
                                properties: ["Video Post" : "Video Post"])

                            
                            //MARK: User is on Home Tab screen, reload data
                            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadHomePage", object: nil)
                            
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                case .Failure(let encodingError):
                    self.cust.hideLoadingCircle()
                      self.view.userInteractionEnabled = true
                    print(encodingError)
                }
        })
        
    }
    
    func myVideo(source:NSURL){
        let compressedURL = NSURL.fileURLWithPath(NSTemporaryDirectory() + NSUUID().UUIDString + ".m4v")
        let outputFileURL : NSURL = source
        compressVideo(outputFileURL, outputURL: compressedURL) { (session) in
            switch session.status {
            case .Unknown:
                break
            case .Waiting:
                break
            case .Exporting:
                break
            case .Completed:
                let data = NSData(contentsOfURL: compressedURL)
                self.videoData = data!
                print("File size after compression: \(Double(data!.length / 1048576)) mb")
            case .Failed:
                break
            case .Cancelled:
                break
            }
        }
    }
    
    
    func editPost(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
         self.showTextOverlay("Uploading")
        Alamofire.upload(.POST, Urls_UI.EDIT_POST, multipartFormData: {
            multipartFormData in
             let filename = GeneralUI_UI.generateRandomImageName()
            
            if let imageData = UIImageJPEGRepresentation(self.imgMultimedia.image!, 1.0) {
                multipartFormData.appendBodyPart(data: imageData, name: "photo_video", fileName: "\(filename).jpg", mimeType: "image/png")
            }
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
                                        GeneralUI_UI.alert(json["message"].string!)
                                        print("\(json["message"].string)")
                                        self.delObj.isPostEditEnable = false
                                        
                                        //MARK: User is on notification list screen, reload data
                                        NSNotificationCenter.defaultCenter().postNotificationName("PostReloadHomePage", object: nil)
                                        
                                        self.btnBack.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                                    }
                                }else{
                                    GeneralUI_UI.alert("\(json["message"].string)")
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                             self.view.userInteractionEnabled = true
                            self.cust.hideLoadingCircle()
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    self.cust.hideLoadingCircle()
                     self.view.userInteractionEnabled = true
                    print(encodingError)
                }
        })
    }
    
    
    func editVideoPost(params: [String: AnyObject]){
        
        // cust.showLoadingCircle()
       
        self.showTextOverlay("Uploading")
        print(params)
        //print("self.videoData:\(self.videoData)")
        
         self.view.userInteractionEnabled = false
        Alamofire.upload(.POST, Urls_UI.EDIT_POST, multipartFormData: {
            multipartFormData in
            let filename = GeneralUI_UI.generateRandomImageName()
            multipartFormData.appendBodyPart(data: self.videoData, name: "photo_video", fileName: "\(filename).mov", mimeType: "video/MOV")
            
            if let imageData = UIImageJPEGRepresentation(self.imgVideo.image!, 1.0) {
                multipartFormData.appendBodyPart(data: imageData, name: "video_thumb", fileName: "\(filename)_thumb.jpg", mimeType: "image/png")
            }
            
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
                                 self.view.userInteractionEnabled = true
                                print("JSON: \(json)")
                                
                                if let status = json["status"].string {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].string!)
                                    } else {
                                        GeneralUI_UI.alert(json["message"].string!)
                                        print("\(json["message"].string)")
                                        self.delObj.isPostEditEnable = false
                                        
                                        //MARK: User is on notification list screen, reload data
                                        NSNotificationCenter.defaultCenter().postNotificationName("PostReloadHomePage", object: nil)
                                        
                                        self.btnBack.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                                    }
                                }else{
                                    GeneralUI_UI.alert("\(json["message"].string)")
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                             self.view.userInteractionEnabled = true
                            self.cust.hideLoadingCircle()
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    self.cust.hideLoadingCircle()
                     self.view.userInteractionEnabled = true
                    print(encodingError)
                }
        })
        
    }
    
    
    func editPostCaption(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        self.showTextOverlay("Uploading")
        Alamofire.upload(.POST, Urls_UI.EDIT_CAPTION, multipartFormData: {
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
                                        GeneralUI_UI.alert(json["message"].string!)
                                        print("\(json["message"].string)")
                                        self.delObj.isPostEditEnable = false
                                        
                                        //MARK: User is on notification list screen, reload data
                                        NSNotificationCenter.defaultCenter().postNotificationName("PostReloadHomePage", object: nil)
                                        self.btnBack.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                                    }
                                }else{
                                    GeneralUI_UI.alert("\(json["message"].string)")
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                             self.view.userInteractionEnabled = true
                            self.cust.hideLoadingCircle()
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    self.cust.hideLoadingCircle()
                     self.view.userInteractionEnabled = true
                    print(encodingError)
                }
        })
    }
    
//MARK: Social Media
    
    func postImageOnFacebook(){
        if(is_imageUpload){
            let photoshare : FBSDKSharePhoto = FBSDKSharePhoto()
            photoshare.image = postImage
            photoshare.userGenerated = true
            let photo : FBSDKSharePhoto = FBSDKSharePhoto(image: postImage, userGenerated: true)
            
            let content  : FBSDKShareMediaContent = FBSDKShareMediaContent()
            content.media = [photo]
            
            content.contentURL = NSURL(string: "https://dogtagsapp.com")
           
            let dialog : FBSDKShareDialog = FBSDKShareDialog()
            dialog.shareContent = content
            dialog.fromViewController = self
            dialog.mode = FBSDKShareDialogMode.Automatic
            dialog.delegate = self
            dialog.show()
        }
        
        
    }

    
    func postVideoOnFacebook(){
       
        /*let content : FBSDKShareVideoContent = FBSDKShareVideoContent()
        content.video = facebookvideo*/
        
       /* let video : FBSDKShareVideo = FBSDKShareVideo()
        video.videoURL = self.facebookvideo
        let content : FBSDKShareVideoContent = FBSDKShareVideoContent()
        content.video = video
        
        
        /*let videotoShare : FBSDKShareVideo = FBSDKShareVideo(videoURL: self.videoURL)
     
        let content  : FBSDKShareMediaContent = FBSDKShareMediaContent()
        content.media = [videotoShare]
        
        content.contentURL = NSURL(string: "https://dogtagsapp.com")*/
        
        let dialog : FBSDKShareDialog = FBSDKShareDialog()
        dialog.shareContent = content
        dialog.fromViewController = self
        dialog.mode = FBSDKShareDialogMode.Automatic
        dialog.delegate = self
        dialog.show()*/
        
        
        if(is_videoUpload){
            /*let vide : FBSDKShareVideo = FBSDKShareVideo(videoURL: self.facebookvideo)
            
            let content  : FBSDKShareMediaContent = FBSDKShareMediaContent()
            content.media = [vide]
            
            content.contentURL = NSURL(string: "https://dogtagsapp.com")*/
            
            let content : FBSDKShareVideoContent = FBSDKShareVideoContent()
            content.video = self.facebookvideo
            
            
            let dialog : FBSDKShareDialog = FBSDKShareDialog()
            dialog.shareContent = content
            dialog.fromViewController = self
            dialog.mode = FBSDKShareDialogMode.Automatic
            dialog.delegate = self
            dialog.show()
        }
        
        
        
        
    }
    
//TODO: - Facebook SDK ShareKit delegate methods
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("Facebook Post Completed")
        self.btnPost.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print("Facebook Post fail with error \(error)")
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        print("Facebook Post cancel")
    }
    
//MARK: Video Stuff
    func compressVideo(inputURL: NSURL, outputURL: NSURL, handler:(session: AVAssetExportSession)-> Void) {
        let urlAsset = AVURLAsset(URL: inputURL, options: nil)
        if let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) {
            exportSession.outputURL = outputURL
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.outputFileType = AVFileTypeQuickTimeMovie
            exportSession.shouldOptimizeForNetworkUse = true
            
            let start = CMTimeMakeWithSeconds(1.0, 600)
            // you will modify time range here
            let duration = CMTimeMakeWithSeconds(30.0, 600)
            let range = CMTimeRangeMake(start, duration)
            exportSession.timeRange = range
            
            exportSession.exportAsynchronouslyWithCompletionHandler { () -> Void in
                handler(session: exportSession)
            }
        }
    }
    
    
//TODO: - UIButton Action
    
    
    @IBAction func btnDoneClick(sender: AnyObject) {
        self.view.endEditing(true)
        self.btnDoneOutlet.hidden = true
    }
    //Social Action
    
    @IBAction func btnInstagramClick(sender: AnyObject) {
    }
    
    @IBAction func btnFacebookClick(sender: AnyObject) {
        if(is_photoSelect){
            postImageOnFacebook()
        }else{
            postVideoOnFacebook()
        }
    }
    
    
    @IBAction func btnTwitterClick(sender: AnyObject) {
        // Use the TwitterKit to create a Tweet composer.
        let composer = TWTRComposer()
        
        // Prepare the Tweet with the poem and image.
        if(is_imageUpload){
            let trimText = self.cust.trimString(self.txtCaption.text!)
            composer.setText(trimText)
            composer.setImage(postImage)
           // composer.setURL(NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"))
        }
        
        // Present the composer to the user.
        composer.showFromViewController(self) { result in
            if result == .Done {
                print("Tweet composition completed.")
            } else if result == .Cancelled {
                print("Tweet composition cancelled.")
            }
        }
    }
    
    @IBAction func btnVideoClick(sender: AnyObject) {
        self.btnPhotoOutlet.backgroundColor = cust.lightButtonBackgroundColor
        self.btnVideoOutlet.backgroundColor = cust.darkButtonBackgroundColor
        imgVideoTrangle.hidden = false
        imgPhotoTrangle.hidden = true
        
        //self.imgVideo.image = UIImage(named: "videoThumb.png")
        is_photoSelect = false
        self.imgMultimedia.hidden = true
        self.imgVideo.hidden = false
        self.btnTwitter.hidden = true
        self.btnFacebook.frame.size.width = self.btnPost.frame.size.width
        
    }
    
    @IBAction func btnPhotoClick(sender: AnyObject) {
        self.btnVideoOutlet.backgroundColor = cust.lightButtonBackgroundColor
        self.btnPhotoOutlet.backgroundColor = cust.darkButtonBackgroundColor
        imgVideoTrangle.hidden = true
        imgPhotoTrangle.hidden = false
        //self.imgMultimedia.image = UIImage(named: "Gun.png")
        self.imgMultimedia.hidden = false
        self.imgVideo.hidden = true
        is_photoSelect = true
        self.btnTwitter.hidden = false
        self.btnFacebook.frame.size.width = orgWidth
    }
    
    @IBAction func btnPostClick(sender: AnyObject) {
        //Uncomment Below to implement web service
        var trimmedString  : String = String()
        if(is_textEdited){
          trimmedString  = self.cust.trimString(self.txtCaption.text)
        }
        let uID = General.loadSaved("user_id")
        let userToken = General.loadSaved("user_token")
        
        if(is_photoSelect){
            //Upload photo only
            if(is_imageUpload){
               
                if(self.delObj.isPostEditEnable){
                    
                    //MARK: Edit post
                    let params: [String: AnyObject] = ["userid": uID, "token_id": userToken,"type":"photo","content":"","caption":trimmedString,"post_id":postID ]
                    editPost(params)
                    self.view.endEditing(true)
                    
                }else{
                    
                    //MARK: Add post
                    let params: [String: AnyObject] = ["userid": uID, "token_id": userToken,"type":"photo","content":"","caption":trimmedString ]
                    addNewImagePost(params)
                    self.view.endEditing(true)
                }
                
            }
            
        }else{
            //Upload video only
            
            if(is_videoUpload){
           
                if(self.delObj.isPostEditEnable){
                    
                    if(self.is_orgVideoRemove){
                        //MARK: update with video and caption
                        let params: [String: AnyObject] = ["userid": uID, "token_id": userToken,"type":"video","content":"","caption":trimmedString,"post_id":postID ]
                        editVideoPost(params)
                        self.view.endEditing(true)
                        
                    }else{
                        //MARK: Update only caption
                        let params: [String: AnyObject] = ["caption":trimmedString,"post_id":postID ]
                        editPostCaption(params)
                        self.view.endEditing(true)
                    }
                    
                }else{
                    let params: [String: AnyObject] = ["userid": uID, "token_id": userToken,"type":"video","content":"","caption":trimmedString]
                    addNewVideoPost(params)
                    self.view.endEditing(true)
                }
            }
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
