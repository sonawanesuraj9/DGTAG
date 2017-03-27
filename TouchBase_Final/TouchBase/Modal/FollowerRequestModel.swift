//
//  FollowerRequestModel.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 10/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit


class FollowerRequestModel {
    
    var dogtagid: String
    var name:String
    var location:String
    var country:String
    var status:String
    var profile:String
    var userID:String
    var abbreviation:String
    var is_following:String
    var is_requested:String
    init?(dogtagid: String, name: String, location: String,country:String,status:String,profile:String,userID:String,abbreviation:String,is_following:String,is_requested:String) {
        
        self.dogtagid = dogtagid
        self.name = name
        self.location = location
        self.country = country
        self.status = status
        self.profile = profile
        self.userID = userID
        self.abbreviation = abbreviation
        self.is_following = is_following
        self.is_requested = is_requested
    }
    
}