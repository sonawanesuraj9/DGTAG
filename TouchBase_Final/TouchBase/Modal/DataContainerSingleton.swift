//
//  DataContainerSingleton.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 14/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation
import UIKit



class DataContainerSingleton
{
    static let sharedDataContainer = DataContainerSingleton()
    
    //------------------------------------------------------------
    //Add properties here that you want to share accross your app
    var someString: String?
    var someOtherString: String?
    var someInt: Int?
    
    //PostDetails 
    var postID: String?
    var postContent: String?
    var postCaption: String?
    var postImage: String?
    var postLikeCount : String?
    var postCommentCount : String?
    var isPostLike : String?
    var postDate : String?
    var video_thumb : String?
    var postAuthor : String?
    //------------------------------------------------------------
    
   
}