//
//  JobListModel.swift
//  DogTags
//
//  Created by vijay kumar on 29/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class JobListModel: Mappable {
    
    var id: String?
    var job: String?
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        job   <- map["job"]
    }
}