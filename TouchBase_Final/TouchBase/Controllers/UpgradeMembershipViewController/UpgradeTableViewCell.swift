//
//  UpgradeTableViewCell.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 27/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class UpgradeTableViewCell: UITableViewCell {

    //TODO: - Controls
    
   
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var imgDogTag: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnSelection: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
