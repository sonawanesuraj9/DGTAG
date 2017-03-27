//
//  FilterCheckboxCell.swift
//  TouchBase
//
//  Created by vijay kumar on 10/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit
import DLRadioButton

class FilterCheckboxCell: UITableViewCell {
    
    @IBOutlet weak var button: DLRadioButton!
    
    var onChildBtnTapped : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func onChildButton(sender: AnyObject) {
        if let onChildBtnTapped = self.onChildBtnTapped {
            onChildBtnTapped()
        }
    }
    
}