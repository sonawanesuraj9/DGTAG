//
//  UsersListModelNew.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 11/11/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//


import Foundation

class UserListModelNew {
    
    var user_id: String
    var user_fullname: String
    var user_profile_pic: String
    var user_type: String
    var user_loc_country: String
    var user_loc_state: String
    var user_loc_city: String
    var user_branch: String
    var is_follower: String
    var abbrivation: String
    var dogtag_batch: String
    var is_requested: String
    init?(user_id:String,
          user_fullname:String,
          user_profile_pic:String,
          user_type:String,
          user_loc_country:String,
          user_loc_state:String,
          user_loc_city:String,
          user_branch:String,
          is_follower:String,
          abbrivation:String,
          dogtag_batch:String,
          is_requested:String
        ) {
        
        self.user_id = user_id
        self.user_fullname = user_fullname
        self.user_profile_pic = user_profile_pic
        self.user_type = user_type
        self.user_loc_country = user_loc_country
        self.user_loc_state = user_loc_state
        self.user_loc_city = user_loc_city
        self.user_branch = user_branch
        self.is_follower = is_follower
        self.abbrivation = abbrivation
        self.dogtag_batch = dogtag_batch
        self.is_requested = is_requested
        
    }
    
}