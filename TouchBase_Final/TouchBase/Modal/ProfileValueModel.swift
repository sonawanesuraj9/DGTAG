//
//  ProfileValueModel.swift
//  DogTags
//
//  Created by vijay kumar on 03/10/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import UIKit

class ProfileValueModel {
    
    var name: String
    var detail:String
    var lock:String
    
    init?(name: String, detail: String, lock: String) {
        
        self.name = name
        self.detail = detail
        self.lock = lock
        
    }
    
}