//
//  SearchResultTableViewCell.swift
//  TouchBase
//
//  Created by Vijay Kumar on 02/09/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    //TODO: - General
    
    //TODO: - Controls
    
    @IBOutlet weak var imgDogTag: UIImageView!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var btnOtherProfile: UIButton!
    @IBOutlet weak var btnFollowUn: UIButton!
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    
    var followBtnTapped : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func followButton(sender: AnyObject) {
        if let followBtnTapped = self.followBtnTapped {
            followBtnTapped()
        }
    }
    
}
