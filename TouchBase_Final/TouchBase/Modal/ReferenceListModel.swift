//
//  ReferenceListModel.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 07/11/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation



class ReferenceListModel {
    
    var dogtagid: String
    var name:String
    var location:String
    var country:String
    var status:String
    var profile:String
    var userID:String
    var abbreviation:String
    init?(dogtagid: String, name: String, location: String,country:String,status:String,profile:String,userID:String,abbreviation:String) {
        
        self.dogtagid = dogtagid
        self.name = name
        self.location = location
        self.country = country
        self.status = status
        self.profile = profile
        self.userID = userID
        self.abbreviation = abbreviation
    }
    
}