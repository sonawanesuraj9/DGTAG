//
//  MessagePersonListModel.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 14/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation

class MessagePersonListModel {
    
    
    var user_fullname : String
    var user_message : String
    var user_profile : String
    var user_id : String
    var usenderid : String
    var ureceiverid : String
    var premUser : String
    var unread_messages : String
    
    init?(user_fullname:String,
          user_message:String,
          user_profile:String,
          user_id:String,
          usenderid:String,
          ureceiverid:String,
          premUser:String,
          unread_messages:String
        
        ) {
        
        self.user_fullname = user_fullname
        self.user_message = user_message
        self.user_profile = user_profile
        self.user_id = user_id
        self.usenderid = usenderid
        self.ureceiverid = ureceiverid
        self.premUser = premUser
        self.unread_messages = unread_messages
    }
    
}