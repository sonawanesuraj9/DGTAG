//
//  PostNotificationTableViewCell.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 04/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class PostNotificationTableViewCell: UITableViewCell {

    //TODO: - General
    
    
    //TODO: - Controls
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgPost: UIImageView!
   // @IBOutlet weak var imgUser: UIImageView!
   // @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnUser: UIButton!
    //@IBOutlet weak var btnPost: UIButton!
    //@IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
