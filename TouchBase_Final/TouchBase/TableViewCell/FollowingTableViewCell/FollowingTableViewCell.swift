//
//  FollowingTableViewCell.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 08/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class FollowingTableViewCell: UITableViewCell {

    
//TODO: - Controls
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var btnOtherUser: UIButton!
    @IBOutlet weak var imgDogTags: UIImageView!
    @IBOutlet weak var btnUnfollow: UIButton!
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}