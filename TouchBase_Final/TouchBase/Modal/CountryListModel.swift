//
//  CountryListModel.swift
//  DogTags
//
//  Created by vijay kumar on 28/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class CountryListModel: Mappable {
    
    var id: String?
    var abbreviation: String?
    var country: String?
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        abbreviation   <- map["abbreviation"]
        country   <- map["country"]
    }
}