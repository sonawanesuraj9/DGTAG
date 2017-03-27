//
//  FilterUserTypeVC.swift
//  TouchBase
//
//  Created by vijay kumar on 10/10/16.
//  Copyright © 2016 Vijayakumar. All rights reserved.
//


import UIKit
import DLRadioButton

class FilterUserTypeVC: UIViewController {
    
    var sectionTitleArray : NSMutableArray = NSMutableArray()
    var filtersList = [String: [String]]()
    var filtersListLevel2 = [String: [String]]()
    
    var sectionContentDict : NSMutableDictionary = NSMutableDictionary()
    var arrayForBool : NSMutableArray = NSMutableArray()
    var lastSelection = -1
    let rowHeight:CGFloat = 40
    var selectedHeader:[String] = []
    var selectedRow:[String] = []
    var selectedRowsList = [String: [String]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        arrayForBool = ["0","0","0"]
        sectionTitleArray = ["Military Member","Military Dependent","Military Veteran"]
        
        filtersList["Military Member"] = ["Active Duty", "Reservist", "National Guard"]
        filtersList["Military Dependent"] = ["Spouse","Child", "Other"]
        filtersList["Military Veteran"] = ["Active Duty", "Reservist", "National Guard"]
        
        filtersListLevel2["Military Dependent----Spouse"] = ["Wife", "Husband"]
        
        let dataList = General.loadSaved("search_user_type").characters.split{$0 == ","}.map(String.init)
        for row in dataList {
            selectedRow.append(row)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(arrayForBool .objectAtIndex(section).boolValue == true) {
            let tps = sectionTitleArray.objectAtIndex(section) as! String
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
        if(arrayForBool .objectAtIndex(indexPath.section).boolValue == true){
            
            let value1 = sectionTitleArray.objectAtIndex(indexPath.section) as! String
            let value2 = filtersList[value1]![indexPath.row]
            
            if let childRows = filtersListLevel2["\(value1)----\(value2)"]?.count {
                if !self.selectedRow.contains("\(indexPath.section+1):" + value2) {
                    return rowHeight
                }
                return rowHeight*CGFloat(childRows+1)+2
            } else {
                return rowHeight
            }
        }
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, rowHeight))
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.tag = section
        
        let title = sectionTitleArray.objectAtIndex(section) as? String
        let frame = CGRectMake(5, 0, tableView.frame.size.width, rowHeight)
        let button = createRadioButton(frame, title: title!, level: 1, tag: section)
        button.icon = UIImage.init(named: "ic_arrowdown")!
        button.iconSelected = UIImage.init(named: "ic_arrowup")!
        
      //  let selectedValue = sectionTitleArray[section] as! String
        
        /*if self.selectedHeader.indexOf(selectedValue) != nil {
         button.selected = !button.selected
         }*/
        
        if lastSelection == section {
            button.selected = !button.selected
        }
        
        button.tag = section
        button.addTarget(self, action: #selector(FilterUserTypeVC.sectionHeaderTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.addSubview(button)
        
        let headerTapped2 = UITapGestureRecognizer(target: self, action: #selector(FilterUserTypeVC.sectionHeaderTapped(_:)))
        button.addGestureRecognizer(headerTapped2)
        
        let headerTapped = UITapGestureRecognizer(target: self, action: #selector(FilterUserTypeVC.sectionHeaderTapped(_:)))
        headerView.addGestureRecognizer(headerTapped)
        
        return headerView
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        
        
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        
        let selectedValue = sectionTitleArray[indexPath.section] as! String
        if self.selectedHeader.indexOf(selectedValue) == nil {
            selectedHeader.append(selectedValue)
        } else {
            selectedHeader.removeAtIndex(self.selectedHeader.indexOf(selectedValue)!)
        }
        
        if (indexPath.row == 0) {
            
            if lastSelection != -1 {
                arrayForBool.replaceObjectAtIndex(lastSelection, withObject: 0)
                
                let range = NSMakeRange(lastSelection, 1)
                let sectionToReload = NSIndexSet(indexesInRange: range)
                self.tableView.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
            }
            
            var collapsed = arrayForBool .objectAtIndex(indexPath.section).boolValue
            collapsed       = !collapsed
            arrayForBool .replaceObjectAtIndex(indexPath.section, withObject: collapsed)
            
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
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCheckboxCell", forIndexPath: indexPath) as! FilterCheckboxCell
        
        let manyCells : Bool = arrayForBool .objectAtIndex(indexPath.section).boolValue
        if (!manyCells) {
            //  cell.textLabel.text = @"click to enlarge";
        } else {
            
            cell.button.multipleSelectionEnabled = true
            let value1 = filtersList[(sectionTitleArray.objectAtIndex(indexPath.section) as! String)]![indexPath.row]
            cell.button.setTitle(value1, forState: .Normal)
            
            
            let value3 = self.sectionTitleArray.objectAtIndex(indexPath.section) as! String
            let value2 = self.filtersList[value3]![indexPath.row]
            
            if self.selectedRow.indexOf("\(indexPath.section+1):" + value2) != nil {
                
                if !cell.button.selected {
                    cell.button.selected = true
                }
                
                if let count: Int = self.filtersListLevel2["\(value3)----\(value2)"]?.count {
                    for i in 1...count {
                        let frame = CGRect(x: 5, y: CGFloat(i)*self.rowHeight, width: cell.button.frame.width, height: self.rowHeight)
                        
                        if let title: String = self.filtersListLevel2["\(value3)----\(value2)"]![i-1] as String {
                            cell.addSubview(self.createRadioButton(frame, title: title, level: 3, tag: indexPath.section))
                        }
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
                    
                    if self.selectedRow.indexOf("\(indexPath.section+1):" + value2) == nil {
                        self.selectedRow.append("\(indexPath.section+1):" + value2)
                    }
                    
                    if let count: Int = self.filtersListLevel2["\(value3)----\(value2)"]?.count {
                        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
                        
                        for i in 1...count {
                            let frame = CGRect(x: 5, y: CGFloat(i)*self.rowHeight, width: cell.button.frame.width, height: self.rowHeight)
                            
                            if let title: String = self.filtersListLevel2["\(value3)----\(value2)"]![i-1] as String {
                                cell.addSubview(self.createRadioButton(frame, title: title, level: 3, tag: indexPath.section))
                            }
                        }
                        
                        cell.frame.size.height = self.rowHeight*CGFloat(count+1)+2
                        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        
                    } else {
                        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
                    }
                } else {
                    
                    if let index = self.selectedRow.indexOf("\(indexPath.section+1):" + value2) {
                        self.selectedRow.removeAtIndex(index)
                    }
                    
                    cell.subviews.forEach ({
                        if $0 is DLRadioButton {
                            $0.removeFromSuperview()
                        }
                    })
                    
                    cell.frame.size.height = self.rowHeight
                    if let index = self.selectedRow.indexOf(value1) {
                        self.selectedRow.removeAtIndex(index)
                    }
                    
                    if cell.button.selected {
                        cell.button.selected = false
                    }
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            }
            
        }
        
        return cell
    }
    
    
    // MARK: Helper
    private func createRadioButton(frame : CGRect, title: String, level: CGFloat, tag: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame)
        radioButton.titleLabel!.font = UIFont.systemFontOfSize(14)
        radioButton.setTitle(title, forState: UIControlState.Normal)
        radioButton.setTitleColor(UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
        radioButton.backgroundColor = UIColor(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        radioButton.icon = UIImage.init(named: "ic_checkbox_unchecked")!
        radioButton.iconSelected = UIImage.init(named: "ic_checkbox_checked")!
        radioButton.tag = tag
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        radioButton.contentEdgeInsets.left = level*10
        radioButton.multipleSelectionEnabled = true
        
        
        if (self.selectedRow.indexOf("\(tag+1):" + title) != nil) {
            radioButton.selected = true
        }
        
        if level != 1 {
            radioButton.addTarget(self, action: #selector(FilterUserTypeVC.logSelectedButton), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        return radioButton
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
        
        print("values:\(values)")
        General.saveData(values, name: "search_user_type")
        
        //MARK: Save filter is On
         General.saveData("1", name: "isFilterApplied")
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        
        if (radioButton.multipleSelectionEnabled) {
            
            var dlBtn: DLRadioButton!
            var text = ""
            for button in radioButton.selectedButtons() {
                button.selected = true
                text = button.titleLabel!.text!
                dlBtn = button
            }
            
            radioButton.superview!.subviews.forEach ({
                if $0 is DLRadioButton {
                    if let btn: DLRadioButton = $0 as? DLRadioButton {
                        if btn.selected && text != btn.titleLabel!.text! {
                            btn.selected = false
                        }
                        if let index = self.selectedRow.indexOf("\(btn.tag+1):" + btn.titleLabel!.text!) {
                            self.selectedRow.removeAtIndex(index)
                        }
                    }
                }
            })
            
            if dlBtn != nil {
                if !dlBtn.selected {
                    dlBtn.selected = true
                }
                self.selectedRow.append("\(dlBtn.tag+1):" + text)
            }
            
            
        }
    }
}