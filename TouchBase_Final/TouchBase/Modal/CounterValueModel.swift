//
//  CounterValueModel.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 12/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit


class CounterValueModel {
    
    
    var commentCount : String
    var likeCount : String
    var isLike : String
    
    init?(commentCount:String,
          likeCount:String,
          isLike:String
        ) {
        
        self.commentCount = commentCount
        self.likeCount = likeCount
        self.isLike = isLike
        
    }
    
}