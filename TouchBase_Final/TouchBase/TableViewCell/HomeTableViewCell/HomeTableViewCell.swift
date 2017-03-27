//
//  HomeTableViewCell.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 30/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    
//TODO: - Controls
    
    //MARK: Top Constraint for post content
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var postTopConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var btnMoreWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imgVidThumb: UIImageView!
    @IBOutlet weak var lblPostDate: UILabel!
    @IBOutlet weak var likerView: UIView!
    @IBOutlet weak var lblCommentNames: UILabel!
    @IBOutlet weak var lblLikeNames: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var btnOtheruserProfile: UIButton!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var btnDropDownClick: UIButton!
   // @IBOutlet weak var btnSharePost: UIButton!
    @IBOutlet weak var btnOption: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgDogTags: UIImageView!
  //  @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnLikes: UIButton!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
//TODO: Let's Code    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        //imgProfile.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
