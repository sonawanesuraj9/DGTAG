//
//  SearchCityModel.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 06/12/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation

class SearchCityModel {
    
    var id : String
    var city : String
    
    init?(id:String,
          city:String
        ) {
        
        self.id = id
        self.city = city
    }

    
    
   /* var id: String?
    var city: String?
    
    required init?(_ map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        city   <- map["city"]
       
    }*/
}