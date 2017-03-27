//
//  ProfileInfoTableViewController.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 02/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import JDropDownAlert
import SwiftOverlays
import ObjectMapper
import Haneke

class ProfileInfoTableViewController: UITableViewController {
    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    
    
    var profileDetails = [ProfileValueModel]()
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //loadProfileDetails()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.profileDetails.removeAll()
        loadProfileDetails()
        tableView.reloadData()
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
                        
                        self.cust.hideLoadingCircle()
                        
                        let json = JSON(value)
                        print("json for edit profile:\(json)")
                        if let value = json[0]["user_fullname"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Name", detail: value, lock: "0")!)
                        }
                        
                        if let user_email = json[0]["user_email"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Email Address", detail: user_email, lock: "0")!)
                        }
                        if let user_type = json[0]["user_type"].string {
                            self.profileDetails.append(ProfileValueModel(name: "User type", detail: user_type, lock: json[0]["type_islocked"].string!)!)
                        }
                        if let data = json[0]["user_service_status"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Service status", detail: data, lock: "0")!)
                        }
                        
                        if let data = json[0]["user_ht_country"].string {
                            
                            var city = ""
                            var state = ""
                            
                            if let data2 = json[0]["user_ht_state"].string {
                                state = data2 + ", "
                                
                                if let data3 = json[0]["user_ht_city"].string {
                                    city = data3 + ", "
                                }
                            }
                            
                            self.profileDetails.append(ProfileValueModel(name: "Hometown", detail: city + state + data, lock: json[0]["ht_country_islocked"].string!)!)
                        }
                        
                        
                        if let data = json[0]["user_loc_country"].string {
                            
                            var city = ""
                            var state = ""
                            
                            if let data2 = json[0]["user_loc_state"].string {
                                state = data2 + ",\n"
                                
                                if let data3 = json[0]["user_loc_city"].string {
                                    city = data3 + ", "
                                }
                            }
                            
                            self.profileDetails.append(ProfileValueModel(name: "Location", detail: city + state + data, lock: json[0]["loc_country_islocked"].string!)!)
                        }
                        
                       
                        
                        if let data = json[0]["user_age"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Age", detail: data, lock: json[0]["birth_date_islocked"].string!)!)
                        }
                        
                        if let data = json[0]["user_gender"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Gender", detail: data, lock: json[0]["gender_islocked"].string!)!)
                        }
                        
                        if let data = json[0]["user_ethnicity"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Ethnicity", detail: data, lock: json[0]["ethnicity_islocked"].string!)!)
                        }
                        
                        if let data = json[0]["user_language"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Language", detail: data, lock: json[0]["language_islocked"].string!)!)
                        }
                        
                        if let data = json[0]["user_branch"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Branch", detail: data, lock: json[0]["branch_islocked"].string!)!)
                        }
                        
                        if let data = json[0]["user_military_base"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Military base", detail: data, lock: json[0]["military_base_islocked"].string!)!)
                        }
                        
                        if let data = json[0]["user_paygrade"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Paygrade", detail: data, lock: json[0]["paygrade_islocked"].string!)!)
                        }
                        
                        if let data = json[0]["user_rank"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Rank", detail: data, lock: json[0]["rank_islocked"].string!)!)
                        }
                        
                        if let data = json[0]["user_job"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Job", detail: data, lock: json[0]["job_islocked"].string!)!)
                        }
                        
                        if let data = json[0]["user_has_children"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Children", detail: data, lock: "0")!)
                        }
                        if let data = json[0]["user_interest"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Interested In", detail: data, lock: "0")!)
                        }
                        if let data = json[0]["user_relationship"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Relationship", detail: data, lock: json[0]["relationship_islocked"].string!)!)
                        }
                        
                        self.tableView.scrollEnabled = true
                        self.tableView.reloadData()
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
        return self.profileDetails.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProfileDetailCell = tableView.dequeueReusableCellWithIdentifier("ProfileDetailCell", forIndexPath: indexPath) as! ProfileDetailCell
        
        let data = self.profileDetails[indexPath.row]
        
        cell.lblName.text = data.name
        //if data.lock == "0" {
            cell.lblDetail.text = data.detail.capitalizedString
       // } else {
        //    cell.lblDetail.text = "BAC"
       // }
        
        return cell
    }
    
    
}