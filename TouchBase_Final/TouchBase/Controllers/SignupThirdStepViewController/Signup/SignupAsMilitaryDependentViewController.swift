//
//  SignupAsMilitaryDependentViewController.swift
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
import Mixpanel

class SignupAsMilitaryDependentViewController: UIViewController {
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    let shadowRadious : Float = 10
    let shadowAlpha : Float = 0.04
    
    var dropDown = DropDown()
    
    @IBOutlet weak var btnWifeHeight: NSLayoutConstraint!
    @IBOutlet weak var btnHusbandHeight: NSLayoutConstraint!
    
    //Datasource Array
    var cityArray : [String] = []
    var countryArray : [String] = []
    var stateArray : [String] = []
    var milBaseArray : [String] = []
    
    
    // Controls
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    
    // HomeTown Controls
    @IBOutlet weak var btnHomeTownCountry: UIButton!
    @IBOutlet weak var btnHomeTownState: UIButton!
    @IBOutlet weak var btnHomeTownCity: UIButton!
    
    // Location Controls
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnMilitryBase: UIButton!
    @IBOutlet weak var btnDateOfBirth: UIButton!
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var btnEthnicity: UIButton!
    @IBOutlet weak var btnLanguage: UIButton!
    @IBOutlet weak var btnBranch: UIButton!
    @IBOutlet weak var btnRelationship: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    // Models
    var countries = [CountryListModel]()
    var statesHome = [StatesListModel]()
    var citiesHome = [CityListModel]()
    var states = [StatesListModel]()
    var cities = [CityListModel]()
    var genders = [GenderListModel]()
    var ethnicities = [EthnicityListModel]()
    var branches = [BranchListModel]()
    var militaryBases = [MilitaryBaseListModel]()
    var relationships = [RelationshipListModel]()
    var languages = [LanguagesListModel]()
    
    // Dropdowns
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
    let relationshipDropDown = DropDown()
    let languageDropDown = DropDown()
    
    // Selected index
    var homeCountrySelected: Int!
    var homeStateSelected: Int!
    var homeCitySelected: Int!
    var countrySelected: Int!
    var stateSelected: Int!
    var citySelected: Int!
    var genderSelected: Int!
    var ethnicitySelected: Int!
    var branchesSelected: Int!
    var militaryBaseSelected: Int!
    var relationshipSelected: Int!
    var languageSelected: Int!
    
    @IBOutlet weak var btnStatusSpouse: DLRadioButton!
    @IBOutlet weak var btnStatusWife: DLRadioButton!
    @IBOutlet weak var btnStatusHusband: DLRadioButton!
    @IBOutlet weak var btnStatusChild: DLRadioButton!
    @IBOutlet weak var btnStatusOther: DLRadioButton!
    
    @IBOutlet weak var btnHasChildYes: DLRadioButton!
    @IBOutlet weak var btnIntrestMale: DLRadioButton!
    @IBOutlet weak var btnIntrestFemale: DLRadioButton!
    
    
    var userid: String!
    var utype: String!
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
    var paygrade: String = ""
    var rank: String = ""
    var job: String = ""
    var hasChild: String = "no"
    var interest: String = ""
    var relationship: String = ""
    var dependantStatus: String = ""
    var userDevice: String = UIDevice.currentDevice().model
    //var deviceNumber: String = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    let cache = Shared.stringCache
    let formatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = cust.mainBackgroundColor
        self.navigationView.backgroundColor = cust.navBackgroundColor
        formatter.dateFormat = "yyyy-MM-dd"
        
        loadCountries()
        loadGender()
        loadEthnicity()
        loadBranch()
        loadRelationship()
        loadLanguages()
        
        btnHasChildYes.selected = true
        
        btnIntrestMale.multipleSelectionEnabled = true
        btnIntrestFemale.multipleSelectionEnabled = true
        
        /*
         btnStatusSpouse.multipleSelectionEnabled = true
         btnStatusWife.multipleSelectionEnabled = true
         btnStatusHusband.multipleSelectionEnabled = true
         btnStatusChild.multipleSelectionEnabled = true
         btnStatusOther.multipleSelectionEnabled = true*/
        
