//
//  AppDelegate.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 18/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Mixpanel
//import Fabric
//import TwitterKit
//import Crashlytics
import KGFloatingDrawer
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var is_AccountDelete : Bool = Bool()
    var deviceName : String = String()
    var deviceTokenToSend = ""
    var isDeviceTokenSend : Int = 0
    var screenTag : Int = Int()
    var isOnVerificationMethod = false
    
    var badgeCount = 0
    var signupSelectedIndex  : Int = Int()
    /******************** Notification variables *********************************/
     var is_messageWindowVisible : Bool = Bool()
     var is_notificationWindowVisible : Bool = Bool()
    
    /******************** Device general variables *******************************/
    var screenWidth : CGFloat = CGFloat()
    var screenHeight : CGFloat = CGFloat()
    
    
    /******************** Device general variables *******************************/
    
    var webViewIndex : Int = Int()
    /*************************** General Variables *******************************/
    var isSomeThingEdited : Bool = Bool()    
    var carryPostID : String = String()
    var carryUserID : String = String()
    /*************************** User specifi Variables *******************************/
    var user_branchid : String = String()
    var user_branch : String = String()
    /*************************** Notification Variables *******************************/
    var likeBadgeCount : String = String()
    var commentBadgeCount : String = String()
    var messageBadgeCount : String = String()
    var referenceBadgeCount : String = String()
    var followrequestBadgeCount : String = String()
    
    var isPostEditEnable : Bool = Bool()
    var isFromEditProfile : Bool = Bool()
    /*********************** Dashboard data ***************************************/
    var dashCellHeight : CGFloat = CGFloat()
    var detCellHeight : CGFloat = CGFloat()
    var commentCellHeight : CGFloat = CGFloat()
    let notApprovedMessage = "Your account is not approved yet"
    let notPremiumMessage = "Please upgrade to premium membership to access DogTags app premium features."
    var isFromMenu : Bool = Bool()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
       // Fabric.with([Crashlytics.self, Twitter.self])

        // TODO: Move this to where you establish a user session
        //self.logUser()

        
        //MARK: CHeck LaunchOption
        likeBadgeCount  = "0"
        commentBadgeCount = "0"
        messageBadgeCount = "0"
        referenceBadgeCount = "0"
        followrequestBadgeCount = "0"
        
        
        
        let userID = General.loadSaved("user_id")
        let ref = General.loadSaved("reference_number")
        let params: [String: AnyObject] = ["user_id": userID, "reference": ref ]
        if(userID != ""){
            fetchNewMessageCount(params)
        }else{
            General.saveData("0", name: "badge_count")
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            
        }

        
        //MARK: Analytics initialization
        Mixpanel.initialize(token: "aae5af9cf6eec8a9def25e0a294ecb7c")
        
        //MARK: Testing Token ID
        //Mixpanel.initialize(token: "666adc08c2e8071ed22f553aabf9bfa4")
        let uid = General.loadSaved("user_id")
        Mixpanel.mainInstance().identify(distinctId: uid)
        
        
        //MARK: Track Downloads
        let needsToTrack = General.loadSaved("needsToTrack")
        if(needsToTrack == "1"){
            
        }else{
            Mixpanel.mainInstance().track(event: "App Downloads",
                                          properties: ["App Downloads" : "App Downloads"])
            General.saveData("1", name: "needsToTrack")
        }
       

        
        is_AccountDelete = false
        //Mannually override IQKeyboardManager
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
       
        screenWidth = UIScreen.mainScreen().bounds.width
        screenHeight = UIScreen.mainScreen().bounds.height
        captureScreenResolution()
        
        customNavigation()
        
        // Push notification
        registerForPushNotifications(application)
        
        //initializeNotificationSetting()
        
        /*let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()*/
       
        
        //MARK: Screen navigation
        redirectionToScreen()
        
        
        
        
        return true
      
        
    }

    /**
     Navigation controller best practices
     */
    func customNavigation(){
        //Customize naviagion
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.darkGrayColor()
        UINavigationBar.appearance().barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().backgroundColor = UIColor.greenColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : (UIFont(name: "Helvetica", size: 15))!, NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
    }
    
    
    func captureScreenResolution(){
        if(screenHeight == 568){
            print("4 inch device")
            deviceName = "_i5"
            dashCellHeight = 260 //315
            //Detail Page
            detCellHeight = 260 //375
            commentCellHeight = 100
        }else if(screenHeight == 667){
             print("4.7 inch device")
             deviceName = "_i6"
            dashCellHeight = 260 //345 //400
            
            //Detail Page
            detCellHeight = 260 //375 //434
            commentCellHeight = 117
            
        }else if(screenHeight == 736){
             print("5.5 inch device")
             deviceName = "_i6p"
            dashCellHeight = 260 //420 //475
            
            //Detail Page
            detCellHeight = 260 //375 //479
            commentCellHeight = 100
        }else{
             print("4 inch device")
             deviceName = "_i5"
            dashCellHeight = 260 //315
            
            //Detail Page
            detCellHeight = 260 //375
            commentCellHeight = 100
        }
    }
    
    
    func redirectionToScreen()
    {
        
        //If user once signed up then will be redirected to 2nd screen otherwise it will show 1st screen i.e registration screen
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var firstVC : ViewController
        firstVC = mainStoryboard.instantiateViewControllerWithIdentifier("idViewController") as! ViewController
        let nav = UINavigationController(rootViewController: firstVC)
        appdelegate.window!.rootViewController = nav

        
        
       /* let autoLogin =  General.loadSaved("autologin")
        if(autoLogin == "1")
        {
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let secondVc = mainStoryboard.instantiateViewControllerWithIdentifier("idSignInViewController") as! SignInViewController
            General.saveData("1", name: "autologin")
            let nav = UINavigationController(rootViewController: secondVc)
            appdelegate.window!.rootViewController = nav
            
        }
        else
        {
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var firstVC : ViewController
            firstVC = mainStoryboard.instantiateViewControllerWithIdentifier("idViewController") as! ViewController
            General.saveData("0", name: "autologin")
            let nav = UINavigationController(rootViewController: firstVC)
            appdelegate.window!.rootViewController = nav

        }*/
        
    }

    
