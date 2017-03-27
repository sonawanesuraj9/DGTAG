//
//  MyPostValueModel.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 15/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation


class MyPostValueModel {
    var post_date : String
    var post_type : String
    var post_content : String
    var photo_video : String
    var video_thumb : String
    var post_caption : String
    var like_count : String
    var comment_count : String
    var is_like : String
    var post_id : String
    
    
    init?(post_date: String,
          post_type:String,
          post_content: String,
          video_thumb: String,
          photo_video:String,
          post_caption:String,
          like_count:String,
          comment_count:String,
          is_like:String,
          post_id:String
        ) {
        
        self.post_date = post_date
        self.post_type = post_type
        self.post_content = post_content
        self.video_thumb = video_thumb
        self.photo_video = photo_video
        self.post_caption = post_caption
        self.post_content = post_content
        
         self.like_count = like_count
         self.comment_count = comment_count
         self.is_like = is_like
        self.post_id = post_id        
    }
    
}