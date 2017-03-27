//
//  FilterCheckboxListVC.swift
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


class FilterCheckboxListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var type = ""
    var URL = ""
    
    var selectedRow:[String] = []
    var data = [SimpleDataModel]()
    let cache = Shared.stringCache
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataList = General.loadSaved("search_\(type)").characters.split{$0 == ","}.map(String.init)
        for row in dataList {
            selectedRow.append(row)
        }
        
        if type == "ethnicity" {
            URL = Urls.LIST_ETHNICITY
        } else if type == "language" {
            URL = Urls.LIST_LANGUAGES
        } else if type == "gender" {
            URL = Urls.LIST_GENDER
        } else if type == "relationship" {
            URL = Urls.LIST_RELATIONSHIP
        } else if type == "branch_name" {
            URL = Urls.LIST_BRANCH
        } else if type == "children" {
            data.append(SimpleDataModel(value1: "yes", value2: "Yes")!)
            data.append(SimpleDataModel(value1: "no", value2: "No")!)
            tableView.reloadData()
        } else if type == "interest" {
            data.append(SimpleDataModel(value1: "male", value2: "Male")!)
            data.append(SimpleDataModel(value1: "female", value2: "Female")!)
            tableView.reloadData()
        }
        
        if type != "children" && type != "interest" {
            loadData()
        }
    }
    
    
    func loadData() {
        
        self.showWaitOverlayWithText("Loading...")
        cache.fetch(key: URL).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.data.removeAll()
            self.removeAllOverlays()
            
            if let message = json["message"].string {
                GeneralUI.alert(message)
            } else {
                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                    self.data.append(Mapper<SimpleDataModel>().map(subJson.object)!)
                }
            }
            self.tableView.reloadData()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, self.URL)
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                
                                let json = JSON(value)
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: self.URL)
                                }
                                
                                self.data.removeAll()
                                
                                if let message = json["message"].string {
                                    GeneralUI.alert(message)
                                } else {
                                    for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                        self.data.append(Mapper<SimpleDataModel>().map(subJson.object)!)
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
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCheckboxCell", forIndexPath: indexPath) as! FilterCheckboxCell
        
        let rowValue = self.data[indexPath.row]
        cell.button.setTitle(rowValue.name, forState: .Normal)
        cell.button.multipleSelectionEnabled = true
        
        if (self.selectedRow.indexOf(rowValue.id!) != nil) {
            if !cell.button.selected {
                cell.button.selected = true
            }
        } else {
            if cell.button.selected {
                cell.button.selected = false
            }
        }
        
        cell.onChildBtnTapped = {
            if let index = self.selectedRow.indexOf(rowValue.id!) {
                self.selectedRow.removeAtIndex(index)
            } else {
                self.selectedRow.append(rowValue.id!)
            }
        }
        
        return cell
    }
    
    
    @IBAction func cancelClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveClicked(sender: UIButton) {
        var values = ""
        for row in self.selectedRow {
            if values == "" {
                values += row
            } else {
                values += "," + row
            }
        }
        
        General.saveData(values, name: "search_\(type)")
        //MARK: Save filter is On
        General.saveData("1", name: "isFilterApplied")

        self.navigationController?.popViewControllerAnimated(true)
    }
    
}