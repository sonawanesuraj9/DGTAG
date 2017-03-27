//
//  SearchResultViewController.swift
//  TouchBase
//
//  Created by Vijay Kumar on 02/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import DropDown
import Alamofire
import SwiftyJSON
import JDropDownAlert
import SwiftOverlays
import ObjectMapper
import Haneke
import Mixpanel

class SearchResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate {
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    var isRandomWSCall : Bool = Bool()
    var isFilterResWSCall : Bool = Bool()
   
    
    
    var isSearchTyped : Bool = Bool()
    var usersList = [UserListModelNew]()
    var filterList = [UserSearchResultModel]()
    
    var noDataLbl = UILabel(frame: UIScreen.mainScreen().bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 36, txtSearch.frame.height))
        txtSearch.leftView = paddingView
        txtSearch.leftViewMode = UITextFieldViewMode.Always
        
        self.txtSearch.delegate = self
        self.txtSearch.returnKeyType = .Search
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.usersList.removeAll()
        self.mainTable.reloadData()
        
        let isFilter = General.loadSaved("isFilterApplied")
        if(isFilter == "0"){
            //MARK: Filter is NOT applied
            /*if(self.txtSearch.text != ""){
                
                let count = usersList.count
                if(count>0){
                    self.filterList.removeAll()
                    for ind in 0...count-1{
                        let dt = usersList[ind]
                        print(dt)
                        if dt.user_fullname.lowercaseString.rangeOfString("swift") != nil {
                            print("exists")
                            self.isSearchTyped = true
                            filterList.append(UserSearchResultModel(user_id: dt.user_id, user_fullname: dt.user_fullname, user_profile_pic: dt.user_profile_pic, user_type: dt.user_type, user_loc_country: dt.user_loc_country, user_loc_state: dt.user_loc_state, user_loc_city: dt.user_loc_city, user_branch: dt.user_branch, is_follower: dt.is_follower, abbrivation: dt.abbrivation, dogtag_batch: dt.dogtag_batch)!)
                            
                        }
                        
                    }
                    self.mainTable.reloadData()
                }
            }else{
               loadRandomUsers()
            }*/
            
            loadRandomUsers()
        }else{
            //MARK: Filter is Applied
            
            //Index
            var tmpIndex : String = String()
            if(self.usersList.count>0){
                tmpIndex = String(self.usersList.count)
            }else{
                tmpIndex = "0"
            }
            
            
            loadUsers(tmpIndex)
        }
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        txtSearch.text = ""
        txtSearch.resignFirstResponder()
        self.view.endEditing(true)
        
        self.usersList.removeAll()
        self.mainTable.reloadData()
        
        let isFilter = General.loadSaved("isFilterApplied")
        if(isFilter == "0"){
            //MARK: Filter is NOT applied
            loadRandomUsers()
        }else{
            //MARK: Filter is Applied
            //Index
            var tmpIndex : String = String()
            if(self.usersList.count>0){
                tmpIndex = String(self.usersList.count)
            }else{
                tmpIndex = "0"
            }
            
            loadUsers(tmpIndex)
        }
        print("*******************")
        
       return true
    }
    
    
    @IBAction func txtSearchChanged(sender: AnyObject) {
        self.usersList.removeAll()
        self.mainTable.reloadData()
        
        let isFilter = General.loadSaved("isFilterApplied")
        if(isFilter == "0"){
            print("Random search")
            //MARK: Filter is NOT applied
            loadRandomUsers()
        }else{
            //MARK: Filter is Applied
            //Index
            var tmpIndex : String = String()
            if(self.usersList.count>0){
                tmpIndex = String(self.usersList.count)
            }else{
                tmpIndex = "0"
            }
            
            loadUsers(tmpIndex)
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.usersList.removeAll()
        self.mainTable.reloadData()
        
        var isFilter = General.loadSaved("isFilterApplied")
        if(isFilter == ""){
            isFilter = "0"
            General.saveData("0", name: "isFilterApplied")
        }
        if(isFilter == "0"){
            //MARK: Filter is NOT applied
            loadRandomUsers()
        }else{
            //MARK: Filter is Applied
            //Index
            var tmpIndex : String = String()
            if(self.usersList.count>0){
                tmpIndex = String(self.usersList.count)
            }else{
                tmpIndex = "0"
            }
            
            loadUsers(tmpIndex)
        }
        
    }
    
    /**
     Web Service CAll
     
     - parameter indx: parameters
     */
    func loadUsers(indx:String) {
        if !isFilterResWSCall {
        print("loadUsers")
        
        var isLocationFilterApplied : Bool = Bool()
        isLocationFilterApplied = false
        
        var utype:[String] = []        
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
        /*let is_paid = General.loadSaved("is_paid")
        var branch_id : String = String()
        
        if(is_paid == "1"){
            branch_id = ""
        }else{
            branch_id = General.loadSaved("branch_id")
        }*/
        //"branch":branch_id
        
        
       

        var params = ["user_id": userID, "token_id": token, "index": indx]
        
        
        if var data:String = General.loadSaved("search_user_type") {
            if data != "" && data != "," {
                
                data = data.stringByReplacingOccurrencesOfString("Active Duty", withString: "active")
                data = data.stringByReplacingOccurrencesOfString("Reservist", withString: "reservist")
                data = data.stringByReplacingOccurrencesOfString("Active Duty", withString: "national guard")
                
                
                var filteredDep = ""
                var filteredService = ""
                
                let dataList2 = data.characters.split{$0 == ","}.map(String.init)
                for row2 in dataList2 {
                    
                    if row2.rangeOfString("2:")  != nil {
                        if filteredDep == "" {
                            filteredDep += row2.stringByReplacingOccurrencesOfString("2:", withString: "")
                        } else {
                            filteredDep += "," + row2.stringByReplacingOccurrencesOfString("2:", withString: "")
                        }
                        
                    } else {
                        if filteredService == "" {
                            filteredService += row2.stringByReplacingOccurrencesOfString("2:", withString: "")
                        } else {
                            filteredService += "," + row2.stringByReplacingOccurrencesOfString("2:", withString: "")
                        }
                    }
                }
                
                params["servicetype"] = filteredService.lowercaseString
                params["dependent"] = filteredDep.lowercaseString
                
                let dataList = data.characters.split{$0 == ","}.map(String.init)
                for row in dataList {
                    if let type: String = row.componentsSeparatedByString(":")[0] {
                        if utype.indexOf(type) == nil {
                            utype.append(type)
                        }
                    }
                }
                
            }
        }
        
        if utype.count != 0 {
            var filtered = ""
            for row in utype {
                if let type: String = row.componentsSeparatedByString(":")[0] {
                    if filtered == "" {
                        filtered += type
                    } else {
                        filtered += "," + type
                    }
                }
            }
            params["utype"] = filtered
        }
        
        if let user_search: String = txtSearch.text {
            if user_search != "" {
                params["username"] = user_search
            }
        }
        
        
        if let data:String = General.loadSaved("search_loc_latitude") {
            if data != "" {
                params["lat"] = data
            }
        }
        if let data:String = General.loadSaved("search_loc_longitude") {
            if data != "" {
                params["long"] = data
            }
        }
        if let data:String = General.loadSaved("search_radius") {
            if data != "" {
                params["radious"] = data
            }
        }
        
        if let data:String = General.loadSaved("search_loc_country") {
            if data != "" && data != "," {
                params["lcCountry"] = data
                isLocationFilterApplied = true
            }
        }
        if let data:String = General.loadSaved("search_loc_state") {
            if data != "" && data != "," {
                params["lcState"] = data
                isLocationFilterApplied = true
            }
        }
        if let data:String = General.loadSaved("search_loc_city") {
            if data != "" && data != "," {
                params["lcCity"] = data
                isLocationFilterApplied = true
            }
        }
        
        if let data:String = General.loadSaved("search_home_country") {
            if data != "" && data != "," {
                params["htCountry"] = data
                isLocationFilterApplied = true
            }
        }
        if let data:String = General.loadSaved("search_home_state") {
            if data != "" && data != "," {
                params["htState"] = data
                isLocationFilterApplied = true
            }
        }
        if let data:String = General.loadSaved("search_home_city") {
            if data != "" && data != "," {
                params["htCity"] = data
                isLocationFilterApplied = true
            }
        }
        if let data:String = General.loadSaved("search_age") {
            if data != "" && data != "," {
                params["age_range"] = data
            }
        }
        if let data:String = General.loadSaved("search_ethnicity") {
            if data != "" && data != "," {
                params["ethnicity"] = data
            }
        }
        if let data:String = General.loadSaved("search_language") {
            if data != "" && data != "," {
                params["language"] = data
            }
        }
        if let data:String = General.loadSaved("search_gender") {
            if data != "" && data != "," {
                params["gender"] = data
            }
        }
        if let data:String = General.loadSaved("search_children") {
            if data != "" && data != "," {
                params["children"] = data
            }
        }
        if let data:String = General.loadSaved("search_interest") {
            if data != "" && data != "," {
                params["interest"] = data
            }
        }
        if let data:String = General.loadSaved("search_relationship") {
            if data != "" && data != "," {
                params["relationship"] = data
            }
        }
        if let data:String = General.loadSaved("search_branch_name") {
            if data != "" && data != "," {
                params["branch"] = data
            }
        }
        if let data:String = General.loadSaved("search_paygrade") {
            if data != "" && data != "," {
                params["paygrade"] = data
            }
        }
        if let data:String = General.loadSaved("search_job") {
            if data != "" && data != "," {
                params["job"] = data
            }
        }
        if let data:String = General.loadSaved("search_rank") {
            if data != "" && data != "," {
                params["rank"] = data
            }
        }
        if let data:String = General.loadSaved("search_military_base") {
            if data != "" && data != "," {
                params["militarybase"] = data
            }
        }
        if let data:String = General.loadSaved("search_dependent") {
            if data != "" && data != "," {
                params["dependent"] = data
            }
        }
        
        if let is_paid:String = General.loadSaved("is_paid"){
            params["is_paid"] = is_paid
        }
        print("search params:\(params)")
        if(self.usersList.count==0){
             self.showWaitOverlayWithText("Loading...")
        }
       
      
        isFilterResWSCall = true
        Alamofire.request(.POST, Urls.USERS_LIST, parameters: params)
            .responseJSON { response in
                
                self.removeAllOverlays()
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("search json:\(json)")
                        
                        self.isFilterResWSCall = false
                        /*
                        self.usersList.removeAll()
                        for (_,subJson):(String, SwiftyJSON.JSON) in json {
                            self.usersList.append(Mapper<UsersListModel>().map(subJson.object)!)
                        }*/
                        
                         self.mainTable.tableFooterView = nil
                       
                     let count = json.array?.count
                         print("**search count:\(count)")
                        if(count > 0){
                            
                            for ind in 0...count!-1{
                                let user_id = json[ind]["user_id"].stringValue
                                let user_fullname = json[ind]["user_fullname"].stringValue
                                let user_type = json[ind]["user_type"].stringValue
                                let country = json[ind]["user_loc_country"].stringValue
                                let city = json[ind]["user_loc_city"].stringValue
                                let state  = json[ind]["user_loc_state_abbr"].stringValue
                                let dogtagid = json[ind]["dogtag_batch"].stringValue
                                let is_follower = json[ind]["is_follower"].stringValue
                                let branch_name = json[ind]["user_branch"].stringValue
                                let user_profile_pic = json[ind]["user_profile_pic"].stringValue
                                let abbreviation = json[ind]["user_loc_abbreviation"].stringValue
                                let is_requested = json[ind]["is_requested"].stringValue
                                self.usersList.append(UserListModelNew(user_id: user_id, user_fullname: user_fullname, user_profile_pic: user_profile_pic, user_type: user_type, user_loc_country: country, user_loc_state: state, user_loc_city: city, user_branch: branch_name, is_follower: is_follower, abbrivation: abbreviation, dogtag_batch: dogtagid,is_requested: is_requested)!)
                               
                            }
                        }
                 
                       
                        //MARK: If user is verified then
                        let isVerified = General.loadSaved("verification_pending")
                        if(isVerified == "1"){
                            
                            let search_branch_name = General.loadSaved("search_branch_name")
                            if(search_branch_name != "" && search_branch_name != ","){
                                //MARK: Track user is Verified User Executes Search Using Branch Filter
                                let uid = General.loadSaved("user_id")
                                Mixpanel.mainInstance().identify(distinctId: uid)
                                Mixpanel.mainInstance().track(event: "Branch Search Executed",
                                    properties: ["Branch Search Executed" : "Branch Search Executed"])

                            }
                           
                        }
                        
                        //MARK: If user is verified then
                        if(isVerified == "1"){
                            if(isLocationFilterApplied){
                                //MARK: Track user is Verified User Executes Search Using Current Location Filter
                                let uid = General.loadSaved("user_id")
                                Mixpanel.mainInstance().identify(distinctId: uid)
                                Mixpanel.mainInstance().track(event: "Location Search Executed",
                                    properties: ["Location Search Executed" : "Location Search Executed"])

                            }
                            
                        }
                        
                       // self.view.endEditing(true)
                        self.mainTable.tableFooterView = nil
                        self.mainTable.reloadData()
                        
                        if self.usersList.count == 0 {
                            self.noDataLbl.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2-50)
                            self.noDataLbl.textAlignment = NSTextAlignment.Center
                            self.noDataLbl.text = "No DogTags Matches This Search"
                            self.mainTable.addSubview(self.noDataLbl)
                        } else {
                            self.noDataLbl.removeFromSuperview()
                        }
                    }
                case .Failure(let error):
                     self.mainTable.tableFooterView = nil
                     self.isFilterResWSCall = false
                    GeneralUI.alert(error.localizedDescription)
                    print(error)
                }
        }
        
        }else{
            print("isFilterResWSCall WS already Runing")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        /*if(isSearchTyped){
            return self.filterList.count
        }else{
            return self.usersList.count
        }*/
        
        return self.usersList.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! SearchResultTableViewCell
        
        let user = self.usersList[indexPath.row]
        /*if(isSearchTyped){
            user = self.filterList[indexPath.row]
        }else{
            user = self.usersList[indexPath.row]
        }*/
       
        
        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.width/2
        cell.imgProfilePic.clipsToBounds = true
        cell.lblName.text = user.user_fullname
        
        
        //MARK: - DogTag & Text Color
        let dogId = user.dogtag_batch
        if(dogId == "19"){
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
        
        
        cell.imgDogTag.image = UIImage(named: "\(dogId)\(self.delObj.deviceName)")
        
        
        
        //Flag
        let flagName = user.abbrivation
        if(flagName != ""){
            print("flagName:\(flagName)")
            cell.imgFlag.image = UIImage(named: "\(flagName).png")
        }

        var ur : NSURL = NSURL()
        if(user.user_profile_pic != ""){
            ur  = NSURL(string: Urls.ProfilePic_Base_URL + user.user_profile_pic)!
            cell.imgProfilePic.sd_setImageWithURL(ur, placeholderImage: UIImage(named: "avatar_thumbnail.jpg"), options: SDWebImageOptions.RefreshCached)
        }else{
            cell.imgProfilePic.image = UIImage(named: "avatar_thumbnail.jpg") 
        }
        
        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.height/2
        cell.imgProfilePic.clipsToBounds = true
        
        
        if let userState:String = user.user_loc_state {
            cell.lblLocation.text = userState
            
            if let userCity:String = user.user_loc_city {
                cell.lblLocation.text = userCity + ", " + userState
            }
        }
        cell.followBtnTapped = {
            if let id:String = user.user_id {
                //self.followUser(id, button: cell.btnFollowUn)
                
                if cell.btnFollowUn.titleLabel?.text == "Follow" {
                    //MARK: send follow request
                    let userID = General.loadSaved("user_id")
                    let token = General.loadSaved("user_token")
                    
                    /*let is_paid = General.loadSaved("is_paid")
                    var branch_id : String = String()
                    
                    if(is_paid == "1"){
                        branch_id = ""
                    }else{
                        branch_id = General.loadSaved("branch_id")
                    }
                    */
                    //,"is_paid":is_paid,"branch_id":branch_id
                    
                    let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"follow_id":id]
                    
                    
                    //MARK: Check account is verfied or not
                    let veriStatus = General.loadSaved("verification_pending")
                    if(veriStatus == "1"){
                    //MARK: Web service call
                        self.FollowToUser(params){response in
                        if(response){
                            //Success
                           cell.btnFollowUn.setTitle("Requested", forState: .Normal)
                          cell.btnFollowUn.backgroundColor = UIColor(red: 84.0/255.0, green: 84.0/255.0, blue: 84.0/255.0, alpha: 1.0)
                        }else{
                            //Failure
                            cell.btnFollowUn.setTitle("follow", forState: .Normal)
                        }
                        
                    }
                    }else{
                        GeneralUI.alert(self.delObj.notApprovedMessage)
                    }
                } else {
                    //MARK: Already following send unfollow request
                    let userID = General.loadSaved("user_id")
                    let token = General.loadSaved("user_token")
                    let params: [String: AnyObject] = ["user_id": userID, "token_id": token,"follow_id":id ]
                    
                    //MARK: Web service call
                    self.unfollowFollowingUser(params){response in
                        if(response){
                            //Success
                            cell.btnFollowUn.setTitle("Follow", forState: .Normal)
                            cell.btnFollowUn.backgroundColor = UIColor(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
                        }else{
                            //Failure
                            cell.btnFollowUn.setTitle("Requested", forState: .Normal)
                        }
                        
                    }
                    
                    
                }
            }
        }
        
        print("*** IS Follwer >> \(user.is_follower)")
        
        if user.is_follower.characters.contains("1") {
            cell.btnFollowUn.setTitle("Unfollow", forState: .Normal)
            cell.btnFollowUn.backgroundColor = UIColor(red: 84.0/255.0, green: 84.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        } else {
            
            if(user.is_requested.characters.contains("1")){
                cell.btnFollowUn.setTitle("Requested", forState: .Normal)
                cell.btnFollowUn.backgroundColor = UIColor(red: 84.0/255.0, green: 84.0/255.0, blue: 84.0/255.0, alpha: 1.0)
            }else{
                cell.btnFollowUn.setTitle("Follow", forState: .Normal)
                cell.btnFollowUn.backgroundColor = UIColor(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
            }
           
        }
        
        cell.lblCountry.text = user.user_loc_country
        print(" user.user_type:\( user.user_branch)")
        cell.lblSection.text = user.user_branch
        
        cell.btnOtherProfile.tag = Int(user.user_id)!
        cell.btnOtherProfile.addTarget(self, action: #selector(SearchResultViewController.otherUserProfileClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    //Detect last cell
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastSectionIndex : NSInteger = mainTable.numberOfSections - 1
        let lastRowIndex : NSInteger = mainTable.numberOfRowsInSection(lastSectionIndex) - 1
        if(lastRowIndex > 4){
            if (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex){
                print("You are at last cell")
                
                //Activity Indicator
                
                let spinner : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                spinner.frame = CGRectMake(0, 0, 44, 44)
                spinner.startAnimating()
              
                //Index
                var tmpIndex : String = String()
                if(self.usersList.count>0){
                    tmpIndex = String(self.usersList.count)
                }else{
                    tmpIndex = "0"
                }
               
                //MARK: Web service / API to fetch followers request
                let isFilter = General.loadSaved("isFilterApplied")
                if(isFilter == "0"){
                    //MARK: Filter is NOT applied
                    //loadRandomUsers()
                }else{
                    //MARK: Filter is Applied
                      self.mainTable.tableFooterView = spinner
                    loadUsers(tmpIndex)
                }

                
            }
        }
    }
   
    
    /**
     Unfollow >> Following users
     
     - parameter params: userid, token, following iD
     */
    func unfollowFollowingUser(params: [String: AnyObject], completion : (Bool) -> ()) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls_UI.UNFOLLOW_FOLLOWING, multipartFormData: {
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
                                        completion(false)
                                    } else {
                                        print("You are in successful block")
                                        
                                        completion(true)
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                            self.view.userInteractionEnabled = true
                            completion(false)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    self.view.userInteractionEnabled = true
                    self.cust.hideLoadingCircle()
                    completion(false)
                    print(encodingError)
                }
        })
    }
    
    /**
     Unfollow >> Following users
     
     - parameter params: userid, token, following iD
     */
    func FollowToUser(params: [String: AnyObject], completion : (Bool) -> ()) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls.FOLLOW_USER, multipartFormData: {
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
                                        
                                        //MARK: Check branch type
                                        if(json["message"].stringValue.containsString("You are allowed to follow same branch user only")){
                                            
                                            let uid = General.loadSaved("user_id")
                                            Mixpanel.mainInstance().identify(distinctId: uid)
                                            Mixpanel.mainInstance().track(event: "User prompted to Upgrade",
                                                properties: ["User prompted to Upgrade" : "User prompted to Upgrade"])

                                            
                                            let premAlert = UIAlertController(title: "DogTags", message: self.delObj.notPremiumMessage, preferredStyle: UIAlertControllerStyle.Alert)
                                            premAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                                                //
                                            }))
                                            premAlert.addAction(UIAlertAction(title: "Purchase", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                                                //
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                                let noti = self.storyboard?.instantiateViewControllerWithIdentifier("navUpgrade") as! UINavigationController
                                                self.presentViewController(noti, animated: true, completion: nil)
                                            }))
                                            
                                            self.presentViewController(premAlert, animated: true, completion: nil)
                                            
                                        }else{
                                            GeneralUI.alert(json["message"].stringValue)
                                            
                                            let is_paid = General.loadSaved("is_paid")
                                            if(is_paid == "1"){
                                                let uid = General.loadSaved("user_id")
                                                Mixpanel.mainInstance().identify(distinctId: uid)
                                                Mixpanel.mainInstance().track(event: "Follow Tap",
                                                    properties: ["Follow Tap" : "Follow Tap"])

                                            }
                                        }
                                        
                                        
                                        completion(false)
                                    } else {
                                        print("You are in successful block")
                                        GeneralUI_UI.alert(json["message"].stringValue)
                                        completion(true)
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI_UI.alert(error.localizedDescription)
                            self.view.userInteractionEnabled = true
                            completion(false)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    self.view.userInteractionEnabled = true
                    self.cust.hideLoadingCircle()
                    completion(false)
                    print(encodingError)
                }
        })
    }
    
    @IBAction func searchUserClicked(sender: UIButton) {
        //Index
        var tmpIndex : String = String()
        if(self.usersList.count>0){
            tmpIndex = String(self.usersList.count)
        }else{
            tmpIndex = "0"
        }
        
        loadUsers(tmpIndex)
    }
    
    @IBAction func btnClearResult(sender: AnyObject) {
        self.txtSearch.text = ""
        //Index
        var tmpIndex : String = String()
        if(self.usersList.count>0){
            tmpIndex = String(self.usersList.count)
        }else{
            tmpIndex = "0"
        }
        
        loadUsers(tmpIndex)
    }
    
    //TODO: - UIButton Action
    func otherUserProfileClick(sender:UIButton) {
        //MARK: Check account is verfied or not
        let veriStatus = General.loadSaved("verification_pending")
        if(veriStatus == "1"){
            
        print("other:\(sender.tag)")
        if(usersList.count>0){
            
            let followID = String(sender.tag)
            let userid = General.loadSaved("user_id")
            print("followID:\(followID)")
            if(userid != followID){
                
                let uid = General.loadSaved("user_id")
                Mixpanel.mainInstance().identify(distinctId: uid)
                Mixpanel.mainInstance().track(event: "DogTag Tap",
                                              properties: ["DogTag Tap" : "DogTag Tap"])

                
                
                //IF user selected from typing random name then this metric will be raised
                if(self.txtSearch.text != ""){
                    let uid = General.loadSaved("user_id")
                    Mixpanel.mainInstance().identify(distinctId: uid)
                    Mixpanel.mainInstance().track(event: "Name Execution Search",
                                                  properties: ["Name Execution Search" : "Name Execution Search"])
                }
                
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

    
    func loadRandomUsers() {
        if !isRandomWSCall{
        print("loadRandomUsers")
        
        let userID = General.loadSaved("user_id")
       // let is_paid = General.loadSaved("is_paid")
        /*var branch_id : String = String ()
        
        if(is_paid == "1"){
            branch_id = ""
        }else{
            branch_id = General.loadSaved("branch_id")
        }*/
       //, "is_paid": is_paid,"branch_id":branch_id
        
        
        //Index
       /* var tmpIndex : String = String()
        if(self.usersList.count>0){
            tmpIndex = String(self.usersList.count)
        }else{
            tmpIndex = "0"
        }*/
        
        
        var params = ["user_id": userID]
       
        self.showWaitOverlayWithText("Loading...")
        if let user_search: String = txtSearch.text {
            if user_search != "" {
                params["username"] = user_search
            }
        }
         print("Random search params:\(params)")
        isRandomWSCall = true
        Alamofire.request(.POST, Urls.RANDOM_USERS_LIST, parameters: params)
            .responseJSON { response in
                
                self.removeAllOverlays()
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("loadRandomUsers json:\(json)")
                        
                         self.mainTable.tableFooterView = nil
                        self.isRandomWSCall = false
                        
                        /*
                         self.usersList.removeAll()
                         for (_,subJson):(String, SwiftyJSON.JSON) in json {
                         self.usersList.append(Mapper<UsersListModel>().map(subJson.object)!)
                         }*/
                        
                        let count = json.array?.count
                        if(count > 0){
                           
                            for ind in 0...count!-1{
                                let user_id = json[ind]["user_id"].stringValue
                                let user_fullname = json[ind]["user_fullname"].stringValue
                                let user_type = json[ind]["user_type"].stringValue
                                let country = json[ind]["user_loc_country"].stringValue
                                let city = json[ind]["user_loc_city"].stringValue
                                let state  = json[ind]["user_loc_state_abbr"].stringValue
                                let dogtagid = json[ind]["dogtag_batch"].stringValue
                                let is_follower = json[ind]["is_follower"].stringValue
                                let branch_name = json[ind]["user_branch"].stringValue
                                let user_profile_pic = json[ind]["user_profile_pic"].stringValue
                                let abbreviation = json[ind]["user_loc_abbreviation"].stringValue
                                let is_requested = json[ind]["is_requested"].stringValue
                                
                                self.usersList.append(UserListModelNew(user_id: user_id, user_fullname: user_fullname, user_profile_pic: user_profile_pic, user_type: user_type, user_loc_country: country, user_loc_state: state, user_loc_city: city, user_branch: branch_name, is_follower: is_follower, abbrivation: abbreviation, dogtag_batch: dogtagid,is_requested: is_requested)!)
                                
                            }
                        }
                        
                        //MARK: If user is verified then
                       /* let isVerified = General.loadSaved("verification_pending")
                        if(isVerified == "1"){
                            //MARK: Track user is Verified User Executes Search Using Search Bar
                                //MARK: Track User has created Account
                               
                         Mixpanel.mainInstance().track(event: "Search Executed",
                         properties: ["Search Executed" : "Search Executed"])

                        }*/
                        
                        
                        
                       // self.view.endEditing(true)
                        self.mainTable.reloadData()
                        
                        if self.usersList.count == 0 {
                            self.noDataLbl.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2-50)
                            self.noDataLbl.textAlignment = NSTextAlignment.Center
                            self.noDataLbl.text = "No DogTags Matches This Search"
                            self.mainTable.addSubview(self.noDataLbl)
                        } else {
                            self.noDataLbl.removeFromSuperview()
                        }
                    }
                case .Failure(let error):
                     self.mainTable.tableFooterView = nil
                     self.isRandomWSCall = false
                    GeneralUI.alert(error.localizedDescription)
                    print(error)
                }
        }
        }else{
            print("WS is already called")
        }
        
    }
    
    
    @IBAction func btnFilterClick(sender: AnyObject) {
        
        //MARK: Clear all filter value
        General.removeSaved("search_user_type")
        General.removeSaved("search_home_country")
        General.removeSaved("search_home_state")
        General.removeSaved("search_home_city")
        General.removeSaved("search_age")
        General.removeSaved("search_ethnicity")
        General.removeSaved("search_language")
        General.removeSaved("search_gender")
        General.removeSaved("search_children")
        General.removeSaved("search_interest")
        General.removeSaved("search_relationship")
        General.removeSaved("search_branch_name")
        General.removeSaved("search_military_base")
        General.removeSaved("search_rank")
        General.removeSaved("search_job")
        General.removeSaved("search_paygrade")
        General.removeSaved("search_dependent")
        General.removeSaved("search_loc_country")
        General.removeSaved("search_loc_state")
        General.removeSaved("search_loc_city")
        
        General.removeSaved("search_loc_latitude")
        General.removeSaved("search_loc_longitude")
        General.removeSaved("search_radius")
        //MARK: Clear filter
        General.saveData("0", name: "isFilterApplied")
    }
    
    
}