        resetSpouse()
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
                homeCountryDropDown.dataSource.append(self.countries[index-1].country!)
            }
            homeCountryDropDown.selectRowAtIndex(self.homeCountrySelected)
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
                countryDropDown.dataSource.append(self.countries[index-1].country!)
            }
            countryDropDown.selectRowAtIndex(self.homeCountrySelected)
            countryDropDown.anchorView = self.btnCountry
            
            countryDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnCountry.setTitle(item, forState: .Normal)
                self.countrySelected = index
                
                self.btnState.setTitle("State", forState: .Normal)
                self.stateSelected = -1
                self.btnCity.setTitle("City", forState: .Normal)
                self.citySelected = -1
                
                self.loadStates(self.countries[index].id!, name: self.countries[index].country!)
                self.locCountry = self.countries[index].id!
                self.locState = ""
                self.locCity = ""
                
                self.milBase = ""
                
                self.btnMilitryBase.setTitle("Military Base", forState: .Normal)
                self.militaryBaseSelected = 0
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
                homeStateDropDown.dataSource.append(self.statesHome[index-1].state!)
            }
            //homeStateDropDown.selectRowAtIndex(self.homeStateSelected)
            homeStateDropDown.anchorView = self.btnHomeTownState
            
            homeStateDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnHomeTownState.setTitle(item, forState: .Normal)
                self.homeStateSelected = index
                
                self.btnHomeTownCity.setTitle("City", forState: .Normal)
                self.homeCitySelected = -1
                self.loadHomeCities(self.statesHome[index].id!, name: self.statesHome[index].state!)
                
                self.htState = self.statesHome[index].id!
                self.htCity = ""
                
                self.btnMilitryBase.setTitle("Military Base", forState: .Normal)
                self.militaryBaseSelected = 0
                
                self.loadMilitaryBase()
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
                stateDropDown.dataSource.append(self.states[index-1].state!)
            }
            //stateDropDown.selectRowAtIndex(self.homeCountrySelected)
            stateDropDown.anchorView = self.btnState
            
            stateDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnState.setTitle(item, forState: .Normal)
                self.stateSelected = index
                
                self.btnCity.setTitle("City", forState: .Normal)
                self.citySelected = -1
                self.loadCities(self.states[index].id!, name: self.states[index].state!)
                
                self.btnMilitryBase.setTitle("Military Base", forState: .Normal)
                self.loadMilitaryBase()
                self.militaryBaseSelected = 0
                
                self.locState = self.states[index].id!
                self.locCity = ""
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
            print(json)
            
            if let message = json["message"].string {
                GeneralUI.alert(message)
            } else {
                if (json.array != nil) {
                    for (_,subJson):(String, SwiftyJSON.JSON) in json {
                        self.citiesHome.append(Mapper<CityListModel>().map(subJson.object)!)
                    }
                } else {
                    self.citiesHome.append(Mapper<CityListModel>().map(json.object)!)
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
                                print(json)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_CITIES + stateid)
                                }
                                
                                self.citiesHome.removeAll()
                                
                                if let message = json["message"].string {
                                    GeneralUI.alert(message)
                                } else {
                                    if (json.array != nil) {
                                        for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                            self.citiesHome.append(Mapper<CityListModel>().map(subJson.object)!)
                                        }
                                    } else {
                                        self.citiesHome.append(Mapper<CityListModel>().map(json.object)!)
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
                homeCityDropDown.dataSource.append(self.citiesHome[index-1].city)
            }
            //homeCityDropDown.selectRowAtIndex(self.homeCitySelected)
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
            print(json)
            
            self.cities.removeAll()
            self.removeAllOverlays()
            
            if let message = json["message"].string {
                GeneralUI.alert(message)
            } else {
                self.cities.removeAll()
                if (json.array != nil) {
                    for (_,subJson):(String, SwiftyJSON.JSON) in json {
                        self.cities.append(Mapper<CityListModel>().map(subJson.object)!)
                    }
                } else {
                    self.cities.append(Mapper<CityListModel>().map(json.object)!)
                }
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
                                print(json)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_CITIES + stateid)
                                }
                                
                                if let message = json["message"].string {
                                    GeneralUI.alert(message)
                                } else {
                                    self.cities.removeAll()
                                    if (json.array != nil) {
                                        for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                            self.cities.append(Mapper<CityListModel>().map(subJson.object)!)
                                        }
                                    } else {
                                        self.cities.append(Mapper<CityListModel>().map(json.object)!)
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
                cityDropDown.dataSource.append(self.cities[index-1].city)
            }
            //cityDropDown.selectRowAtIndex(self.citySelected)
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
                genderDropDown.dataSource.append(self.genders[index-1].gender!)
            }
            genderDropDown.selectRowAtIndex(self.genderSelected)
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
                ethnicityDropDown.dataSource.append(self.ethnicities[index-1].ethnicity!)
            }
            ethnicityDropDown.selectRowAtIndex(self.genderSelected)
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
                branchesDropDown.dataSource.append(self.branches[index-1].branch_name!)
            }
            //branchesDropDown.selectRowAtIndex(self.branchesSelected)
            branchesDropDown.anchorView = self.btnBranch
            
            branchesDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnBranch.setTitle(item, forState: .Normal)
                self.branchesSelected = index
                
                self.branch = self.branches[index].id!
                //self.milBase = ""
                self.paygrade = ""
                
                
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    
    func loadMilitaryBase() {
        
        self.showWaitOverlayWithText("Loading military base ...")
        cache.fetch(key: Urls.LIST_MILITARY_BASE  + self.locCountry + "/" + self.locState).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.militaryBases.removeAll()
            self.removeAllOverlays()
            
            if (json.array != nil) {
                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                    self.militaryBases.append(Mapper<MilitaryBaseListModel>().map(subJson.object)!)
                }
            } else {
                self.militaryBases.append(Mapper<MilitaryBaseListModel>().map(json.object)!)
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
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_MILITARY_BASE  + self.locCountry + "/" + self.locState)
                                }
                                
                                self.militaryBases.removeAll()
                                if (json.array != nil) {
                                    for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                        self.militaryBases.append(Mapper<MilitaryBaseListModel>().map(subJson.object)!)
                                    }
                                } else {
                                    self.militaryBases.append(Mapper<MilitaryBaseListModel>().map(json.object)!)
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
        
        if self.militaryBases.count != 0 {
            militaryBaseDropDown.dataSource.removeAll()
            
            for index in 1...self.militaryBases.count {
                militaryBaseDropDown.dataSource.append(self.militaryBases[index-1].base_name!)
            }
            militaryBaseDropDown.selectRowAtIndex(self.militaryBaseSelected)
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
                relationshipDropDown.dataSource.append(self.relationships[index-1].relationship!)
            }
            relationshipDropDown.selectRowAtIndex(self.relationshipSelected)
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
                languageDropDown.dataSource.append(self.languages[index-1].language!)
            }
            languageDropDown.selectRowAtIndex(self.languageSelected)
            languageDropDown.anchorView = self.btnLanguage
            
            languageDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnLanguage.setTitle(item, forState: .Normal)
                self.relationshipSelected = index
                
                self.language = self.languages[index].id!
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func postData() {
        
        if btnHasChildYes.selected {
            hasChild = "yes"
        }
        
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
        
        if  validate(htCountry, text: "Hometown Country") && validate(htState, text: "Hometown State") && validate(htCity, text: "Hometown City") &&
            validate(locCountry, text: "Location Country") && validate(locState, text: "Location State") && validate(locCity, text: "Location City") &&
            validate(dependantStatus, text: "Dependant Status") &&
            validateMBase(milBase, text: "Military Base") && validate(birthDate, text: "Date of birth") && validate(gender, text: "Gender") &&
            validate(ethnicity, text: "Ethnicity") &&
            validate(language, text: "Language") && validate(branch, text: "Branch") &&
            validate(hasChild, text: "Children") &&
            validate(intrests, text: "Interested In") &&
            validate(relationship, text: "Relationship") {
            
            
            var params = ["userid": userid,
                          "utype": utype,
                          "userDevice": userDevice,
                          "deviceNumber": ""]
            
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
            
            params["hasChild"] = hasChild
            params["relationship"] = relationship
            
            
            params["dependantStatus"] = dependantStatus
            params["interest"] = intrests
            self.showWaitOverlayWithText("Please wait...")
             self.view.userInteractionEnabled = false
            self.btnSubmit.userInteractionEnabled = false
            Alamofire.request(.POST, Urls.REGISTER_STEP2, parameters: params)
                .responseJSON { response in
                    self.removeAllOverlays()
                    
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            print("JSON: \(json)")
                            
                             self.view.userInteractionEnabled = true
                            if let status = json["status"].string {
                                if status != "0" {
                                    GeneralUI.alert(json["message"].string!)
                                } else {
                                    if let id = json["user_id"].string {
                                        General.saveData("\(id)", name: "user_id")
                                        
                                        //MARK: Track User has created Account
                                        Mixpanel.mainInstance().identify(distinctId: String(id))
                                        Mixpanel.mainInstance().track(event: "Account Creation",
                                            properties: ["Account Creation" : "Account Creation"])

                                        
                                        let verfiyVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupVerificationOptionViewController") as! SignupVerificationOptionViewController
                                        
                                        verfiyVC.userid = "\(id)"
                                        verfiyVC.branchid = self.branch
                                        self.navigationController?.pushViewController(verfiyVC, animated: true)
                                        
                                    } else {
                                        GeneralUI.alert(json["status"].string!)
                                    }
                                }
                            }
                        }
                    case .Failure(let error):
                         self.btnSubmit.userInteractionEnabled = true
                         self.view.userInteractionEnabled = true
                        print(error)
                    }
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
        if value == ""  {
            let alert = JDropDownAlert()
            alert.alertWith("Please choose \(text)!")
            return false
        }
        return true
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.btnBackOutlet.setImage(UIImage(named: "btn_back\(self.delObj.deviceName)"), forState: UIControlState.Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let shadoView : UIView = UIView()
        shadoView.frame = CGRectMake(0, 0, self.btnHomeTownCity.frame.size.width,  self.btnHomeTownCity.frame.size.height)
        // shadoView.makeInsetShadowWithRadius(0.5, color: UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0), directions: ["top","bottom","left","right"])
        shadoView.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        
        
        //self.lblTmp.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnHomeTownCity.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnHomeTownState.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnHomeTownCountry.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        
        self.btnCountry.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnState.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnCity.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnMilitryBase.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnGender.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnEthnicity.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnLanguage.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnBranch.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        self.btnRelationship.makeInsetShadowWithRadius(shadowRadious, alpha: shadowAlpha)
        
        
        //ScrollView
        self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, self.btnSubmit.frame.size.height + self.btnSubmit.frame.origin.y + 18)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSubmitClick(sender: AnyObject) {
        postData()
    }
    
    @IBAction func btnSubmit2Click(sender: UIButton) {
        postData()
    }
    
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //Button DropDowns
    @IBAction func btnHomeCountryClick(sender: UIButton) {
        homeCountryDropDown.show()
    }
    
    @IBAction func btnHomeStateClick(sender: UIButton) {
        homeStateDropDown.show()
    }
    
    @IBAction func btnHomeCityClick(sender: UIButton) {
        homeCityDropDown.show()
    }
    
    
    @IBAction func btnCountryClick(sender: UIButton) {
        countryDropDown.show()
    }
    
    
    @IBAction func btnStateClick(sender: UIButton) {
        stateDropDown.show()
    }
    
    @IBAction func btnCityClick(sender: UIButton) {
        cityDropDown.show()
    }
    
    
    @IBAction func btnMiliBaseClick(sender: UIButton) {
        militaryBaseDropDown.show()
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
    
    @IBAction func btnRelationshipClick(sender: UIButton) {
        relationshipDropDown.show()
    }
    
    
    @IBAction func spouseClicked(sender: DLRadioButton) {
        btnWifeHeight.constant = 40.0
        btnHusbandHeight.constant = 40.0
        self.view.layoutIfNeeded()
        self.view.updateConstraintsIfNeeded()
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
    
    func resetSpouse() {
        if btnStatusWife.selected {
            btnStatusSpouse.selected = false
        }
        if btnStatusHusband.selected {
            btnStatusSpouse.selected = false
        }
        
        btnWifeHeight.constant = 0.0
        btnHusbandHeight.constant = 0.0
    }
    
}