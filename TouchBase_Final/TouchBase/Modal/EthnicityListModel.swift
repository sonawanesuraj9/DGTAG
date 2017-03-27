//
//  EthnicityListModel.swift
//  DogTags
//
//  Created by vijay kumar on 29/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class EthnicityListModel: Mappable {
    
    var id: String?
    var ethnicity: String?
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        ethnicity   <- map["ethnicity"]
    }
}
