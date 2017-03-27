//
//  FilterAgeSelecterVC.swift
//  TouchBase
//
//  Created by vijay kumar on 12/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
///Users/pramodshirsath/Desktop/TouchBase_Final/Podfile

import UIKit
import ZMSwiftRangeSlider

class FilterAgeSelecterVC: UIViewController {
    
    @IBOutlet weak var rangeSlider1: RangeSlider!
    @IBOutlet weak var textRange: UILabel!
    private var rangeValues = Array(13...120)
    
    var min = 21
    var max = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if var age:String = General.loadSaved("search_age") {
            self.textRange.text = age
            
            let dataList = age.characters.split{$0 == "-"}.map(String.init)
            if let zone = dataList.first {
                min = Int(zone)!
            }
            if let zone = dataList.last {
                max = Int(zone)!
            }
            
        }
        
        rangeSlider1.setRangeValues(rangeValues)
        rangeSlider1.setMinAndMaxValue(min, maxValue: max)
        
        rangeSlider1.setValueChangedCallback { (minValue, maxValue) in
            self.textRange.text = "\(minValue)-\(maxValue)"
        }
        rangeSlider1.setMinValueDisplayTextGetter { (minValue) -> String? in
            return "\(minValue)"
        }
        rangeSlider1.setMaxValueDisplayTextGetter { (maxValue) -> String? in
            return "\(maxValue)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveClicked(sender: UIButton) {
        General.saveData(self.textRange.text!, name: "search_age")
        //MARK: Save filter is On
        General.saveData("1", name: "isFilterApplied")

        self.navigationController?.popViewControllerAnimated(true)
    }
    
}