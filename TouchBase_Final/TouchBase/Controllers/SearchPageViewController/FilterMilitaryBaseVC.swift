//
//  FilterMilitaryBaseVC.swift
//  TouchBase
//
//  Created by vijay kumar on 12/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//


import DropDown
import Alamofire
import SwiftyJSON
import JDropDownAlert
import SwiftOverlays
import ObjectMapper
import Haneke
import DLRadioButton
import DatePickerDialog

class FilterMilitaryBaseVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let shadowRadious : Float = 10
    let shadowAlpha : Float = 0.04
    
    
    // HomeTown Controls
    @IBOutlet weak var btnHomeTownCountry: UIButton!
    @IBOutlet weak var btnHomeTownState: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // Models
    var countries = [CountryListModel]()
    var statesHome = [StatesListModel]()
    var baseList = [MilitaryBaseListModel]()
    
    // Dropdowns
    let homeCountryDropDown = DropDown()
    let homeStateDropDown = DropDown()
    let baseDropDown = DropDown()
    
    // Selected index
    var homeCountrySelected: Int = -1
    var homeStateSelected: Int = -1
    var baseSelected: Int!
    
    var htCountry: String = ""
    var htState: String = ""
    var htCity: String = ""
    let cache = Shared.stringCache
    var selectedRow:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dataList = General.loadSaved("search_military_base").characters.split{$0 == ","}.map(String.init)
        for row in dataList {
            selectedRow.append(row)
        }
        htCountry = General.loadSaved("search_military_country")
        htState = General.loadSaved("search_military_state")
        
        loadCountries()
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
                self.baseList.removeAll()
                self.tableView.reloadData()
                
                self.loadHomeStates(self.countries[index].id!, name: self.countries[index].country!)
                self.htCountry = self.countries[index].id!
                self.htState = ""
                self.htCity = ""
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
                
                self.baseList.removeAll()
                self.tableView.reloadData()
                self.loadHomeCities(self.statesHome[index].id!, name: self.statesHome[index].state!)
                self.selectedRow.removeAll()
                
                self.htState = self.statesHome[index].id!
                self.htCity = ""
            }
        } else {
            GeneralUI.alert("Loading..")
        }
        
    }
    
    func loadHomeCities(stateid: String, name: String) {
        
        self.showWaitOverlayWithText("Loading cities in \n\(name)")
        cache.fetch(key: Urls.LIST_MILITARY_BASE + stateid + "/" + htCountry).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.baseList.removeAll()
            self.removeAllOverlays()
            
            if let message = json["message"].string {
                GeneralUI.alert(message)
            } else {
                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                    self.baseList.append(Mapper<MilitaryBaseListModel>().map(subJson.object)!)
                }
            }
            self.tableView.reloadData()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_MILITARY_BASE, parameters: ["countryid": self.htCountry, "stateid": stateid])
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_MILITARY_BASE + stateid + "/" + self.htCountry)
                                }
                                
                                self.baseList.removeAll()
                                
                                if let message = json["message"].string {
                                    GeneralUI.alert(message)
                                } else {
                                    for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                        self.baseList.append(Mapper<MilitaryBaseListModel>().map(subJson.object)!)
                                    }
                                }
                                self.tableView.reloadData()
                                
                            }
                        case .Failure(let error):
                            GeneralUI.alert(error.localizedDescription)
                            print(error)
                        }
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.baseList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCheckboxCell", forIndexPath: indexPath) as! FilterCheckboxCell
        
        let bas = self.baseList[indexPath.row]
        cell.button.setTitle(bas.base_name, forState: .Normal)
        cell.button.multipleSelectionEnabled = true
        
        if (self.selectedRow.indexOf(bas.id!) != nil) {
            if !cell.button.selected {
                cell.button.selected = true
            }
        } else {
            if cell.button.selected {
                cell.button.selected = false
            }
        }
        
        cell.onChildBtnTapped = {
            if let index = self.selectedRow.indexOf(bas.id!) {
                self.selectedRow.removeAtIndex(index)
            } else {
                self.selectedRow.append(bas.id!)
            }
        }
        
        return cell
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
    
    @IBAction func saveClicked(sender: UIButton) {
        General.saveData(htCountry, name: "search_military_country")
        General.saveData(htState, name: "search_military_state")
        
        var values = ""
        for row in self.selectedRow {
            if values == "" {
                values += row
            } else {
                values += "," + row
            }
        }
        
        General.saveData(values, name: "search_military_base")
        
        //MARK: Save filter is On
        General.saveData("1", name: "isFilterApplied")

        self.navigationController?.popViewControllerAnimated(true)
    }
    
}