//
//  ChatValueModel.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 15/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation


class ChatValueModel {
    
    var user_senderid: String
    var user_receiverid:String
    var user_message:String
    var message_date:NSDate
    var type : String
   
    
    init?(user_senderid: String,
          user_receiverid: String,
          user_message: String,
          message_date:NSDate,
          type : String
          ) {
        
        self.user_senderid = user_senderid
        self.user_receiverid = user_receiverid
        self.user_message = user_message
        self.message_date = message_date
        self.type = type
        
    }
    
}