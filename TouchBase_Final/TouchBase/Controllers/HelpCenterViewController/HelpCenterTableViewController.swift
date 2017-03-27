//
//  HelpCenterTableViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 03/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class HelpCenterTableViewController: UITableViewController {

    @IBOutlet weak var btnSwitch: UISwitch!
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet var tblMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblMain.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let tmp = General.loadSaved("is_public")
        print("222:\(tmp)")
        
        if(tmp == "1"){
            self.btnSwitch.setOn(true, animated: true)
        }else{
            self.btnSwitch.setOn(false, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! UITableViewCell
        
        if indexPath.row == 0{
            
            
            
        }
        return cell
    }*/
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let index = indexPath.row
        switch index {
      
        case 0:
            
            print("Nothing has to do")
            break;
        case 1:
            
            //Change My Password
            let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navChangePassword") as! UINavigationController
            self.presentViewController(noti, animated: true, completion: nil)
            break;
        case 2:
            //Block list
            let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navBlocklist") as! UINavigationController
            self.presentViewController(noti, animated: true, completion: nil)
            break;
            
       /* case 3:
            //About DogTags
            let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navWebView") as! UINavigationController
            self.delObj.webViewIndex = 1
            self.presentViewController(noti, animated: true, completion: nil)
            break;*/
        /*case 2:
            //FAQ's DogTags
            let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navWebView") as! UINavigationController
             self.delObj.webViewIndex = 0
            self.presentViewController(noti, animated: true, completion: nil)
            break;*/
        case 3:
            
            //Report A Problem
            let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idReportViewController") as! ReportViewController
            noti.selection = 0
            self.navigationController?.pushViewController(noti, animated: true)
   
            break;
        case 4:
            //Delete Account
            let deleteAlert = UIAlertController(title: "DogTags", message: "Are you sure, you want to Delete Account?", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                
                let userID = General.loadSaved("user_id")
                let token = General.loadSaved("user_token")
                
                let params: [String: AnyObject] = ["user_id": userID, "token_id": token ]
                
                self.deleteAccount(params){ response in
                    print("deleteAccount:\(response)")
                    if(response){
                        print(" true")
                        General.saveData("", name: "login_username")
                        General.saveData("", name: "login_password")
                        
                        self.delObj.is_AccountDelete = true
                        //Yes code here
                        self.dismissViewControllerAnimated(false, completion: nil)
                        //self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
                        
                    }else{
                        print(" false")
                    }
                    
                }
                
            }))
            deleteAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(deleteAlert, animated: true, completion: nil)
            
            break;
        case 5:
            //General Comment
            let noti = self.storyboard?.instantiateViewControllerWithIdentifier("idReportViewController") as! ReportViewController
            noti.selection = 1
              self.navigationController?.pushViewController(noti, animated: true)
            break;
        case 6:
            //Privacy Policy
            let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navWebView") as! UINavigationController
            self.delObj.webViewIndex = 2
            self.presentViewController(noti, animated: true, completion: nil)
            break;
        case 7:
            //Terms and Conditions
            let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navWebView") as! UINavigationController
            self.delObj.webViewIndex = 3
            self.presentViewController(noti, animated: true, completion: nil)
            break;
        default:
            print("Hurry..")
        }
        
        
    }
    

    @IBAction func switchChanged(sender: AnyObject) {
        //MARK: Web service / API to unlike post
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
        if btnSwitch.on{
            print("Button On")
             let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"is_public":"1" ]
            
            self.changeProfile(params){ response in
                print("changeProfile:\(response)")
                if(response){
                    print(" true")
                    General.saveData("1", name: "is_public")
                    self.btnSwitch.setOn(true, animated: true)
                }else{
                    print(" false")
                }
                
            }

        }else{
            print("Button off")
             let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"is_public":"0" ]
            
            self.changeProfile(params){ response in
                print("changeProfile:\(response)")
                if(response){
                    print(" true")
                     General.saveData("0", name: "is_public")
                     self.btnSwitch.setOn(false, animated: true)
                    
                }else{
                    print(" false")
                }
                
            }

        }
    }
    
    
//TODO: - Web service / API implementation
    
    
    
    //
    
    func deleteAccount(params: [String: AnyObject], completion : (Bool) -> ()) {
        
        self.view.userInteractionEnabled = false
        print(params)
        
        Alamofire.upload(.POST, Urls_UI.DELETE_ACCOUNT, multipartFormData: {
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
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                        completion(false)
                                    } else {
                                        print("You are in successful block")
                                        completion(true)
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
     change global Profile
     
     - parameter params: userid, isPublic, token
     */
    
    func changeProfile(params: [String: AnyObject], completion : (Bool) -> ()) {
        
        self.view.userInteractionEnabled = false
        print(params)
        
        Alamofire.upload(.POST, Urls_UI.PROFILE_PUBLIC_PRIVATE, multipartFormData: {
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
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                        completion(false)
                                    } else {
                                        print("You are in successful block")
                                        completion(true)
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
    
    


}
