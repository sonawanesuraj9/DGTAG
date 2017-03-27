//
//  PostDetailTableViewCell.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 01/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {

    
//TODO: - General
    
//TODO: - Controls
    
    @IBOutlet  var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgVideoPlayIcon: UIImageView!
    @IBOutlet weak var lblPostDate: UILabel!
    @IBOutlet weak var lblCommentName: UILabel!
    @IBOutlet weak var lblLikeName: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgDogTags: UIImageView!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var btnLikes: UIButton!
    @IBOutlet weak var txtPost: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
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
