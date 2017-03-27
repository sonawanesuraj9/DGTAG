//
//  SignupSecondStepViewController.swift
//  DogTags
//
//  Created by vijay kumar on 26/09/16.
//  Copyright © 2016 Vijayakumar. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import JDropDownAlert
import SwiftOverlays
import ObjectMapper
import Haneke
import DLRadioButton
import DatePickerDialog

class SignupSecondStepViewController: UIViewController {

    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let unselectedBackgroundColor = UIColor(red: 0.922, green: 0.922, blue: 0.922, alpha: 1.0)
    
    var textArray : [String] = ["Member of the Armed Forces","A Military dependent is a spouse(s), children, and possibly other familial relationship categories of a sponsoring military member for purposes of pay as well as special benefits, privileges and rights.","A Military veteran is a person who has served or in the armed forces."]
    var titleArray : [String] = ["Military\nMember","Military\nDependent","Military\nVeteran"]
    var currentIndex : Int = Int()
    var typeID : Int = Int()
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnMilMember: UIButton!
    @IBOutlet weak var btnMilDependent: UIButton!
    @IBOutlet weak var btnPotentialRecrut: UIButton!
    
    var userid: String!
    let cache = Shared.stringCache
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        currentIndex = 0
        typeID = 1
        setSelected(currentIndex)
        print(userid)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadAPI()
        initialization()
    }
    
    func loadAPI() {
        
        self.showWaitOverlayWithText("Loading ...")
        cache.fetch(key: Urls.LIST_USER_TYPE).onSuccess { data in
            
                let json = SwiftyJSON.JSON.parse(data)
                self.textArray.removeAll()
                self.removeAllOverlays()
            
            print(json)
                var i = 0
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.textArray.insert(subJson["type_descr"].string!, atIndex: i)
                self.titleArray.insert(subJson["user_type"].string!, atIndex: i)
                    i += 1
            }
            self.initialization()
            self.setSelected(self.currentIndex)
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_USER_TYPE)
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_USER_TYPE)
                                }
                                
                                var i = 0
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    self.textArray.insert(subJson["type_descr"].string!, atIndex: i)
                                    self.titleArray.insert(subJson["user_type"].string!, atIndex: i)
                                    i += 1
                                }
                                self.initialization()
                                self.setSelected(self.currentIndex)
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func initialization() {
        
        //Center justify
        self.btnMilMember.titleLabel?.textAlignment = NSTextAlignment.Center
        self.btnMilDependent.titleLabel?.textAlignment = NSTextAlignment.Center
        self.btnPotentialRecrut.titleLabel?.textAlignment = NSTextAlignment.Center
        
        self.btnMilMember.setTitle(titleArray[0], forState: .Normal)
        self.btnMilDependent.setTitle(titleArray[1], forState: .Normal)
        self.btnPotentialRecrut.setTitle(titleArray[2], forState: .Normal)
        
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
        self.navigationView.backgroundColor = self.cust.navBackgroundColor
        self.view.backgroundColor = self.cust.mainBackgroundColor
    }
    
    
    /**
     Here, we are refering button with tag.
     11 -> Miltary Member,
     12 -> Miltray Dependent
     14 -> Potential Recruiter
     
     - parameter sender: Sender will be button
     */
    func setSelected(selectedIndx : Int){
        
        // set background
        self.btnMilMember.backgroundColor = unselectedBackgroundColor
        self.btnMilDependent.backgroundColor = unselectedBackgroundColor
        self.btnPotentialRecrut.backgroundColor = unselectedBackgroundColor
        
        // set title
        self.btnMilMember.setTitleColor(cust.darkButtonBackgroundColor, forState: UIControlState.Normal)
        self.btnMilDependent.setTitleColor(cust.darkButtonBackgroundColor, forState: UIControlState.Normal)
        self.btnPotentialRecrut.setTitleColor(cust.darkButtonBackgroundColor, forState: UIControlState.Normal)
        
        if(selectedIndx == 0) {
            self.btnMilMember.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
             self.btnMilMember.backgroundColor = cust.lightButtonBackgroundColor
            self.delObj.signupSelectedIndex = 1
            
        } else if(selectedIndx == 1) {
            self.btnMilDependent.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
             self.btnMilDependent.backgroundColor = cust.lightButtonBackgroundColor
            self.delObj.signupSelectedIndex = 2
            
        } else if(selectedIndx == 2) {
            self.btnPotentialRecrut.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.btnPotentialRecrut.backgroundColor = cust.lightButtonBackgroundColor
            self.delObj.signupSelectedIndex = 3
            
        } else {
            print("You are away")
        }
        
        self.lblTitle.text = self.titleArray[selectedIndx]
        self.lblDescription.text = self.textArray[selectedIndx]
        self.lblDescription.textColor = cust.normalTextColor
    }
    
    @IBAction func btnLoginAsClick(sender: AnyObject) {
        
        if(sender.tag == 11) {
            currentIndex = 0
            typeID = 1
        }else if(sender.tag == 12) {
            currentIndex = 1
            typeID = 2
        }else if(sender.tag == 13) {
            currentIndex = 2
            typeID = 3
        }
        setSelected(currentIndex)
    }

    @IBAction func btnSubmitClick(sender: AnyObject) {
        
        if(self.currentIndex == 1) {
            let signupAsVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupAsMilitaryDependentViewController") as! SignupAsMilitaryDependentViewController
            signupAsVC.userid = String(userid)
            signupAsVC.utype = String(currentIndex+1)
            self.delObj.signupSelectedIndex = self.typeID
            self.navigationController?.pushViewController(signupAsVC, animated: true)
        }else{
            let signupAsAllVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupAsMilitaryMemberViewController") as! SignupAsMilitaryMemberViewController
            signupAsAllVC.userid = String(userid)
            signupAsAllVC.utype = String(currentIndex+1)
            self.delObj.signupSelectedIndex = self.typeID
            self.navigationController?.pushViewController(signupAsAllVC, animated: true)
        }
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
