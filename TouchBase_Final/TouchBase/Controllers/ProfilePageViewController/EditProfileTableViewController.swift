//
//  EditProfileTableViewController.swift
//  DogTags
//
//  Created by vijay kumar on 28/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
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

class EditProfileTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,KACircleCropViewControllerDelegate {
    
    //TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var returnKeyHandler : IQKeyboardReturnKeyHandler = IQKeyboardReturnKeyHandler()
    var croppingEnabled: Bool = true
    var libraryEnabled: Bool = true
    
    
    let shadowRadious : Float = 10
    let shadowAlpha : Float = 0.04
    
    var leftImageFrame = CGRect()
    
    @IBOutlet weak var btnWifeHeight: NSLayoutConstraint!
    @IBOutlet weak var btnHusbandHeight: NSLayoutConstraint!
    
    //TODO: - Controls
    
    @IBOutlet weak var milBaseHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var milStatusView: UIView!    
    @IBOutlet weak var depStatusView: UIView!
    
    
    //2
    @IBOutlet weak var lblProfileType: UILabel!
    @IBOutlet weak var switchOutlet: UISwitch!
    
    //1
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    //3
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    
    //4
    @IBOutlet weak var txtEmailAddress: UITextField!
    
    
    //5
    @IBOutlet weak var btnUserTypeOutlet: UIButton!
    
    
    //HomeTown Controls
    
    @IBOutlet weak var btnHomeTownCountry: UIButton!
    @IBOutlet weak var btnHomeTownState: UIButton!
    @IBOutlet weak var btnHomeTownCity: UIButton!
    
    var utype: String!
    
    
    //Location Controls
    
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnDateOfBirth: UIButton!
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var btnEthnicity: UIButton!
    @IBOutlet weak var btnLanguage: UIButton!
    @IBOutlet weak var btnBranch: UIButton!
    @IBOutlet weak var btnMilitryBase: UIButton!
    @IBOutlet weak var btnPaygrade: UIButton!
    @IBOutlet weak var btnRank: UIButton!
    @IBOutlet weak var btnJob: UIButton!
    @IBOutlet weak var btnRelationship: UIButton!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    // Models
    var userTypes = [UserTypeModel]()
    var countries = [CountryListModel]()
    var statesHome = [StatesListModel]()
    var citiesHome = [CityListModel]()
    var states = [StatesListModel]()
    var cities = [CityListModel]()
    var genders = [GenderListModel]()
    var ethnicities = [EthnicityListModel]()
    var branches = [BranchListModel]()
    var militaryBases = [MilitaryBaseListModel]()
    var paygradeActives = [PaygradeListModel]()
    var relationships = [RelationshipListModel]()
    var languages = [LanguagesListModel]()
    var jobs = [JobListModel]()
    var ranks = [RankListModel]()
    
    // Dropdowns
    let userTypeDropDown = DropDown()
    let homeCountryDropDown = DropDown()
    let homeStateDropDown = DropDown()
    let homeCityDropDown = DropDown()
    let countryDropDown = DropDown()
    let stateDropDown = DropDown()
    let cityDropDown = DropDown()
    let genderDropDown = DropDown()
    let ethnicityDropDown = DropDown()
    let branchesDropDown = DropDown()
    let militaryBaseDropDown = DropDown()
    let paygradeActivesDropDown = DropDown()
    let relationshipDropDown = DropDown()
    let languageDropDown = DropDown()
    let jobsDropDown = DropDown()
    let ranksDropDown = DropDown()
    
    // Selected index
    var userTypeSelected: Int = -1
    var homeCountrySelected: Int = -1
    var homeStateSelected: Int = -1
    var homeCitySelected: Int = -1
    var countrySelected: Int = -1
    var stateSelected: Int = -1
    var citySelected: Int = -1
    var genderSelected: Int = -1
    var ethnicitySelected: Int = -1
    var branchesSelected: Int = -1
    var militaryBaseSelected: Int = -1
    var paygradeActiveSelected: Int = -1
    var relationshipSelected: Int = -1
    var languageSelected: Int = -1
    var jobSelected: Int = -1
    var rankSelected: Int = -1
    
    @IBOutlet weak var btnStatusActive: DLRadioButton!
    @IBOutlet weak var btnStatusReserves: DLRadioButton!
    @IBOutlet weak var btnStatusNative: DLRadioButton!
    
    @IBOutlet weak var btnHasChildYes: DLRadioButton!
    @IBOutlet weak var btnHasChildNo: DLRadioButton!
    @IBOutlet weak var btnIntrestMale: DLRadioButton!
    @IBOutlet weak var btnIntrestFemale: DLRadioButton!
    
    @IBOutlet var radioButton: [DLRadioButton]!
    
    var lockFields = ["", "type_islocked",
                      "ht_country_islocked",
                      "ht_state_islocked",
                      "ht_city_islocked",
                      "loc_country_islocked",
                      "loc_state_islocked",
                      "loc_city_islocked",
                      "birth_date_islocked",
                      "gender_islocked",
                      "ethnicity_islocked",
                      "language_islocked",
                      "branch_islocked",
                      "military_base_islocked",
                      "paygrade_islocked",
                      "rank_islocked",
                      "job_islocked",
                      "relationship_islocked"]
    
    var userid: String!
    var userType: String = "1"
    var serviceStatus: String = "active"
    var htCountry: String = ""
    var htState: String = ""
    var htCity: String = ""
    var locCountry: String = ""
    var locState: String = ""
    var locCity: String = ""
    var milBase: String = ""
    var birthDate: String = ""
    var gender: String = ""
    var ethnicity: String = ""
    var language: String = ""
    var branch: String = ""
    var branchStart: String = ""
    var userTypeStart: String = ""
    var paygrade: String = ""
    var rank: String = ""
    var job: String = ""
    var hasChild: String = "no"
    var interest: String = ""
    var relationship: String = ""
    var dependantStatus: String = ""
    var userDevice: String = "iphone"
    //var deviceNumber: String = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    let cache = Shared.stringCache
    let formatter = NSDateFormatter()
    var profileDetails = [ProfileValueModel]()
    
    var picker = UIImagePickerController()
    var userAvatar: UIImage!
    
    @IBOutlet weak var viewStatus1: NSLayoutConstraint!
    @IBOutlet weak var viewStatus2: NSLayoutConstraint!
    @IBOutlet weak var viewRankHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRankJob: UIView!
    
    @IBOutlet weak var btnStatusSpouse: DLRadioButton!
    @IBOutlet weak var btnStatusWife: DLRadioButton!
    @IBOutlet weak var btnStatusHusband: DLRadioButton!
    @IBOutlet weak var btnStatusChild: DLRadioButton!
    @IBOutlet weak var btnStatusOther: DLRadioButton!
    
    //TODO: - Let's Code
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //self.imgProfilePic.image = UIImage(named: "prof3.jpg")
        
        self.imgProfilePic.image = UIImage(named: "img_profile-pic-upload\(self.delObj.deviceName)")
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width/2
        self.imgProfilePic.clipsToBounds = true
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        btnStatusActive.selected = true
        //btnHasChildYes.selected = false
        btnHasChildYes.selected = true
        
        btnIntrestMale.multipleSelectionEnabled = true
        btnIntrestFemale.multipleSelectionEnabled = true
        
