//
//  MessagePersonTableViewCell.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 31/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class MessagePersonTableViewCell: UITableViewCell {

//TODO: - General
    
//TODO: - Controls
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imgBadge: UIImageView!
    @IBOutlet weak var lblSenderMessage: UILabel!
    @IBOutlet weak var lblSenderName: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
//TODO: - Let's Code    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width/2
        imgProfilePic.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
