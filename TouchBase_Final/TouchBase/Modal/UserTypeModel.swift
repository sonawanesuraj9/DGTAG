//
//  UserTypeModel.swift
//  DogTags
//
//  Created by vijay kumar on 04/10/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class UserTypeModel: Mappable {
    
    var id: String?
    var user_type: String?
    var type_descr: String?
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        user_type   <- map["user_type"]
        type_descr   <- map["type_descr"]
    }
}