//TODO: - Remote Notification Initialization
    
    /**
     - Remote notification initialization function
     
     - returns:
     */
    func initializeNotificationSetting(){
        //Remote Notification Code
        let setting = UIUserNotificationSettings(forTypes: [.Sound,.Badge,.Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    
    
    
//TODO: - Remote Notification Delegate Method
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        
        let deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString( " ", withString: "") as String
        
        print(" deviceTokenString : \(deviceTokenString)" )
        General.saveData(deviceTokenString, name: "deviceTokenString")
        
        deviceTokenToSend = deviceTokenString
        NSNotificationCenter.defaultCenter().postNotificationName("GotDeviceToken", object: nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    
    /**
     - Remote notification received method implementation
     
     - parameter application: Application infor
     - parameter deviceToken: device token
     */
 
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        print("aps:\(aps)")
        
        print("badgeCount :\(aps["badge"])")
        print("tag :\(aps["tag"])")
        let tag = aps["tag"] as! String
        let alrt = aps["alert"] as! String
        
        let countval = General.loadSaved("badge_count")
        badgeCount = Int(countval)! + 1
        let stringSave = String(badgeCount)
        General.saveData(stringSave, name: "badge_count")
        UIApplication.sharedApplication().applicationIconBadgeNumber = badgeCount
 
        
        
        //Handle In-App Notifications
        
        /*
         1: Approve Reference
         2: Send Follow Request 
         3: Like Post >>
         4: Comment Post >>
         5: Send New Message >>
         6: Approve User By Admin
         7: Reference Notification
         */
        
        //MARK: Likes
        if(tag == "3" && screenTag == 1){
            //MARK: User is on home screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadHomeTab", object: nil)
        }else if(tag == "3" && screenTag == 4){
            //MARK: User is on post detail screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadPostDetailScreen", object: nil)
        }else if(tag == "3" && screenTag == 7){
            //MARK: User is on notification home screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadLikeNotificationsCount", object: nil)
        }else if(tag == "3" && screenTag == 71){
            //MARK: User is on notification list screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadLikeNotificationsList", object: nil)
        }else if(tag == "3"){
            //MARK: Reload only notification counter
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadNotificationTab", object: nil)
        }
        
        //MARK: Comment
        else if(tag == "4" && screenTag == 1){
            //MARK: User is on home screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadHomeTab", object: nil)
        }else if(tag == "4" && screenTag == 4){
            //MARK: User is on post detail screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadPostDetailScreen", object: nil)
        }else if(tag == "4" && screenTag == 7){
            //MARK: User is on notification home screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadCommentNotificationsCount", object: nil)
        }else if(tag == "4" && screenTag == 71){
            //MARK: User is on notification list screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadCommentNotificationsList", object: nil)
        }else if(tag == "4"){
            //MARK: User is on notification list screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadNotificationTab", object: nil)
        }
        
        //MARK: Message
        else if(tag == "5" && screenTag == 2){
            //MARK: User is on notification list screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadMessageUserList", object: nil)
        }else if(tag == "5" && screenTag == 3){
            //MARK: User is on notification list screen, reload data
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadMessageChat", object: nil)
        }
        
        
        //MARK: Approved by admin
        else if(tag == "6" || tag == "1"){
            //MARK: Notify user that his/her account is approved by admin
            let tmpAlert = UIAlertController(title: "", message: alrt, preferredStyle: .Alert)
            tmpAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (value:UIAlertAction) in
                //
                General.saveData("1", name: "verification_pending")
                tmpAlert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.window?.rootViewController?.presentViewController(tmpAlert, animated: true, completion: nil)
            
        }
        else if(tag == "10"){
            //MARK: User Got Life time access.
            let tmpAlert = UIAlertController(title: alrt, message: "", preferredStyle: .Alert)
            tmpAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (value:UIAlertAction) in
                tmpAlert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.window?.rootViewController?.presentViewController(tmpAlert, animated: true, completion: nil)
        }
        
        //MARK: Load Notification count
        let userID = General.loadSaved("user_id")
        let ref = General.loadSaved("reference_number")
        let params: [String: AnyObject] = ["user_id": userID, "reference": ref ]
        if(userID != ""){
            fetchNewMessageCount(params)
        }
        
        //Check if message thread open, if yes then reload data
        if(is_messageWindowVisible){
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadMessage", object: nil)
        }else if(is_notificationWindowVisible){
            //Check if user is on listing page and new message arrive
            NSNotificationCenter.defaultCenter().postNotificationName("PostReloadMessageWindow", object: nil)
        }
        
        
    }
    
    /**/
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //Mixpanel: If user skip verification method, from verification screen. This metric will be raised
        if isOnVerificationMethod{
            let uid = General.loadSaved("user_id")
            Mixpanel.mainInstance().identify(distinctId: uid)            
            Mixpanel.mainInstance().track(event: "Verification Skipped",
                                          properties: ["Verification Skipped" : "Verification Skipped"])
            isOnVerificationMethod = false
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      
        //MARK: Load Notification count
        let userID = General.loadSaved("user_id")
        let ref = General.loadSaved("reference_number")
        let params: [String: AnyObject] = ["user_id": userID, "reference": ref ]
        if(userID != ""){
             fetchNewMessageCount(params)
        }
       
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
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
                                        self.likeBadgeCount = json["like_count"].stringValue
                                        self.commentBadgeCount = json["comment_count"].stringValue
                                        self.messageBadgeCount = json["unread_count"].stringValue
                                        self.referenceBadgeCount = json["reference_count"].stringValue
                                        self.followrequestBadgeCount = json["follow_request"].stringValue
                                        
                                        print("1.self.likeBadgeCount\(self.likeBadgeCount)")
                                        print("1.self.commentBadgeCount\(self.commentBadgeCount)")
                                        print("1.self.messageBadgeCount\(self.messageBadgeCount)")
                                        print("1.self.referenceBadgeCount\(self.referenceBadgeCount)")
                                        
                                        let badgeCount = Int(self.likeBadgeCount)! +
                                            Int(self.commentBadgeCount)! +
                                            Int(self.messageBadgeCount)! +
                                            Int(self.referenceBadgeCount)! +
                                            Int(self.followrequestBadgeCount)!
                                        
                                        General.saveData(String(badgeCount), name: "badge_count")
                                        UIApplication.sharedApplication().applicationIconBadgeNumber = badgeCount
                                        NSNotificationCenter.defaultCenter().postNotificationName("PostBottomBadgeCounter", object: nil)
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

