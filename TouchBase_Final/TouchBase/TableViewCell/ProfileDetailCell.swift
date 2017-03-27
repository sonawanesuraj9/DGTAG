//
//  ProfileDetailCell.swift
//  DogTags
//
//  Created by vijay kumar on 03/10/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import UIKit

class ProfileDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}