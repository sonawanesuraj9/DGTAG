//
//  FilterViewController.swift
//  TouchBase
//
//  Created by vijay kumar on 10/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import Mixpanel

class FilterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedRow:[String] = []
    var filter_types = [
                        "Branch",
                        "Military Base",
                        "Paygrade",
                        "Job",
                        "Rank",
                        "Location",
                        "User Type",
                        "Hometown",
                        "Age",
                        "Ethnicity",
                        "Language",
                        "Gender",
                        "Children",
                        "Interested in",
                        "Relationship"
                       ]
    /*
     
     var filter_types = ["User Type",
     "Hometown",
     "Age",
     "Location",
     "Ethnicity",
     "Language",
     "Gender",
     "Children",
     "Interested in",
     "Relationship",
     "Branch",
     "Military Base",
     "Paygrade",
     "Job",
     "Rank"]
     */
    
    let selectedRowColor = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0)
    
    var filter_types2 = [
                        "Branch": "search_branch_name",
                         "Military Base": "search_military_base",
                         "Paygrade": "search_paygrade",
                         "Job": "search_job",
                         "Rank": "search_rank",
                        "Location": "search_location",
                         "User Type": "search_user_type",
                         "Hometown": "search_home_country",
                         "Age": "search_age",
                         "Ethnicity": "search_ethnicity",
                         "Language": "search_language",
                         "Gender": "search_gender",
                         "Children": "search_children",
                         "Interested in": "search_interest",
                         "Relationship": "search_relationship"
                         ]
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filter_types.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchFilterViewCell", forIndexPath: indexPath) as! SearchFilterViewCell
        
        let name = filter_types[indexPath.row]
        cell.lblName.text = name
        cell.button.hidden = true
        cell.onChildBtnTapped = {
            print(name)
            if let index = self.selectedRow.indexOf(name) {
                self.selectedRow.removeAtIndex(index)
            } else {
                self.selectedRow.append(name)
            }
        }
        if General.loadSaved(self.filter_types2[name]!) != "" {
            cell.button.backgroundColor = self.selectedRowColor
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        print(row)
        if filter_types[row] == "Branch" {
            type = "branch_name"
            performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
        }else if filter_types[row] == "Military Base" {
            performSegueWithIdentifier("FilterMilitaryBaseVC", sender: self)
        }else if filter_types[row] == "Paygrade" {
            performSegueWithIdentifier("FilterPaygradeVC", sender: self)
        } else if filter_types[row] == "Job" {
            type = "job"
            performSegueWithIdentifier("FilterRankVC", sender: self)
        }else if filter_types[row] == "Rank" {
            type = "rank"
            performSegueWithIdentifier("FilterRankVC", sender: self)
        }else if filter_types[row] == "Location" {
            performSegueWithIdentifier("FilterUserLocationVC", sender: self)
        }else if filter_types[row] == "User Type" {
            performSegueWithIdentifier("FilterUserTypeVC", sender: self)
        } else if filter_types[row] == "Hometown" {
            performSegueWithIdentifier("FilterHometownVC", sender: self)
        } else if filter_types[row] == "Age" {
            performSegueWithIdentifier("FilterAgeSelecterVC", sender: self)
        }  else if filter_types[row] == "Ethnicity" {
            type = "ethnicity"
            performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
        } else if filter_types[row] == "Language" {
            type = "language"
            performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
        } else if filter_types[row] == "Gender" {
            type = "gender"
            performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
        }  else if filter_types[row] == "Children" {
            type = "children"
            performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
        }  else if filter_types[row] == "Interested in" {
            type = "interest"
            performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
        } else if filter_types[row] == "Relationship" {
            type = "relationship"
            performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
        }
        
        
        
        
        /*
         if filter_types[row] == "User Type" {
         performSegueWithIdentifier("FilterUserTypeVC", sender: self)
         } else if filter_types[row] == "Hometown" {
         performSegueWithIdentifier("FilterHometownVC", sender: self)
         } else if filter_types[row] == "Age" {
         performSegueWithIdentifier("FilterAgeSelecterVC", sender: self)
         } else if filter_types[row] == "Location" {
         performSegueWithIdentifier("FilterUserLocationVC", sender: self)
         } else if filter_types[row] == "Ethnicity" {
         type = "ethnicity"
         performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
         } else if filter_types[row] == "Language" {
         type = "language"
         performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
         } else if filter_types[row] == "Gender" {
         type = "gender"
         performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
         }  else if filter_types[row] == "Children" {
         type = "children"
         performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
         }  else if filter_types[row] == "Interested in" {
         type = "interest"
         performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
         } else if filter_types[row] == "Relationship" {
         type = "relationship"
         performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
         } else if filter_types[row] == "Branch" {
         type = "branch_name"
         performSegueWithIdentifier("FilterCheckboxListVC", sender: self)
         } else if filter_types[row] == "Military Base" {
         performSegueWithIdentifier("FilterMilitaryBaseVC", sender: self)
         } else if filter_types[row] == "Rank" {
         type = "rank"
         performSegueWithIdentifier("FilterRankVC", sender: self)
         } else if filter_types[row] == "Job" {
         type = "job"
         performSegueWithIdentifier("FilterRankVC", sender: self)
         } else if filter_types[row] == "Paygrade" {
         performSegueWithIdentifier("FilterPaygradeVC", sender: self)
         }
         
         */
        
    }
    
    @IBAction func cancelClicked(sender: UIButton) {
        
        //MARK: If user is verified then Refine Search Metrics
        //Condition: Once user select any one filter >> Save >> Back, then this metric will be raised.
         let isVerified = General.loadSaved("verification_pending")
        
        let ft1 = General.loadSaved("search_loc_latitude")
        let ft2 = General.loadSaved("search_radius")
        let ft3 = General.loadSaved("search_loc_country")
        let ft4 = General.loadSaved("search_loc_state")
        let ft5 = General.loadSaved("search_loc_city")
        let ft6 = General.loadSaved("search_home_country")
        let ft7 = General.loadSaved("search_home_state")
        let ft8 = General.loadSaved("search_home_city")
        let ft9 = General.loadSaved("search_age")
        let ft10 = General.loadSaved("search_ethnicity")
        let ft11 = General.loadSaved("search_language")
        let ft12 = General.loadSaved("search_gender")
        let ft13 = General.loadSaved("search_children")
        let ft14 = General.loadSaved("search_interest")
        let ft15 = General.loadSaved("search_relationship")
        let ft16 = General.loadSaved("search_branch_name")
        let ft17 = General.loadSaved("search_paygrade")
        let ft18 = General.loadSaved("search_job")
        let ft19 = General.loadSaved("search_rank")
        let ft20 = General.loadSaved("search_military_base")
        let ft21 = General.loadSaved("search_dependent")
        
        if(isVerified == "1"){
            if(ft1 != "" || ft2 != "" || ft3 != "" || ft4 != "" || ft5 != "" ||
                ft6 != "" || ft7 != "" || ft8 != "" || ft9 != "" || ft10 != "" ||
                ft11 != "" || ft12 != "" || ft13 != "" || ft14 != "" || ft15 != "" ||
                ft16 != "" || ft17 != "" || ft18 != "" || ft19 != "" || ft20 != "" || ft21 != ""){
                
                //MARK: Track user is Verified User Executes Search
                let uid = General.loadSaved("user_id")
                Mixpanel.mainInstance().identify(distinctId: uid)
                Mixpanel.mainInstance().track(event: "Refine Button Search",
                                              properties: ["Refine Button Search" : "Refine Button Search"])

            }
            
        }
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func clearClicked(sender: UIButton) {
        
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "FilterCheckboxListVC") {
            let VC = segue.destinationViewController as! FilterCheckboxListVC
            VC.type = type
        }
        if(segue.identifier == "FilterRankVC") {
            let VC = segue.destinationViewController as! FilterRankVC
            VC.type = type
        }
    }
    
}
