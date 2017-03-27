//
//  FilterRankVC.swift
//  TouchBase
//
//  Created by vijay kumar on 12/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import DLRadioButton
import DropDown
import Alamofire
import SwiftyJSON
import JDropDownAlert
import SwiftOverlays
import ObjectMapper
import Haneke

class FilterRankVC: UIViewController {
    
    //var sectionTitleArray : NSMutableArray = NSMutableArray()
    var filtersList = [String: [PaygradeListModel]]()
    var filtersListLevel2 = [String: [RankListModel]]()
    
    var sectionContentDict : NSMutableDictionary = NSMutableDictionary()
    var arrayForBool : NSMutableArray = NSMutableArray()
    var lastSelection = -1
    let rowHeight:CGFloat = 40
    var selectedRow:[String] = []
    var branches = [BranchListModel]()
    let cache = Shared.stringCache
    var type: String!
    var jobIDS:[String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataList = General.loadSaved("search_\(type)").characters.split{$0 == ","}.map(String.init)
        for row in dataList {
            jobIDS.append(row)
        }
        
        loadBranches()
    }
    
    func loadBranches() {
        
        self.showWaitOverlayWithText("Loading...")
        cache.fetch(key: Urls.LIST_BRANCH).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.branches.removeAll()
            self.arrayForBool.removeAllObjects()
            self.removeAllOverlays()
            
            if let message = json["message"].string {
                GeneralUI.alert(message)
            } else {
                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                    self.branches.append(Mapper<BranchListModel>().map(subJson.object)!)
                    self.arrayForBool.addObject("0")
                }
            }
            self.tableView.reloadData()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_BRANCH)
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                
                                let json = JSON(value)
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_BRANCH)
                                }
                                
                                self.branches.removeAll()
                                self.arrayForBool.removeAllObjects()
                                
                                if let message = json["message"].string {
                                    GeneralUI.alert(message)
                                } else {
                                    for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                        self.branches.append(Mapper<BranchListModel>().map(subJson.object)!)
                                        self.arrayForBool.addObject("0")
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
    
    func loadPaygrade(branch_id: String, branch_name: String) {
        
        self.showWaitOverlayWithText("Loading...")
        cache.fetch(key: Urls.LIST_PAYGRADE_ACTIVE + branch_id).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.filtersList[branch_name] = nil
            self.removeAllOverlays()
            
            if let message = json["message"].string {
                GeneralUI.alert(message)
            } else {
                var list = [PaygradeListModel]()
                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                    list.append(Mapper<PaygradeListModel>().map(subJson.object)!)
                }
                self.filtersList[branch_name] = list
            }
            self.tableView.reloadData()
            
            } .onFailure { (error) in
                
                Alamofire.request(.POST, Urls.LIST_PAYGRADE_ACTIVE, parameters: ["branchid": branch_id])
                    .responseJSON { response in
                        
                        self.removeAllOverlays()
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                if let string = json.rawString() {
                                    self.cache.set(value: string, key: Urls.LIST_PAYGRADE_ACTIVE + branch_id)
                                }
                                
                                self.filtersList[branch_name] = nil
                                if let message = json["message"].string {
                                    GeneralUI.alert(message)
                                } else {
                                    var list = [PaygradeListModel]()
                                    for (_,subJson):(String, SwiftyJSON.JSON) in json {
                                        list.append(Mapper<PaygradeListModel>().map(subJson.object)!)
                                    }
                                    self.filtersList[branch_name] = list
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
    
    func loadRankList(paygradeid: String, branch_name: String, paygrade_name: String, indexPath: NSIndexPath) {
        
        self.showWaitOverlayWithText("Loading...")
        cache.fetch(key: Urls.LIST_JOB_AND_RANK + paygradeid).onSuccess { data in
            
            let json = SwiftyJSON.JSON.parse(data)
            self.filtersListLevel2["\(branch_name)----\(paygrade_name)"] = nil
            self.removeAllOverlays()
            
            if let message = json["message"].string {
                GeneralUI.alert(message)
            } else {
                var list = [RankListModel]()
                for (_,subJson):(String, SwiftyJSON.JSON) in json[self.type] {
                    list.append(Mapper<RankListModel>().map(subJson.object)!)
                }
                self.filtersListLevel2["\(branch_name)----\(paygrade_name)"] = list
            }
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
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
                                
                                self.filtersListLevel2["\(branch_name)----\(paygrade_name)"] = nil
                                if let message = json["message"].string {
                                    GeneralUI.alert(message)
                                } else {
                                    var list = [RankListModel]()
                                    for (_,subJson):(String, SwiftyJSON.JSON) in json[self.type] {
                                        list.append(Mapper<RankListModel>().map(subJson.object)!)
                                    }
                                    self.filtersListLevel2["\(branch_name)----\(paygrade_name)"] = list
                                }
                                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                                
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return branches.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(arrayForBool .objectAtIndex(section).boolValue == true) {
            let tps = branches[section].branch_name!
            if let count: Int = filtersList[tps]?.count {
                return count
            } else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ABC"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return rowHeight
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(arrayForBool .objectAtIndex(indexPath.section).boolValue == true) {
            
            let value1 = branches[indexPath.section].branch_name!
            var value2 = ""
            if let valueRow = filtersList[value1]![indexPath.row].paygrade {
                value2 = valueRow
            }
            
            if let childRows = filtersListLevel2["\(value1)----\(value2)"]?.count {
                if !self.selectedRow.contains("\(value1)----\(value2)") {
                    return rowHeight
                }
                return rowHeight*CGFloat(childRows+1)+2
            } else {
                return rowHeight
            }
        }
        return rowHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, rowHeight))
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.tag = section
        
        let title = branches[section].branch_name!
        let frame = CGRectMake(5, 0, tableView.frame.size.width, rowHeight)
        let button = createRadioButton(frame, title: title, tag: "0", level: 1)
        
        button.icon = UIImage.init(named: "ic_arrowdown")!
        button.iconSelected = UIImage.init(named: "ic_arrowup")!
        
        if lastSelection == section {
            button.selected = !button.selected
        }
        
        button.tag = section
        headerView.addSubview(button)
        
        let headerTapped2 = UITapGestureRecognizer(target: self, action: #selector(FilterRankVC.sectionHeaderTapped(_:)))
        button.addGestureRecognizer(headerTapped2)
        return headerView
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        
        if lastSelection != indexPath.section {
            
            let branch_id = branches[indexPath.section].id!
            let branch_name = branches[indexPath.section].branch_name!
            loadPaygrade(branch_id, branch_name: branch_name)
            
            if (indexPath.row == 0) {
                
                if lastSelection != -1 && lastSelection != indexPath.section {
                    arrayForBool.replaceObjectAtIndex(lastSelection, withObject: 0)
                    
                    let range = NSMakeRange(lastSelection, 1)
                    let sectionToReload = NSIndexSet(indexesInRange: range)
                    self.tableView.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
                }
                
                var collapsed = arrayForBool.objectAtIndex(indexPath.section).boolValue
                collapsed       = !collapsed
                arrayForBool.replaceObjectAtIndex(indexPath.section, withObject: collapsed)
                
                //reload specific section animated
                let range = NSMakeRange(indexPath.section, 1)
                let sectionToReload = NSIndexSet(indexesInRange: range)
                self.tableView .reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
                lastSelection = indexPath.section
            }
            
            tableView.reloadData()
            if let btn: DLRadioButton = recognizer.view as? DLRadioButton {
                if btn.selected != true {
                    btn.selected = true
                }
            }
        } else {
            
            var collapsed = arrayForBool.objectAtIndex(indexPath.section).boolValue
            collapsed       = !collapsed
            arrayForBool.replaceObjectAtIndex(indexPath.section, withObject: collapsed)
            
            //reload specific section animated
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            self.tableView .reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
            lastSelection = -1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCheckboxCell", forIndexPath: indexPath) as! FilterCheckboxCell
        
        let manyCells : Bool = arrayForBool .objectAtIndex(indexPath.section).boolValue
        if (!manyCells) {
            //  cell.textLabel.text = @"click to enlarge";
        } else {
            
            cell.button.multipleSelectionEnabled = true
            let value1 = filtersList[branches[indexPath.section].branch_name!]![indexPath.row].paygrade
            cell.button.setTitle(value1, forState: .Normal)
            
            
            let value3 = branches[indexPath.section].branch_name!
            var value2 = ""
            if let value = self.filtersList[value3]![indexPath.row].paygrade {
                value2 = value
            }
            let value4 = self.filtersList[value3]![indexPath.row].id
            
            
            if self.selectedRow.indexOf("\(value3)----\(value2)") != nil {
                
                if !cell.button.selected {
                    cell.button.selected = true
                }
                
                if let count: Int = self.filtersListLevel2["\(value3)----\(value2)"]?.count {
                    if count != 0 {
                        for i in 1...count {
                            let frame = CGRect(x: 5, y: CGFloat(i)*self.rowHeight, width: cell.button.frame.width, height: self.rowHeight)
                            
                            if let title: String = self.filtersListLevel2["\(value3)----\(value2)"]![i-1].rank {
                                cell.addSubview(self.createRadioButton(frame, title: title, tag: self.filtersListLevel2["\(value3)----\(value2)"]![i-1].id!, level: 3))
                                
                            }
                        }
                        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                }
                
            } else {
                cell.subviews.forEach ({
                    if $0 is DLRadioButton {
                        $0.removeFromSuperview()
                    }
                })
                cell.frame.size.height = self.rowHeight
                
                if cell.button.selected {
                    cell.button.selected = false
                }
            }
            
            cell.onChildBtnTapped = {
                
                
                
                if cell.button.selected {
                    
                    
                    
                    if self.selectedRow.indexOf("\(value3)----\(value2)") == nil {
                        self.selectedRow.removeAll()
                        self.selectedRow.append("\(value3)----\(value2)")
                    }
                    
                    self.loadRankList(value4!, branch_name: value3, paygrade_name: value2, indexPath: indexPath)
                    
                    if let count: Int = self.filtersListLevel2["\(value3)----\(value2)"]?.count {
                        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
                        
                        for i in 1...count {
                            let frame = CGRect(x: 5, y: CGFloat(i)*self.rowHeight, width: cell.button.frame.width, height: self.rowHeight)
                            
                            if let title: String = self.filtersListLevel2["\(value3)----\(value2)"]![i-1].rank {
                                cell.addSubview(self.createRadioButton(frame, title: title, tag: self.filtersListLevel2["\(value3)----\(value2)"]![i-1].id!, level: 3))
                            }
                        }
                        
                        cell.frame.size.height = self.rowHeight*CGFloat(count+1)+2
                        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        
                    } else {
                        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
                    }
                    
                    
                    
                } else {
                    
                    
                    if self.selectedRow.indexOf("\(value3)----\(value2)") != nil {
                        self.selectedRow.removeAll()
                    }
                    
                    cell.subviews.forEach ({
                        if $0 is DLRadioButton {
                            $0.removeFromSuperview()
                        }
                    })
                    cell.frame.size.height = self.rowHeight
                    
                    if cell.button.selected {
                        cell.button.selected = false
                    }
                    /*
                     if let index = self.selectedRow.indexOf("\(indexPath.section+1):" + value2) {
                     self.selectedRow.removeAtIndex(index)
                     }
                     
                     cell.subviews.forEach ({
                     if $0 is DLRadioButton {
                     $0.removeFromSuperview()
                     }
                     })
                     
                     cell.frame.size.height = self.rowHeight
                     if let index = self.selectedRow.indexOf(value1!) {
                     self.selectedRow.removeAtIndex(index)
                     }
                     
                     if cell.button.selected {
                     cell.button.selected = false
                     }*/
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                    
                    
                }
                
                
                
                
            }
            
        }
        
        return cell
    }
    
    
    // MARK: Helper
    private func createRadioButton(frame: CGRect, title: String, tag: String, level: CGFloat) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame)
        radioButton.titleLabel!.font = UIFont.systemFontOfSize(14)
        radioButton.setTitle(title, forState: UIControlState.Normal)
        radioButton.setTitleColor(UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
        radioButton.backgroundColor = UIColor(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        radioButton.icon = UIImage.init(named: "ic_checkbox_unchecked")!
        radioButton.iconSelected = UIImage.init(named: "ic_checkbox_checked")!
        radioButton.tag = Int(tag)!
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        radioButton.contentEdgeInsets.left = level*10
        radioButton.multipleSelectionEnabled = true
        
        if (jobIDS.indexOf(tag) != nil) {
            if !radioButton.selected {
                radioButton.selected = true
            }
        }
        
        if level != 1 {
            radioButton.addTarget(self, action: #selector(FilterRankVC.logSelectedButton), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        return radioButton
    }
    
    @IBAction func cancelClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveClicked(sender: UIButton) {
        var values = ""
        for row in self.jobIDS {
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
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        
        if (radioButton.multipleSelectionEnabled) {
            
            var dlBtn: DLRadioButton!
            for button in radioButton.selectedButtons() {
                dlBtn = button
            }
            
            if radioButton.selected {
                jobIDS.append("\(radioButton.tag)")
            } else {
                if let item = jobIDS.indexOf("\(radioButton.tag)") {
                    jobIDS.removeAtIndex(item)
                }
            }
            
            if dlBtn != nil {
                if !dlBtn.selected {
                    dlBtn.selected = true
                }
            }
            
        }
    }
}