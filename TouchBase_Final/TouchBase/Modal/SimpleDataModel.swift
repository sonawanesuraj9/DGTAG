//
//  SimpleDataModel.swift
//  TouchBase
//
//  Created by vijay kumar on 12/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation
import ObjectMapper

class SimpleDataModel: Mappable {
    
    var id: String?
    var name: String?
    
    required init?(_ map: Map) {}
    
    required init?(value1: String, value2: String) {
        id = value1
        name = value2
    }
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        
        if map.JSONDictionary["ethnicity"] != nil {
            name   <- map["ethnicity"]
        } else if map.JSONDictionary["language"] != nil {
            name   <- map["language"]
        } else if map.JSONDictionary["gender"] != nil {
            name   <- map["gender"]
        } else if map.JSONDictionary["relationship"] != nil {
            name   <- map["relationship"]
        } else if map.JSONDictionary["branch_name"] != nil {
            name   <- map["branch_name"]
        }
    }
    
    func set(value1: String, value2: String) {
        id = value1
        name = value2
    }
}
