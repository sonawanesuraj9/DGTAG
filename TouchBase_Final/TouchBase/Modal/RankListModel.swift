//
//  RankListModel.swift
//  DogTags
//
//  Created by vijay kumar on 29/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class RankListModel: Mappable {
    
    var id: String?
    var rank: String?
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        if map.JSONDictionary["rank"] != nil {
            rank   <- map["rank"]
        } else if map.JSONDictionary["job"] != nil {
            rank   <- map["job"]
        }
    }
}
