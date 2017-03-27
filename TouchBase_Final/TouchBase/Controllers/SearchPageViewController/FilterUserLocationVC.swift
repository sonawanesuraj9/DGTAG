//
//  FilterUserLocationVC.swift
//  TouchBase
//
//  Created by vijay kumar on 18/11/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import DropDown
import CoreLocation
import Alamofire
import SwiftyJSON
import JDropDownAlert
import SwiftOverlays
import ObjectMapper
import Haneke
import DLRadioButton
import DatePickerDialog
import ZMSwiftRangeSlider

class FilterUserLocationVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    let shadowRadious : Float = 10
    let shadowAlpha : Float = 0.04
    
    var dropDown = DropDown()
    
    @IBOutlet weak var dropLocationHeight: NSLayoutConstraint!
    @IBOutlet weak var dropMilesHeight: NSLayoutConstraint!
    @IBOutlet weak var clearCityHeight: NSLayoutConstraint!
    @IBOutlet weak var rangeSlider1: RangeSlider!
    private var rangeValues = Array(0...250)
    
    var min = 0
    var max = 97
    var isLocation = false
    
    let locationManager = CLLocationManager()
    
    // HomeTown Controls
    @IBOutlet weak var btnUserLocation: UIButton!
    @IBOutlet weak var btnHomeTownCountry: UIButton!
    @IBOutlet weak var btnHomeTownState: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // Models
    var countries = [CountryListModel]()
    var statesHome = [StatesListModel]()
   // var citiesHome = [CityListModel]()
    
    var searchCity = [SearchCityModel]()
    
    
    // Dropdowns
    let homeCountryDropDown = DropDown()
    let homeStateDropDown = DropDown()
    let homeCityDropDown = DropDown()
    
    // Selected index
    var homeCountrySelected: Int = -1
    var homeStateSelected: Int = -1
    var homeCitySelected: Int!
    
    var selectedRow:[String] = []
    var htCountry: String = ""
    var htState: String = ""
    var htCity: String = ""
    
    var lat: String = ""
    var long: String = ""
    var radious: String = ""
    let cache = Shared.stringCache
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Ask for Authorisation from the User.
        //self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            print("Enabled")
        }
        

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        if lat == "" {
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
                
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks!.count > 0 {
                    self.locationManager.stopUpdatingLocation()
                    let pm = placemarks![0]
                    
                    var city = ""
                    if let locality = pm.locality {
                        city = locality
                    } else if let locality = pm.subLocality {
                        city = locality
                    } else if let locality = pm.subLocality {
                        city = locality
                    }
                    
                    if let postalCode = pm.postalCode {
                        self.btnUserLocation.setTitle("\(city), \(postalCode)", forState: .Normal)
                    } else {
                        self.btnUserLocation.setTitle("\(city)", forState: .Normal)
                    }
                    
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
        
        lat = "\(locValue.latitude)"
        long = "\(locValue.longitude)"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
        let dataList = General.loadSaved("search_loc_city").characters.split{$0 == ","}.map(String.init)
        for row in dataList {
            selectedRow.append(row)
        }
        htCountry = General.loadSaved("search_loc_country")
        htState = General.loadSaved("search_loc_state")
        
        loadCountries()
        
        
        if let value:String = General.loadSaved("search_radius") {
            if value != "" {
                max = Int(value)!
            }
        }
        
        rangeSlider1.setRangeValues(rangeValues)
        rangeSlider1.setMinAndMaxValue(min, maxValue: max)
        
        rangeSlider1.setValueChangedCallback { (minValue, maxValue) in
            self.radious = "\(maxValue)"
        }
        clearButton()
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
                
                if htCountry == self.countries[index-1].id! {
                    self.btnHomeTownCountry.setTitle(self.countries[index-1].country!, forState: .Normal)
                    self.homeCountrySelected = index-1
                    self.loadHomeStates(self.countries[index-1].id!, name: self.countries[index-1].country!)
                }
            }
            
            if self.homeCountrySelected != -1 {
                if self.homeCountryDropDown.dataSource.count <= self.homeCountrySelected {
                    homeCountryDropDown.selectRowAtIndex(self.homeCountrySelected)
                }
            }
            homeCountryDropDown.anchorView = self.btnHomeTownCountry
            
            homeCountryDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnHomeTownCountry.setTitle(item, forState: .Normal)
                self.homeCountrySelected = index
                
                self.btnHomeTownState.setTitle("State", forState: .Normal)
                self.homeStateSelected = -1
                self.searchCity.removeAll()
                self.tableView.reloadData()
                
                self.loadHomeStates(self.countries[index].id!, name: self.countries[index].country!)
                self.htCountry = self.countries[index].id!
                self.htState = ""
                self.htCity = ""
                self.selectedRow.removeAll()
                self.clearButton()
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
                
                if htState == self.statesHome[index-1].id! {
                    self.btnHomeTownState.setTitle(self.statesHome[index-1].state!, forState: .Normal)
                    self.homeStateSelected = index-1
                    self.loadHomeCities(self.statesHome[index-1].id!, name: self.statesHome[index-1].state!)
                }
            }
            if self.homeStateSelected != -1 {
                if self.homeStateDropDown.dataSource.count <= self.homeStateSelected {
                    homeStateDropDown.selectRowAtIndex(self.homeStateSelected)
                }
            }
            homeStateDropDown.anchorView = self.btnHomeTownState
            
            homeStateDropDown.selectionAction = { [unowned self] (index, item) in
                self.btnHomeTownState.setTitle(item, forState: .Normal)
                
                self.homeStateSelected = index
                
                self.searchCity.removeAll()
                self.tableView.reloadData()
                self.loadHomeCities(self.statesHome[index].id!, name: self.statesHome[index].state!)
                self.selectedRow.removeAll()
                
                self.htState = self.statesHome[index].id!
                self.htCity = ""
                self.selectedRow.removeAll()
                self.clearButton()
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadHomeCities(stateid: String, name: String) {
        
        self.showWaitOverlayWithText("Loading cities in \n\(name)")
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
                                
                                self.searchCity.removeAll()
                                
                                if let message = json["message"].string {
                                    GeneralUI.alert(message)
                                } else {
                                    let count = json.array?.count
                                    if(count>0){
                                        
                                        for ind in 0...count!-1{
                                            let id = json[ind]["id"].stringValue
                                            let city = json[ind]["city"].stringValue
                                            self.searchCity.append(SearchCityModel(id: id, city: city)!)
                                        }
                                        self.searchCity.insert(SearchCityModel(id: "0",city: "Select All")!, atIndex: 0)
                                    }
                                    
                                    /*for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                        self.citiesHome.append(Mapper<CityListModel>().map(subJson.object)!)
                                    }*/
                                }
                                self.tableView.reloadData()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        
        /*cache.fetch(key: Urls.LIST_CITIES + stateid).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.searchCity.removeAll()
            self.removeAllOverlays()
            
            if let message = json["message"].string {
                GeneralUI.alert(message)
            } else {
                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                    self.searchCity.append(Mapper<SearchCityModel>().map(subJson.object)!)
                }
            }
            self.tableView.reloadData()
            
            } .onFailure { (error) in
                
               
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.searchCity.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCheckboxCell", forIndexPath: indexPath) as! FilterCheckboxCell
        
        let city = self.searchCity[indexPath.row]
        cell.button.setTitle(city.city, forState: .Normal)
        cell.button.multipleSelectionEnabled = true
        
        if (self.selectedRow.indexOf(city.id) != nil) {
            if !cell.button.selected {
                cell.button.selected = true
            }
        } else {
            if cell.button.selected {
                cell.button.selected = false
            }
        }
        
        cell.onChildBtnTapped = {
            
            if let index = self.selectedRow.indexOf(city.id) {
                
                if(city.id == "0"){
                    self.selectedRow.removeAll()
                    self.tableView.reloadData()
                }else{
                    self.selectedRow.removeAtIndex(index)
                }
                
            } else {
                if(city.id == "0"){
                    for inds in 0...self.searchCity.count-1{
                        let c = self.searchCity[inds]
                        self.selectedRow.append(c.id)
                    }
                    self.tableView.reloadData()
                }else{
                    self.selectedRow.append(city.id)
                }
                
                
            }
            self.clearButton()
        }
        return cell
    }
    
    func clearButton() {
        
        if self.selectedRow.count != 0 {
            clearCityHeight.constant = 38.0
        } else {
            clearCityHeight.constant = 0.0
        }
        
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnMyLocationClick(sender: UIButton) {
        isLocation = true
        
        if dropLocationHeight.constant == 0.0 {
            dropLocationHeight.constant = 38.0
        } else {
            dropLocationHeight.constant = 0.0
        }
        
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnSelectedMilesClick(sender: UIButton) {
        
        if dropMilesHeight.constant == 0.0 {
            dropMilesHeight.constant = 90.0
        } else {
            dropMilesHeight.constant = 0.0
        }
        
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //Button DropDowns
    @IBAction func btnHomeCountryClick(sender: UIButton) {
        homeCountryDropDown.show()
    }
    
    @IBAction func btnHomeStateClick(sender: UIButton) {
        homeStateDropDown.show()
    }
    
    @IBAction func cancelClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func clearCitiesClicked(sender: UIButton) {
        
        self.btnHomeTownCountry.setTitle("Country", forState: .Normal)
        self.homeCountrySelected = -1
        
        self.btnHomeTownState.setTitle("State", forState: .Normal)
        self.homeStateSelected = -1
        self.searchCity.removeAll()
        self.selectedRow.removeAll()
        self.tableView.reloadData()
        
        self.htCountry = ""
        self.htState = ""
        self.htCity = ""
        self.clearButton()
    }
    
    @IBAction func saveClicked(sender: UIButton) {
        
        General.removeSaved("search_loc_country")
        General.removeSaved("search_loc_state")
        General.removeSaved("search_loc_city")
        
        General.removeSaved("search_loc_latitude")
        General.removeSaved("search_loc_longitude")
        General.removeSaved("search_radius")
        
        if self.selectedRow.count != 0 {
            General.saveData(htCountry, name: "search_loc_country")
            General.saveData(htState, name: "search_loc_state")
            
            var values = ""
            for row in self.selectedRow {
                if values == "" {
                    values += row
                } else {
                    values += "," + row
                }
            }
            
            General.saveData(values, name: "search_loc_city")
        } else if isLocation {
            General.saveData(lat, name: "search_loc_latitude")
            General.saveData(long, name: "search_loc_longitude")
            if(radious == ""){
                radious = "10"
            }
            General.saveData(radious, name: "search_radius")
        }
        
        //MARK: Save filter is On
        General.saveData("1", name: "isFilterApplied")
       
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}