        for button in radioButton as [DLRadioButton] {
            button.multipleSelectionEnabled = true
        }
        
        
        loadProfileDetails()
        
        self.txtEmailAddress.delegate = self
        self.txtLastName.delegate = self
        self.txtFirstName.delegate = self
        resetSpouse()
    }
    
    

    
    func loadProfileDetails() {
        
        let userId = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
        self.showWaitOverlayWithText("Please wait...")
        Alamofire.request(.POST, Urls.PROFILE_VIEW, parameters: ["user_id":userId, "token_id":token])
            .responseJSON { response in
                
                self.removeAllOverlays()
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                        let json = JSON(value)
                        print("edit profile JSON:\(json)")
                        /*if let user_id: String = json["user_id"].string! {
                         self.profileDetails.append(ProfileValueModel(name: "user_id", detail: user_id, lock: "0")!)
                         }*/
                        if let user_profile_pic = json[0]["user_profile_pic"].string {
                            
                            self.imgProfilePic.hnk_setImageFromURL(NSURL(string: Urls.ProfilePic_Base_URL + user_profile_pic)!)
                        }
                        
                        if let value = json[0]["user_ispublic"].string {
                            if value == "0" {
                                self.switchOutlet.on = true
                            } else {
                                self.switchOutlet.on = false
                            }
                        }
                        if let value = json[0]["user_firstname"].string {
                            self.txtFirstName.text = value
                        }
                        if let value = json[0]["user_lastname"].string {
                            self.txtLastName.text = value
                        }
                        
                        if let user_email = json[0]["user_email"].string {
                            self.profileDetails.append(ProfileValueModel(name: "Email Address", detail: user_email, lock: "0")!)
                            self.txtEmailAddress.text = user_email
                        }
                        
                        var i = 1
                        for name in self.lockFields {
                            if let value = json[0][name].string {
                                if value == "1" {
                                    self.radioButton.sortedArrayByTag()[(i-1)].selected = false
                                }
                                i += 1
                            }
                        }
                        
                        print(json[0])
                        
                        if let value = json[0]["user_service_status"].string {
                            self.serviceStatus = value
                            
                            if value == "Active" {
                                self.btnStatusActive.selected = true
                            } else if value == "Reservist" {
                                self.btnStatusReserves.selected = true
                            } else if value == "National Guard" {
                                self.btnStatusNative.selected = true
                            }
                        }
                        
                        if let value = json[0]["dependent"].string {
                            self.dependantStatus = value
                            
                            if value.lowercaseString.containsString("spouse") {
                                self.btnStatusSpouse.selected = true
                                
                                if value.lowercaseString.containsString("husband") {
                                    self.btnStatusHusband.selected = true
                                } else if value.lowercaseString.containsString("wife") {
                                    self.btnStatusWife.selected = true
                                }
                                self.expendSpouse()
                            } else if value.lowercaseString.containsString("child") {
                                self.btnStatusChild.selected = true
                            } else if value.lowercaseString.containsString("other") {
                                self.btnStatusOther.selected = true
                            }
                        }
                        
                        if let value = json[0]["user_has_children"].string {
                            self.serviceStatus = value
                            print(value)
                            
                            if self.btnHasChildYes.selected {
                                self.btnHasChildYes.selected = false
                            }
                            if self.btnHasChildNo.selected {
                                self.btnHasChildNo.selected = false
                            }
                            
                            if value.lowercaseString != "yes" {
                                self.btnHasChildNo.selected = true
                                
                            } else {
                                self.btnHasChildYes.selected = true
                            }
                        }
                        
                        if let value = json[0]["user_typeid"].string {
                            self.userType = value
                        }
                        
                        if let value = json[0]["user_ht_countryid"].string {
                            self.htCountry = value
                        }
                        if let value = json[0]["user_ht_stateid"].string {
                            self.htState = value
                        }
                        if let value = json[0]["user_ht_cityid"].string {
                            self.htCity = value
                        }
                        
                        if let value = json[0]["user_loc_countryid"].string {
                            self.locCountry = value
                        }
                        if let value = json[0]["user_loc_stateid"].string {
                            self.locState = value
                        }
                        if let value = json[0]["user_loc_cityid"].string {
                            self.locCity = value
                        }
                        
                        if let value = json[0]["user_paygradeid"].string {
                            self.paygrade = value
                        }
                        if let value = json[0]["user_ethnicityid"].string {
                            self.ethnicity = value
                        }
                        if let value = json[0]["user_genderid"].string {
                            self.gender = value
                        }
                        if let value = json[0]["user_rankid"].string {
                            self.rank = value
                        }
                        if let value = json[0]["user_jobid"].string {
                            self.job = value
                        }
                        if let value = json[0]["user_branchid"].string {
                            self.branch = value
                            self.branchStart = value
                        }
                        if let value = json[0]["user_military_baseid"].string {
                            self.milBase = value
                            if(value == "0"){
                                self.btnMilitryBase.userInteractionEnabled = false
                                self.btnMilitryBase.alpha = 0.4
                                
                            }
                        }
                        if let value = json[0]["user_relationshipid"].string {
                            self.relationship = value
                        }
                        if let value = json[0]["user_languageid"].string {
                            self.language = value
                        }
                        if let value = json[0]["user_birth_date"].string {
                            self.birthDate = value
                            self.btnDateOfBirth.setTitle(value, forState: .Normal)
                        }
                        
                        if var value = json[0]["user_interest"].string {
                            self.interest = value.lowercaseString
                            
                            if self.btnIntrestFemale.selected {
                                self.btnIntrestFemale.selected = false
                            }
                            if self.btnIntrestMale.selected {
                                self.btnIntrestMale.selected = false
                            }
                            
                           if value.lowercaseString.containsString("female") {
                                if !self.btnIntrestFemale.selected {
                                    self.btnIntrestFemale.selected = true
                                }
                            }
                            
                            value = value.lowercaseString.stringByReplacingOccurrencesOfString("female", withString: "")
                            if value.lowercaseString.containsString("male") {
                                if !self.btnIntrestMale.selected {
                                    self.btnIntrestMale.selected = true
                                }
                            }
                        }
                        
                        self.loadUserType()
                        self.loadCountries()
                        self.loadGender()
                        self.loadEthnicity()
                        self.loadBranch()
                        self.loadRelationship()
                        self.loadLanguages()
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    print(error)
                }
        }
        
    }
    
    func lockField(position: Int, value: String) {
        
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
        let params = ["user_id":userID, "token_id":token, "field_name": lockFields[position]]
        print(params)
        Alamofire.request(.POST, Urls.PROFILE_LOCK_FIELD, parameters: params)
            .responseString { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                        let json = JSON(value)
                        print(json)
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    print(error)
                }
        }
    }
    
    func lockProfile(value: String) {
        
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        
        let params = ["user_id":userID, "token_id":token, "is_public": value]
        
        Alamofire.request(.POST, Urls.PROFILE_PUBLIC_PRIVATE, parameters: params)
            .responseString { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                        let json = JSON(value)
                        print(json)
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    print(error)
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initialization() {
        leftImageFrame = CGRectMake(0, 0, 30, 20)
        
        //1
        txtFirstName.leftViewMode = UITextFieldViewMode.Always
        let FirstImageView = UIImageView(frame: leftImageFrame)
        var FirstImage = UIImage()
        FirstImageView.contentMode = .Center
        
        FirstImage = UIImage(named: "img_name-inpt\(self.delObj.deviceName)")!
        FirstImageView.image = FirstImage
        txtFirstName.leftView = FirstImageView
        //2
        txtLastName.leftViewMode = UITextFieldViewMode.Always
        let lastImageView = UIImageView(frame: leftImageFrame)
        var LastImage = UIImage()
        lastImageView.contentMode = .Center
        
        LastImage = UIImage(named: "img_name-inpt\(self.delObj.deviceName)")!
        lastImageView.image = LastImage
        txtLastName.leftView = lastImageView
        
        //3
        txtEmailAddress.leftViewMode = UITextFieldViewMode.Always
        let EmailImageView = UIImageView(frame: leftImageFrame)
        var EmailImage = UIImage()
        EmailImageView.contentMode = .Center
        
        EmailImage = UIImage(named: "img_email-id-prof\(self.delObj.deviceName)")!
        EmailImageView.image = EmailImage
        txtEmailAddress.leftView = EmailImageView
        
        txtFirstName.autocapitalizationType = .Words
        txtLastName.autocapitalizationType = .Words
        
    }
    
    @IBAction func profileTypeChange(sender: AnyObject) {
        if(switchOutlet.on){
            self.lblProfileType.text = "Public"
            lockProfile("0")
        }else{
            self.lblProfileType.text = "Private"
            lockProfile("1")
        }
    }
    
    //TODO: - Web service / API implementation
    func loadUserType() {
        
        cache.fetch(key: Urls.LIST_USER_TYPE).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            print(json)
            self.userTypes.removeAll()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.userTypes.append(Mapper<UserTypeModel>().map(subJson.object)!)
            }
            self.setupUsertypeDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_USER_TYPE)
                    .responseJSON { response in
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_USER_TYPE)
                                }
                                
                                self.userTypes.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    self.userTypes.append(Mapper<UserTypeModel>().map(subJson.object)!)
                                }
                                self.setupUsertypeDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupUsertypeDropdowns() {
        
        if self.userTypes.count != 0 {
            
            userTypeDropDown.dataSource.removeAll()
            for index in 1...self.userTypes.count {
                userTypeDropDown.dataSource.append(self.userTypes[index-1].user_type!.capitalizedString)
                
                if self.userTypes[index-1].id == userType {
                    self.userTypeSelected = index-1
                    self.btnUserTypeOutlet.setTitle(self.userTypes[index-1].user_type, forState: .Normal)
                    self.userTypeStart = self.userTypes[index-1].user_type!
                    if index == 2 {
                        self.viewStatus1.constant = 0.0
                        self.viewStatus2.constant = 250.0 //180.0
                        self.viewRankHeight.constant = 0.0
                        
                        self.view.layoutIfNeeded()
                    } else {
                        self.viewStatus1.constant = 50.0
                        self.viewStatus2.constant = 0.0
                        self.viewRankHeight.constant = 127.0
                        
                        self.view.layoutIfNeeded()
                    }
                }
            }
            
            if self.userTypeSelected != -1 {
                userTypeDropDown.selectRowAtIndex(self.userTypeSelected)
            }
            userTypeDropDown.anchorView = self.btnUserTypeOutlet
            
            userTypeDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnUserTypeOutlet.setTitle(item, forState: .Normal)
                self.userTypeStart = item
                self.userTypeSelected = index
                self.userType = self.userTypes[index].id!
                
                if index == 1 {
                    self.viewStatus1.constant = 0.0
                    self.viewStatus2.constant = 180.0
                    self.viewRankHeight.constant = 0.0
                    
                    self.view.layoutIfNeeded()
                } else {
                    self.viewStatus1.constant = 50.0
                    self.viewStatus2.constant = 0.0
                    self.viewRankHeight.constant = 127.0
                    
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadCountries() {
        
        self.showWaitOverlayWithText("Loading Country ...")
        cache.fetch(key: Urls.LIST_COUNTRY).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.countries.removeAll()
            self.removeAllOverlays()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.countries.append(Mapper<CountryListModel>().map(subJson.object)!)
            }
            self.setupHomeCountryDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_COUNTRY)
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_COUNTRY)
                                }
                                
                                self.countries.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    self.countries.append(Mapper<CountryListModel>().map(subJson.object)!)
                                }
                                self.setupHomeCountryDropdowns()
                                
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupHomeCountryDropdowns() {
        
        if self.countries.count != 0 {
            homeCountryDropDown.dataSource.removeAll()
            // Home
            for index in 1...self.countries.count {
                homeCountryDropDown.dataSource.append(self.countries[index-1].country!.capitalizedString)
                
                if self.countries[index-1].id == htCountry {
                    self.homeCountrySelected = index-1
                    self.btnHomeTownCountry.setTitle(self.countries[index-1].country, forState: .Normal)
                    
                    self.loadHomeStates(self.countries[index-1].id!, name: self.countries[index-1].country!)
                }
            }
            
            if self.homeCountrySelected != -1 {
                homeCountryDropDown.selectRowAtIndex(self.homeCountrySelected)
            }
            homeCountryDropDown.anchorView = self.btnHomeTownCountry
            
            homeCountryDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnHomeTownCountry.setTitle(item, forState: .Normal)
                self.homeCountrySelected = index
                
                self.btnHomeTownState.setTitle("State", forState: .Normal)
                self.homeStateSelected = -1
                self.btnHomeTownCity.setTitle("City", forState: .Normal)
                self.homeCitySelected = -1
                
                self.loadHomeStates(self.countries[index].id!, name: self.countries[index].country!)
                self.htCountry = self.countries[index].id!
                self.htState = ""
                self.htCity = ""
            }
            
            countryDropDown.dataSource.removeAll()
            // Location
            for index in 1...self.countries.count {
                countryDropDown.dataSource.append(self.countries[index-1].country!.capitalizedString)
                
                if self.countries[index-1].id == locCountry {
                    self.btnCountry.setTitle(self.countries[index-1].country, forState: .Normal)
                    self.countrySelected = index-1
                    
                    self.loadStates(self.countries[index-1].id!, name: self.countries[index-1].country!)
                }
            }
            
            if self.countrySelected != -1 {
                countryDropDown.selectRowAtIndex(self.countrySelected)
            }
            countryDropDown.anchorView = self.btnCountry
            
            countryDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnCountry.setTitle(item, forState: .Normal)
                self.countrySelected = index
                
                self.btnState.setTitle("State", forState: .Normal)
                self.stateSelected = 0
                self.btnCity.setTitle("City", forState: .Normal)
                self.citySelected = 0
                
                self.loadStates(self.countries[index].id!, name: self.countries[index].country!)
                self.locCountry = self.countries[index].id!
                self.locState = ""
                self.locCity = ""
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadHomeStates(countryid: String, name: String) {
        
        self.showWaitOverlayWithText("Loading states in \(name) ...")
        cache.fetch(key: Urls.LIST_STATES + countryid).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.statesHome.removeAll()
            self.removeAllOverlays()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.statesHome.append(Mapper<StatesListModel>().map(subJson.object)!)
            }
            self.setupHomeStateDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_STATES, parameters: ["countryid": countryid])
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_STATES + countryid)
                                }
                                
                                self.statesHome.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    self.statesHome.append(Mapper<StatesListModel>().map(subJson.object)!)
                                }
                                self.setupHomeStateDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupHomeStateDropdowns() {
        
        if self.statesHome.count != 0 {
            homeStateDropDown.dataSource.removeAll()
            // Home
            for index in 1...self.statesHome.count {
                homeStateDropDown.dataSource.append(self.statesHome[index-1].state!.capitalizedString)
                
                if self.statesHome[index-1].id == htState {
                    self.btnHomeTownState.setTitle(self.statesHome[index-1].state, forState: .Normal)
                    self.homeStateSelected = index-1
                    print(self.statesHome[index-1].state, self.statesHome[index-1].id, htState)
                    
                    self.loadHomeCities(self.statesHome[index-1].id!, name: self.statesHome[index-1].state!)
                }
            }
            if self.homeStateSelected != -1 {
                homeStateDropDown.selectRowAtIndex(self.homeStateSelected)
            }
            homeStateDropDown.anchorView = self.btnHomeTownState
            
            homeStateDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnHomeTownState.setTitle(item, forState: .Normal)
                self.homeStateSelected = index
                
                self.btnHomeTownCity.setTitle("City", forState: .Normal)
                self.homeCitySelected = -1
                self.loadHomeCities(self.statesHome[index].id!, name: self.statesHome[index].state!)
                
                self.htState = self.statesHome[index].id!
                self.htCity = ""
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadStates(countryid: String, name: String) {
        
        
        self.showWaitOverlayWithText("Loading states in \(name) ...")
        cache.fetch(key: Urls.LIST_STATES + countryid).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.states.removeAll()
            self.removeAllOverlays()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.states.append(Mapper<StatesListModel>().map(subJson.object)!)
            }
            self.setupStateDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_STATES, parameters: ["countryid": countryid])
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                print(json)
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_STATES + countryid)
                                }
                                
                                self.states.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    self.states.append(Mapper<StatesListModel>().map(subJson.object)!)
                                }
                                self.setupStateDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupStateDropdowns() {
        
        if self.states.count != 0 {
            stateDropDown.dataSource.removeAll()
            // Home
            for index in 1...self.states.count {
                stateDropDown.dataSource.append(self.states[index-1].state!.capitalizedString)
                
                if self.states[index-1].id == locState {
                    self.btnState.setTitle(self.states[index-1].state, forState: .Normal)
                    self.stateSelected = index-1
                    
                    self.loadCities(self.states[index-1].id!, name: self.states[index-1].state!)
                    
                    self.btnMilitryBase.setTitle("Military Base", forState: .Normal)
                    self.loadMilitaryBase()
                }
            }
            
            if self.stateSelected != -1 {
                stateDropDown.selectRowAtIndex(self.stateSelected)
            }
            stateDropDown.anchorView = self.btnState
            
            stateDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnState.setTitle(item, forState: .Normal)
                self.stateSelected = index
                
                self.btnCity.setTitle("City", forState: .Normal)
                self.citySelected = -1
                self.loadCities(self.states[index].id!, name: self.states[index].state!)
                
                self.locState = self.states[index].id!
                self.locCity = ""
                
                
                self.milBase = ""
                self.btnMilitryBase.setTitle("Military Base", forState: .Normal)
                self.militaryBaseSelected = 0
                self.loadMilitaryBase()
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadHomeCities(stateid: String, name: String) {
        
        self.showWaitOverlayWithText("Loading cities in \n\(name)")
        cache.fetch(key: Urls.LIST_CITIES + stateid).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.citiesHome.removeAll()
            self.removeAllOverlays()
            
            if let message = json["message"].string {
                GeneralUI.alert(message)
            } else {
                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                    self.citiesHome.append(Mapper<CityListModel>().map(subJson.object)!)
                }
            }
            self.setupHomeCityDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_CITIES, parameters: ["stateid": stateid])
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_CITIES + stateid)
                                }
                                
                                self.citiesHome.removeAll()
                                
                                if let message = json["message"].string {
                                    GeneralUI.alert(message)
                                } else {
                                    for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                        self.citiesHome.append(Mapper<CityListModel>().map(subJson.object)!)
                                    }
                                }
                                self.setupHomeCityDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupHomeCityDropdowns() {
        
        if self.citiesHome.count != 0 {
            
            homeCityDropDown.dataSource.removeAll()
            for index in 1...self.citiesHome.count {
                homeCityDropDown.dataSource.append(self.citiesHome[index-1].city.capitalizedString)
                
                if self.citiesHome[index-1].id == htCity {
                    self.btnHomeTownCity.setTitle(self.citiesHome[index-1].city, forState: .Normal)
                    self.homeCitySelected = index-1
                }
            }
            
            if self.homeCitySelected != -1 {
                homeCityDropDown.selectRowAtIndex(self.homeCitySelected)
            }
            homeCityDropDown.anchorView = self.btnHomeTownCity
            
            homeCityDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnHomeTownCity.setTitle(item, forState: .Normal)
                self.homeCitySelected = index
                
                self.htCity = self.citiesHome[index].id!
                
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadCities(stateid: String, name: String) {
        
        self.showWaitOverlayWithText("Loading cities in \(name) ...")
        cache.fetch(key: Urls.LIST_CITIES + stateid).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.cities.removeAll()
            self.removeAllOverlays()
            
            if let message = json["message"].string {
                GeneralUI.alert(message)
            } else {
                self.cities.removeAll()
                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                    self.cities.append(Mapper<CityListModel>().map(subJson.object)!)
                }
                self.setupCityDropdowns()
            }
            
            self.setupCityDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_CITIES, parameters: ["stateid": stateid])
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_CITIES + stateid)
                                }
                                
                                if let message = json["message"].string {
                                    GeneralUI.alert(message)
                                } else {
                                    self.cities.removeAll()
                                    for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                        self.cities.append(Mapper<CityListModel>().map(subJson.object)!)
                                    }
                                    self.setupCityDropdowns()
                                }
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupCityDropdowns() {
        
        if self.cities.count != 0 {
            
            cityDropDown.dataSource.removeAll()
            for index in 1...self.cities.count {
                cityDropDown.dataSource.append(self.cities[index-1].city.capitalizedString)
                
                if self.cities[index-1].id == locCity {
                    self.btnCity.setTitle(self.cities[index-1].city, forState: .Normal)
                    self.citySelected = index-1
                }
            }
            
            if self.citySelected != -1 {
                cityDropDown.selectRowAtIndex(self.citySelected)
            }
            cityDropDown.anchorView = self.btnCity
            
            cityDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnCity.setTitle(item, forState: .Normal)
                self.citySelected = index
                
                self.locCity = self.cities[index].id!
                
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadGender() {
        
        cache.fetch(key: Urls.LIST_GENDER).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.genders.removeAll()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.genders.append(Mapper<GenderListModel>().map(subJson.object)!)
            }
            self.setupGenderDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_GENDER)
                    .responseJSON { response in
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_GENDER)
                                }
                                
                                self.genders.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    self.genders.append(Mapper<GenderListModel>().map(subJson.object)!)
                                }
                                self.setupGenderDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                        }
                }
        }
    }
    
    func setupGenderDropdowns() {
        
        if self.genders.count != 0 {
            
            genderDropDown.dataSource.removeAll()
            for index in 1...self.genders.count {
                genderDropDown.dataSource.append(self.genders[index-1].gender!.capitalizedString)
                
                if self.genders[index-1].id == gender {
                    self.btnGender.setTitle(self.genders[index-1].gender, forState: .Normal)
                    self.genderSelected = index-1
                }
            }
            
            if self.genderSelected != -1 {
                genderDropDown.selectRowAtIndex(self.genderSelected)
            }
            genderDropDown.anchorView = self.btnGender
            
            genderDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnGender.setTitle(item, forState: .Normal)
                self.genderSelected = index
                
                self.gender = self.genders[index].id!
                
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    
    func loadEthnicity() {
        
        cache.fetch(key: Urls.LIST_ETHNICITY).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.ethnicities.removeAll()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.ethnicities.append(Mapper<EthnicityListModel>().map(subJson.object)!)
            }
            self.setupEthnicityDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_ETHNICITY)
                    .responseJSON { response in
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_ETHNICITY)
                                }
                                
                                self.ethnicities.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    self.ethnicities.append(Mapper<EthnicityListModel>().map(subJson.object)!)
                                }
                                self.setupEthnicityDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupEthnicityDropdowns() {
        
        if self.ethnicities.count != 0 {
            
            ethnicityDropDown.dataSource.removeAll()
            for index in 1...self.ethnicities.count {
                ethnicityDropDown.dataSource.append(self.ethnicities[index-1].ethnicity!.capitalizedString)
                
                if self.ethnicities[index-1].id == ethnicity {
                    self.btnEthnicity.setTitle(self.ethnicities[index-1].ethnicity, forState: .Normal)
                    self.ethnicitySelected = index-1
                }
            }
            
            if self.ethnicitySelected != -1 {
                ethnicityDropDown.selectRowAtIndex(self.ethnicitySelected)
            }
            ethnicityDropDown.anchorView = self.btnEthnicity
            
            ethnicityDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnEthnicity.setTitle(item, forState: .Normal)
                self.ethnicitySelected = index
                
                self.ethnicity = self.ethnicities[index].id!
                
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    
    func loadBranch() {
        
        cache.fetch(key: Urls.LIST_BRANCH).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.branches.removeAll()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.branches.append(Mapper<BranchListModel>().map(subJson.object)!)
            }
            self.setupBranchDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_BRANCH)
                    .responseJSON { response in
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_BRANCH)
                                }
                                
                                self.branches.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    self.branches.append(Mapper<BranchListModel>().map(subJson.object)!)
                                }
                                self.setupBranchDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupBranchDropdowns() {
        
        if self.branches.count != 0 {
            
            branchesDropDown.dataSource.removeAll()
            for index in 1...self.branches.count {
                branchesDropDown.dataSource.append(self.branches[index-1].branch_name!.capitalizedString)
                
                if self.branches[index-1].id == branch {
                    self.btnBranch.setTitle(self.branches[index-1].branch_name, forState: .Normal)
                    self.branchesSelected = index-1
                    
                    self.loadPaygardeActive(self.branches[index-1].id!, name: self.branches[index-1].branch_name!)
                }
            }
            
            if self.branchesSelected != -1 {
                branchesDropDown.selectRowAtIndex(self.branchesSelected)
            }
            branchesDropDown.anchorView = self.btnBranch
            
            branchesDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnBranch.setTitle(item, forState: .Normal)
                self.branchesSelected = index
                
                self.branch = self.branches[index].id!
                self.paygrade = ""
                
                self.btnPaygrade.setTitle("Paygrade", forState: .Normal)
                self.paygradeActiveSelected = 0
                
                self.rank = ""
                self.job = ""
                
                self.btnRank.setTitle("Rank", forState: .Normal)
                self.rankSelected = 0
                
                self.btnJob.setTitle("Job", forState: .Normal)
                self.jobSelected = 0
                
                
                print("***id\(self.delObj.user_branchid)")
                 print("***Name\(self.delObj.user_branch)")
                self.loadPaygardeActive(self.delObj.user_branchid, name: self.delObj.user_branch)
                
                //self.loadPaygardeActive(self.branches[index].id!, name: self.branches[index].branch_name!)
                
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    
    func loadMilitaryBase() {
        print(["countryid": self.locCountry, "stateid": self.locState])
        
        self.showWaitOverlayWithText("Loading military base ...")
        cache.fetch(key: Urls.LIST_MILITARY_BASE + self.locCountry + "/" + self.locState).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.militaryBases.removeAll()
            self.removeAllOverlays()
            
            print(json)
            if (json.array != nil) {
                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                    self.militaryBases.append(Mapper<MilitaryBaseListModel>().map(subJson.object)!)
                }
            }
            self.setupMilitaryBaseDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_MILITARY_BASE, parameters: ["countryid": self.locCountry, "stateid": self.locState])
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                print(json)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_MILITARY_BASE + self.locCountry + "/" + self.locState)
                                }
                                
                                self.militaryBases.removeAll()
                                if (json.array != nil) {
                                    for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                        self.militaryBases.append(Mapper<MilitaryBaseListModel>().map(subJson.object)!)
                                    }
                                }
                                self.setupMilitaryBaseDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupMilitaryBaseDropdowns() {
        print(milBase)
        if self.militaryBases.count != 0 {
            militaryBaseDropDown.dataSource.removeAll()
            
            for index in 1...self.militaryBases.count {
                militaryBaseDropDown.dataSource.append(self.militaryBases[index-1].base_name!)
                
                if self.militaryBases[index-1].id == milBase {
                    self.btnMilitryBase.setTitle(self.militaryBases[index-1].base_name, forState: .Normal)
                    self.militaryBaseSelected = index-1
                }
            }
            
            if self.militaryBaseSelected != -1 {
                militaryBaseDropDown.selectRowAtIndex(self.militaryBaseSelected)
            }
            militaryBaseDropDown.anchorView = self.btnMilitryBase
            
            militaryBaseDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnMilitryBase.setTitle(item, forState: .Normal)
                self.militaryBaseSelected = index
                
                self.milBase = self.militaryBases[index].id!
                
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
        
    func loadPaygardeActive(branchid: String, name: String) {
        
        self.showWaitOverlayWithText("Loading paygrades in \(name) ...")
        cache.fetch(key: Urls.LIST_PAYGRADE_ACTIVE + branchid).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.paygradeActives.removeAll()
            self.removeAllOverlays()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.paygradeActives.append(Mapper<PaygradeListModel>().map(subJson.object)!)
            }
            self.setupPaygradeeDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_PAYGRADE_ACTIVE, parameters: ["branchid": branchid])
                    .responseJSON { response in
                        print(response.result)
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_PAYGRADE_ACTIVE + branchid)
                                }
                                
                                self.paygradeActives.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    print(subJson["paygrade"])
                                    self.paygradeActives.append(Mapper<PaygradeListModel>().map(subJson.object)!)
                                }
                                self.setupPaygradeeDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
        
    }
    
    func setupPaygradeeDropdowns() {
        
        if self.paygradeActives.count != 0 {
            
            paygradeActivesDropDown.dataSource.removeAll()
            for index in 1...self.paygradeActives.count {
                paygradeActivesDropDown.dataSource.append(self.paygradeActives[index-1].paygrade!.capitalizedString)
                
                if self.paygradeActives[index-1].id == paygrade {
                    self.btnPaygrade.setTitle(self.paygradeActives[index-1].paygrade, forState: .Normal)
                    self.paygradeActiveSelected = index-1
                    
                    self.loadJobAndRank(self.paygradeActives[index-1].id!, name: self.paygradeActives[index-1].paygrade!)
                }
            }
            
            if self.paygradeActiveSelected != -1 {
                paygradeActivesDropDown.selectRowAtIndex(self.paygradeActiveSelected)
            }
            paygradeActivesDropDown.anchorView = self.btnPaygrade
            
            paygradeActivesDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnPaygrade.setTitle(item, forState: .Normal)
                self.paygradeActiveSelected = index
                
                
                self.paygrade = self.paygradeActives[index].id!
                self.rank = ""
                self.job = ""
                
                self.btnRank.setTitle("Rank", forState: .Normal)
                self.rankSelected = 0
                
                self.btnJob.setTitle("Job", forState: .Normal)
                self.jobSelected = 0
                
                self.loadJobAndRank(self.paygradeActives[index].id!, name: self.paygradeActives[index].paygrade!)
                
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadJobAndRank(paygradeid: String, name: String) {
        
        self.showWaitOverlayWithText("Loading rank & jobs in \(name) ...")
        cache.fetch(key: Urls.LIST_JOB_AND_RANK + paygradeid).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.ranks.removeAll()
            self.jobs.removeAll()
            self.removeAllOverlays()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json["rank"] {
                self.ranks.append(Mapper<RankListModel>().map(subJson.object)!)
            }
            for (_,subJson):(String, SwiftyJSON.JSON) in json["job"] {
                self.jobs.append(Mapper<JobListModel>().map(subJson.object)!)
            }
            self.setupJobAndRankDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_JOB_AND_RANK, parameters: ["paygradeid": paygradeid])
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_JOB_AND_RANK + paygradeid)
                                }
                                
                                self.ranks.removeAll()
                                self.jobs.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json["rank"] {
                                    self.ranks.append(Mapper<RankListModel>().map(subJson.object)!)
                                }
                                for (_,subJson):(String, SwiftyJSON.JSON) in json["job"] {
                                    self.jobs.append(Mapper<JobListModel>().map(subJson.object)!)
                                }
                                self.setupJobAndRankDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupJobAndRankDropdowns() {
        
        if self.jobs.count != 0 {
            // Jobs
            jobsDropDown.dataSource.removeAll()
            
            for index in 1...self.jobs.count {
                jobsDropDown.dataSource.append(self.jobs[index-1].job!)
                
                if self.jobs[index-1].id == job {
                    self.btnJob.setTitle(self.jobs[index-1].job, forState: .Normal)
                    self.jobSelected = index-1
                }
            }
            
            if self.jobSelected != -1 {
                jobsDropDown.selectRowAtIndex(self.jobSelected)
            }
            jobsDropDown.anchorView = self.btnJob
            
            jobsDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnJob.setTitle(item, forState: .Normal)
                self.self.jobSelected = index
                
                self.job = self.jobs[index].id!
            }
            
            
            // Rank
            ranksDropDown.dataSource.removeAll()
            
            for index in 1...self.ranks.count {
                ranksDropDown.dataSource.append(self.ranks[index-1].rank!)
                
                if self.ranks[index-1].id == rank {
                    self.btnRank.setTitle(self.ranks[index-1].rank, forState: .Normal)
                    self.rankSelected = index-1
                }
            }
            
            if self.rankSelected != -1 {
                ranksDropDown.selectRowAtIndex(self.rankSelected)
            }
            ranksDropDown.anchorView = self.btnRank
            
            ranksDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnRank.setTitle(item, forState: .Normal)
                self.rankSelected = index
                
                self.rank = self.ranks[index].id!
                
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadRelationship() {
        
        cache.fetch(key: Urls.LIST_RELATIONSHIP).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.relationships.removeAll()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.relationships.append(Mapper<RelationshipListModel>().map(subJson.object)!)
            }
            self.setupRelationshipDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_RELATIONSHIP)
                    .responseJSON { response in
                        print(response.result)
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_RELATIONSHIP)
                                }
                                
                                self.relationships.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    self.relationships.append(Mapper<RelationshipListModel>().map(subJson.object)!)
                                }
                                self.setupRelationshipDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupRelationshipDropdowns() {
        
        if self.relationships.count != 0 {
            
            relationshipDropDown.dataSource.removeAll()
            for index in 1...self.relationships.count {
                relationshipDropDown.dataSource.append(self.relationships[index-1].relationship!.capitalizedString)
                
                if self.relationships[index-1].id == relationship {
                    self.btnRelationship.setTitle(self.relationships[index-1].relationship, forState: .Normal)
                    self.relationshipSelected = index-1
                }
            }
            
            if self.relationshipSelected != -1 {
                relationshipDropDown.selectRowAtIndex(self.relationshipSelected)
            }
            relationshipDropDown.anchorView = self.btnRelationship
            
            relationshipDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnRelationship.setTitle(item, forState: .Normal)
                self.relationshipSelected = index
                
                self.relationship = self.relationships[index].id!
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadLanguages() {
        
        cache.fetch(key: Urls.LIST_LANGUAGES).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.languages.removeAll()
            
            for (_,subJson):(String, SwiftyJSON.JSON) in json {
                self.languages.append(Mapper<LanguagesListModel>().map(subJson.object)!)
            }
            self.setupLanguageDropdowns()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_LANGUAGES)
                    .responseJSON { response in
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_LANGUAGES)
                                }
                                
                                self.languages.removeAll()
                                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                    self.languages.append(Mapper<LanguagesListModel>().map(subJson.object)!)
                                }
                                self.setupLanguageDropdowns()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    func setupLanguageDropdowns() {
        
        if self.languages.count != 0 {
            
            languageDropDown.dataSource.removeAll()
            for index in 1...self.languages.count {
                languageDropDown.dataSource.append(self.languages[index-1].language!.capitalizedString)
                
                if self.languages[index-1].id == language {
                    self.btnLanguage.setTitle(self.languages[index-1].language, forState: .Normal)
                    self.languageSelected = index-1
                }
            }
            
            if self.languageSelected != -1 {
                languageDropDown.selectRowAtIndex(self.languageSelected)
            }
            languageDropDown.anchorView = self.btnLanguage
            
            languageDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnLanguage.setTitle(item, forState: .Normal)
                self.languageSelected = index
                
                self.language = self.languages[index].id!
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    
    /**
     On submit button post current data
     */
    
    func postData() {
        
        if btnStatusActive.selected {
            serviceStatus = "Active"
        } else if btnStatusReserves.selected {
            serviceStatus = "Reservist"
        } else if btnStatusNative.selected {
            serviceStatus = "National Guard"
        }
        
        if btnHasChildYes.selected {
            hasChild = "yes"
        } else {
            hasChild = "no"
        }
        
        let firstname = txtFirstName.text
        let lastname = txtLastName.text
        let email = txtEmailAddress.text
        
        
        var intrests:String = ""
        if btnIntrestMale.selected {
            intrests = "male"
        }
        if btnIntrestFemale.selected {
            if intrests == "male" {
                intrests = "male,female"
            } else {
                intrests = "female"
            }
        }
        
        dependantStatus = ""
        if btnStatusSpouse.selected {
            dependantStatus += "spouse"
            if btnStatusHusband.selected {
                dependantStatus += ",husband"
            }
            if btnStatusWife.selected {
                dependantStatus += ",wife"
            }
        }
        if btnStatusChild.selected {
            dependantStatus += ",child"
        }
        if btnStatusOther.selected {
            dependantStatus += ",other"
        }
        if dependantStatus.characters.first == "," {
            dependantStatus = String(dependantStatus.characters.dropFirst())
        }
        
        if  GeneralUI.validateBasic(txtFirstName, name: "First name", min: 2) &&
            GeneralUI.validateBasic(txtLastName, name: "Last name", min: 1) &&
            GeneralUI.validateEmail(txtEmailAddress, name: "Email") &&
            validate(htCountry, text: "Hometown Country") && validate(htState, text: "Hometown State") && validate(htCity, text: "Hometown City") &&
            validate(locCountry, text: "Location Country") && validate(locState, text: "Location State")  && validate(locCity, text: "Location City") &&
            validate(birthDate, text: "Date of birth") && validate(gender, text: "Gender") &&
            validate(ethnicity, text: "Ethnicity") &&
            validate(language, text: "Language") && validate(branch, text: "Branch") &&
            validate(intrests, text: "Interested In") {
            
            
            
            let user_id = General.loadSaved("user_id")
            let token = General.loadSaved("user_token")
            var params = ["user_id":user_id, "token_id":token,
                          "userid":user_id,
                          "utype": userType,
                          "userDevice": userDevice,
                          "deviceNumber": ""]
            
            params["ufname"] = firstname
            params["ulname"] = lastname
            params["uemail"] = email
            params["serviceStatus"] = serviceStatus
            params["htCountry"] = htCountry
            params["htState"] = htState
            params["htCity"] = htCity
            params["locCountry"] = locCountry
            params["locState"] = locState
            params["locCity"] = locCity
            
            params["gender"] = gender
            params["ethnicity"] = ethnicity
            params["language"] = language
            params["birthDate"] = birthDate
            
            params["branch"] = branch
            params["milBase"] = milBase
            params["paygrade"] = paygrade
            params["rank"] = rank
            params["job"] = job
            params["hasChild"] = hasChild
            params["relationship"] = relationship
            params["dependantStatus"] = dependantStatus            
            params["interest"] = intrests
            
            var isNeedRank = false            
            if userType != "2" {
                if validate(paygrade, text: "Paygrade") &&
                    validate(rank, text: "Rank") && validate(job, text: "Job") {
                    isNeedRank = true
                }
            } else {
                if validate(dependantStatus, text: "Dependant Status") {
                    isNeedRank = true
                }
            }
            
            if isNeedRank {
                
                self.cust.showLoadingCircle()
                
            Alamofire.request(.POST, Urls.PROFILE_EDIT, parameters: params)
                .responseJSON { response in
                    self.removeAllOverlays()
                    
                    switch response.result {
                    case .Success:
                         self.cust.hideLoadingCircle()
                        if let value = response.result.value {
                            let json = JSON(value)
                            print("JSON: \(json)")
                            
                            
                            if let status = json["status"].string {
                                if status != "0" {
                                    GeneralUI.alert(json["message"].string!)
                                } else {
                                    
                                    //MARK: Updated save here
                                    self.loadMyProfile(true)
                                    
                                    
                                    if self.branch != self.branchStart || self.userType != self.userTypeStart {
                                        let verfiyVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupVerificationOptionViewController") as! SignupVerificationOptionViewController
                                        
                                        verfiyVC.userid = "\(user_id)"
                                        verfiyVC.branchid = self.branch
                                        verfiyVC.needFinish = true
                                        self.navigationController?.pushViewController(verfiyVC, animated: true)
                                    }
                                    self.dismissViewControllerAnimated(false, completion: nil)
                                    
                                    
                                }
                            }
                        }
                    case .Failure(let error):
                        self.cust.hideLoadingCircle()
                        print(error)
                    }
            }
            }
         }
    }
    
    
    func changeInUserType(user_id:String){
        
        //let confAlert = UIAlertController(title: "Do you want to Aaik pan", message: String?, preferredStyle: UIAlertControllerStyle)
        
        let verfiyVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupVerificationOptionViewController") as! SignupVerificationOptionViewController
        
        verfiyVC.userid = "\(user_id)"
        verfiyVC.branchid = branch
        verfiyVC.needFinish = true
        self.navigationController?.pushViewController(verfiyVC, animated: true)
    }
    
    /**
     Web service call to all information related to login user
     */
    func loadMyProfile(isSubmit:Bool) {
        let userID = General.loadSaved("user_id")
        let userToken = General.loadSaved("user_token")
        
        //self.cust.showLoadingCircle()
        
        Alamofire.request(.POST, Urls.PROFILE_VIEW, parameters: ["user_id":userID, "token_id":userToken])
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                        //  self.cust.hideLoadingCircle()
                        
                        let json = JSON(value)
                        print("json for edit profile:\(json)")
                        
                        //MARK: save user info in defaults to access later
                        user_dictonary["user_fullname"] = json[0]["user_fullname"].string!
                        user_dictonary["user_email"] = json[0]["user_email"].string!
                        user_dictonary["user_type"] = json[0]["user_type"].string!
                        user_dictonary["user_loc_city_state"] = json[0]["user_loc_city"].string! + ", " + json[0]["user_loc_state_abbr"].string!
                        user_dictonary["user_loc_country"] = json[0]["user_loc_country"].string!
                        user_dictonary["user_branch"] = json[0]["user_branch"].string!
                        user_dictonary["user_profile_pic"] = json[0]["user_profile_pic"].string!
                        
                        print("user_dictonary:\(user_dictonary)")
                        
                        NSUserDefaults.standardUserDefaults().setObject(user_dictonary, forKey: "user_dictonary")
                        if(isSubmit){
                            //MARK: - if datafetch successful then naviagte back to screen
                            NSNotificationCenter.defaultCenter().postNotificationName("dismissEditProfile", object: nil)
                        }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("updateUserInfo", object: nil)
                        
                    }
                case .Failure(let error):
                    GeneralUI.alert(error.localizedDescription)
                    // self.cust.hideLoadingCircle()
                    print(error)
                }
        }
    }
    
    func validate(value: String, text: String) -> Bool {
        if value == "" {
            let alert = JDropDownAlert()
            alert.alertWith("Please choose \(text)!")
            return false
        }
        return true
    }
    
    func validateMBase(value: String, text: String) -> Bool {
        if value == "" && utype == "1" {
            let alert = JDropDownAlert()
            alert.alertWith("Please choose \(text)!")
            return false
        }
        return true
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initialization()
        
        let shadoView : UIView = UIView()
        shadoView.frame = CGRectMake(0, 0, self.btnHomeTownCity.frame.size.width,  self.btnHomeTownCity.frame.size.height)
        shadoView.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        
        //self.lblTmp.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnHomeTownCity.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnHomeTownState.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnHomeTownCountry.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        
        self.btnCountry.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnState.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnCity.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnMilitryBase.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        //self.btnDateOfBirth.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnGender.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnEthnicity.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnLanguage.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnBranch.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnPaygrade.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnRank.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnJob.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnRelationship.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        
    }
    
    
    
    func uploadPhoto(params: [String: AnyObject]) {
        
        self.view.userInteractionEnabled = false
        print(params)
        self.cust.showLoadingCircle()
        Alamofire.upload(.POST, Urls.PROFILE_EDIT_PHOTO, multipartFormData: {
            multipartFormData in
            
                let filename = GeneralUI_UI.generateRandomImageName()
                if let imageData = UIImageJPEGRepresentation(self.userAvatar, 0.8) {
                    multipartFormData.appendBodyPart(data: imageData, name: "uprofile", fileName: "photo \(filename).jpg", mimeType: "image/jpeg")
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
                        self.removeAllOverlays()
                        self.view.userInteractionEnabled = true
                         self.cust.hideLoadingCircle()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                print("JSON: \(json)")
                                
                                if let status:String = json["status"].stringValue {
                                    if status != "0" {
                                        GeneralUI.alert(json["message"].stringValue)
                                    }else{
                                        //MARK: Updated save here
                                        self.loadMyProfile(false)
                                    }
                                }
                                
                            }
                        case .Failure(let error):
                            self.cust.hideLoadingCircle()
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                        
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    self.cust.hideLoadingCircle()
                }
        })
    }
    
    @IBAction func lockButton(sender: DLRadioButton) {
        if sender.selected {
            if sender.tag == 2 {
                lockField(3, value: "1")
                lockField(4, value: "1")
            }
            if sender.tag == 5 {
                lockField(6, value: "1")
                lockField(7, value: "1")
            }
            lockField(sender.tag, value: "1")
        } else {
            if sender.tag == 2 {
                lockField(3, value: "0")
                lockField(4, value: "0")
            }
            if sender.tag == 5 {
                lockField(6, value: "0")
                lockField(7, value: "0")
            }
            lockField(sender.tag, value: "0")
        }
    }
    
    @IBAction func btnSubmit(sender: UIButton) {
        postData()
    }
    
    //Button DropDowns
    @IBAction func btnUserTypeClick(sender: UIButton) {
        userTypeDropDown.show()
    }
    
    
    @IBAction func btnHomeCountryClick(sender: UIButton) {
        homeCountryDropDown.show()
    }
    
    @IBAction func btnHomeStateClick(sender: UIButton) {
        homeStateDropDown.show()
    }
    
    @IBAction func btnHomeCityClick(sender: UIButton) {
        homeCityDropDown.show()
    }
    
    //Location
    @IBAction func btnLocationCountryClick(sender: AnyObject) {
        countryDropDown.show()
    }
    
    @IBAction func btnLocStateClick(sender: AnyObject) {
        stateDropDown.show()
    }
    
    @IBAction func btnLocCityClick(sender: AnyObject) {
        cityDropDown.show()
    }
    
    @IBAction func dateOfBirth(sender: UIButton) {
        
        var date = NSDate()
        if let birthDate2 = self.formatter.dateFromString(self.birthDate) {
            date = birthDate2
        }
        
        DatePickerDialog().show("Date of Birth", doneButtonTitle: "OK", cancelButtonTitle: "Cancel", defaultDate: date) {  (date) in
            
            if (date != nil) {
                if let bdate: String = self.formatter.stringFromDate(date!) {
                    if General.calculateAge(date!) < 13 {
                        GeneralUI.alert("You must 13 years old!")
                    } else {
                        self.birthDate = bdate
                        sender.setTitle(bdate, forState: .Normal)
                    }
                }
            }
        }
    }
    
    @IBAction func btnGenderClick(sender: UIButton) {
        genderDropDown.show()
    }
    
    @IBAction func btnEthinicityClick(sender: UIButton) {
        ethnicityDropDown.show()
    }
    
    @IBAction func btnLanguageClick(sender: UIButton) {
        languageDropDown.show()
    }
    
    @IBAction func btnBranchClick(sender: UIButton) {
        branchesDropDown.show()
    }
    
    @IBAction func btnMilBaseClick(sender: AnyObject) {
        militaryBaseDropDown.show()
    }
    
    @IBAction func btnPaygradeClick(sender: UIButton) {
        paygradeActivesDropDown.show()
    }
    
    @IBAction func btnRankClick(sender: UIButton) {
        ranksDropDown.show()
    }
    
    @IBAction func btnJobClick(sender: UIButton) {
        jobsDropDown.show()
    }
    
    @IBAction func btnRelationshipClick(sender: UIButton) {
        relationshipDropDown.show()
    }
    
    
    @IBAction func photoUpdate(sender: UIButton) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func openGallary() {
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker .dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
        let circleCropController = KACircleCropViewController(withImage: image!)
        circleCropController.delegate = self
        presentViewController(circleCropController, animated: false, completion: nil)
       /*

        
        userAvatar = image
        
        self.imgProfilePic.image = image
        self.imgProfilePic.contentMode = .ScaleAspectFit
        //self.showWaitOverlayWithText("Please wait...")
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let params: [String: AnyObject] = ["user_id":userID, "token_id":token]
        uploadPhoto(params)*/
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
// MARK:  KACircleCropViewControllerDelegate methods
    
    func circleCropDidCancel() {
        //Basic dismiss
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func circleCropDidCropImage(image: UIImage) {
        //Same as dismiss but we also return the image
       // userAvatar = image
       // self.imgProfilePic.image = image
       // self.imgProfilePic.contentMode = .ScaleAspectFit
        
        
        userAvatar = image
        
        self.imgProfilePic.image = image
        //self.imgProfilePic.contentMode = .ScaleAspectFit
        self.showWaitOverlayWithText("Please wait...")
        let userID = General.loadSaved("user_id")
        let token = General.loadSaved("user_token")
        let params: [String: AnyObject] = ["user_id":userID, "token_id":token]
        uploadPhoto(params)
        
        
        dismissViewControllerAnimated(false, completion: nil)
    }

//TODO: UITextFiled Delegate Method implementation
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func spouseClicked(sender: DLRadioButton) {
        expendSpouse()
    }
    
    @IBAction func wifeClicked(sender: DLRadioButton) {
        if !btnStatusSpouse.selected {
            btnStatusSpouse.selected = true
        }
    }
    
    @IBAction func husbandClicked(sender: DLRadioButton) {
        if !btnStatusSpouse.selected {
            btnStatusSpouse.selected = true
        }
    }
    
    @IBAction func childClicked(sender: DLRadioButton) {
        resetSpouse()
    }
    
    @IBAction func otherClicked(sender: DLRadioButton) {
        resetSpouse()
    }
    
    func expendSpouse() {
        btnWifeHeight.constant = 40.0
        btnHusbandHeight.constant = 40.0
        self.viewStatus2.constant = 250.0
        
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
    }
    
    func resetSpouse() {
        if btnStatusWife.selected {
            btnStatusSpouse.selected = false
        }
        if btnStatusHusband.selected {
            btnStatusSpouse.selected = false
        }
        
        btnWifeHeight.constant = 0.0
        btnHusbandHeight.constant = 0.0
        
        self.viewStatus2.constant = 180.0
        self.view.layoutIfNeeded()
    }
    
// MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
}