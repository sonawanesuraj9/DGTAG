//
//  postContainerSingleton.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 18/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation
import UIKit



class postContainerSingleton
{
    static let postData = postContainerSingleton()
    
    //------------------------------------------------------------
    //Add properties here that you want to share accross your app
   
    //PostDetails
    var postID: String?
    var postContent: String?
    var postCaption: String?
    var postImage: String?
    var vid_thumb : String?
     
    //------------------------------------------------------------
    
    
}