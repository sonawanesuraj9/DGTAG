//
//  userinfoCotainerSingleton.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 22/10/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import Foundation

class userinfoCotainerSingleton
{
    static let userinfo = userinfoCotainerSingleton()
    
    //------------------------------------------------------------
    //Add properties here that you want to share accross your app
    
    //PostDetails
    var userID: String?
    var fullname: String?
    var location: String?
    var country: String?
    var dogTag_batch: String?
    var profileurl: String?
    var status: String?
     var abbrivation: String?
    //------------------------------------------------------------
    
    
   
    
    
}


class userDetailsSingleton{
    static let userDT = userDetailsSingleton()
    
    //------------------------------------------------------------
    //Add properties here that you want to share accross your app
    
    //PostDetails
    var userID: String?
    var fullname: String?
    var location: String?
    var country: String?
    var dogTag_batch: String?
    var profileurl: String?
    var status: String?
    var abbrivation: String?
    //------------------------------------------------------------
    
    
}