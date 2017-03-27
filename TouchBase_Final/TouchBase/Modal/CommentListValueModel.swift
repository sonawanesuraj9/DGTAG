//
//  CommentListValueModel.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 14/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation


class CommentListValueModel {
    
    var postID: String
    var cmt_user_id:String
    var comment:String
    var cmt_date:String
    var user_fullname:String
    var user_profile_pic:String
   
    var user_branch:String
    var user_city:String
    var user_state:String
    var dogtag_batch:String
    var cmt_id:String
    var is_comment:String
    var user_country:String
    var abbrivation:String
    
    init?(postID: String, cmt_user_id: String, comment: String,cmt_date:String,user_fullname:String,user_profile_pic:String,
          user_city:String,
          user_state:String,
          dogtag_batch:String,
          cmt_id:String,
          is_comment:String,
          user_country:String,
          user_branch:String,
          abbrivation:String) {
        
        self.postID = postID
        self.cmt_user_id = cmt_user_id
        self.comment = comment
        self.cmt_date = cmt_date
        self.user_fullname = user_fullname
        self.user_profile_pic = user_profile_pic
        
        self.user_branch = user_branch
        self.user_city = user_city
        self.user_state = user_state
        self.dogtag_batch = dogtag_batch
        self.cmt_id = cmt_id
        self.is_comment = is_comment
        self.user_country = user_country
        self.abbrivation = abbrivation
    }
    
}