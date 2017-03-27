//
//  PostValueModel.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 10/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit


class PostValueModel {
    
    
    var postid : String
    var author : String
    var user_fullname : String
    
    var user_profile_pic : String
    var post_date : String
    var post_type : String
    
    var post_content : String
    var photo_video : String
    var post_caption : String
    
    var id : String
    var country : String
    var state : String
    
    var city : String
    var branch_name : String
    
    var commentCount : String
    var likeCount : String
    var isLike : String
    
    var dogtag_batch : String
    var abbreviation : String
    
    var video_thumb : String
    
    init?(postid: String,
          author: String,
          user_fullname: String,
          user_profile_pic:String,
          post_date:String,
          post_type:String,
          post_content:String,
          photo_video:String,
          post_caption:String,
          id:String,
          country:String,
          state:String,
          city:String,
          branch_name:String,
          commentCount:String,
          likeCount:String,
          isLike:String,
          dogtag_batch:String,
          abbreviation:String,
          video_thumb:String
          ) {
        
        self.postid = postid
        self.author = author
        
        self.user_fullname = user_fullname
        self.user_profile_pic = user_profile_pic
        
        self.post_date = post_date
        self.post_type = post_type
        
        self.post_content = post_content
        self.photo_video = photo_video
        
        self.post_caption = post_caption
        self.id = id
        
        self.country = country
        self.state = state
        
        self.city = city
        self.branch_name = branch_name
        
        self.commentCount = commentCount
        self.likeCount = likeCount
        self.isLike = isLike
       
        self.dogtag_batch = dogtag_batch
        self.abbreviation = abbreviation
      
        self.video_thumb = video_thumb
    }
    
}


class CommentBackValueModel {
    
    
    var postid : String
    var author : String
    var user_fullname : String
    
    var user_profile_pic : String
    var post_date : String
    var post_type : String
    
    var post_content : String
    var photo_video : String
    var post_caption : String
    
    var id : String
    var country : String
    var state : String
    
    var city : String
    var branch_name : String
    
    var commentCount : String
    var likeCount : String
    var isLike : String
    
    var dogtag_batch : String
    var abbreviation : String
    
    var video_thumb : String
    
    var author_fullName : String
    var author_profilePic : String
    
    
    init?(postid: String,
          author: String,
          user_fullname: String,
          user_profile_pic:String,
          post_date:String,
          post_type:String,
          post_content:String,
          photo_video:String,
          post_caption:String,
          id:String,
          country:String,
          state:String,
          city:String,
          branch_name:String,
          commentCount:String,
          likeCount:String,
          isLike:String,
          dogtag_batch:String,
          abbreviation:String,
          video_thumb:String,
          author_fullName:String,
          author_profilePic:String
        ) {
        
        self.postid = postid
        self.author = author
        
        self.user_fullname = user_fullname
        self.user_profile_pic = user_profile_pic
        
        self.post_date = post_date
        self.post_type = post_type
        
        self.post_content = post_content
        self.photo_video = photo_video
        
        self.post_caption = post_caption
        self.id = id
        
        self.country = country
        self.state = state
        
        self.city = city
        self.branch_name = branch_name
        
        self.commentCount = commentCount
        self.likeCount = likeCount
        self.isLike = isLike
        
        self.dogtag_batch = dogtag_batch
        self.abbreviation = abbreviation
        
        self.video_thumb = video_thumb
        self.author_fullName = author_fullName
        self.author_profilePic = author_profilePic
    }
    
}