//
//  CityListModel.swift
//  DogTags
//
//  Created by vijay kumar on 29/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class CityListModel: Mappable {
    
    var id: String?
    var city = "N/A" // var city: String?
    //var name = "N/A"
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        city   <- map["city"]
    }
}
