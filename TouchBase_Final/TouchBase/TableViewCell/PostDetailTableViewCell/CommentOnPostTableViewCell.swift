//
//  CommentOnPostTableViewCell.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 01/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class CommentOnPostTableViewCell: UITableViewCell {

    
//TODO: - General
    
    
//TODO: - Controls
    
    @IBOutlet weak var imgDogTag: UIImageView!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblBranch: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblOtherName: UILabel!
    @IBOutlet weak var imgOtherProfile: UIImageView!
    
    
//TODO: - Let's Code
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
