//
//  UsersListModel.swift
//  TouchBase
//
//  Created by vijay kumar on 12/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation
import ObjectMapper

class UsersListModel: Mappable {
    
    var user_id: String?
    var user_fullname: String?
    var user_profile_pic: String?
    var user_type: String?
    var user_loc_country: String?
    var user_loc_state: String?
    var user_loc_city: String?
    var user_branch: String?
    var is_follower: String?
    var abbrivation: String?
    var dogtag_batch: String?
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        user_id    <- map["user_id"]
        user_fullname   <- map["user_fullname"]
        user_profile_pic   <- map["user_profile_pic"]
        user_type   <- map["user_type"]
        user_loc_country   <- map["user_loc_country"]
        user_loc_state   <- map["user_loc_state_abbr"]
        user_loc_city   <- map["user_loc_city"]
        user_branch   <- map["user_branch"]
        is_follower   <- map["is_follower"]
        abbrivation   <- map["user_loc_abbreviation"]
        dogtag_batch   <- map["dogtag_batch"]
    }
}