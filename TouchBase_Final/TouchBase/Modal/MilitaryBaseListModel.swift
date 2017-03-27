//
//  MilitaryBaseListModel.swift
//  DogTags
//
//  Created by vijay kumar on 29/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class MilitaryBaseListModel: Mappable {
    
    var id: String?
    var base_name: String?
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        if map.JSONDictionary["base_name"] != nil {
            id    <- map["id"]
            base_name   <- map["base_name"]
        } else {
            id = "0"
            base_name   <- map["message"]
        }
    }
}

