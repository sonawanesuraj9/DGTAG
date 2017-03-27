//
//  PaygradeListModel.swift
//  DogTags
//
//  Created by vijay kumar on 29/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class PaygradeListModel: Mappable {
    
    var id: String?
    var paygrade: String?
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        paygrade   <- map["paygrade"]
    }
}

