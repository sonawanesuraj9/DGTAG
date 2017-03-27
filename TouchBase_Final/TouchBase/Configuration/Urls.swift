//
//  Urls.swift
//  golfapp
//
//  Created by Vijayakumar on 11/17/15.
//  Copyright © 2015 Vijayakumar. All rights reserved.
//

import UIKit

struct Urls {
    
    static var BASE_URL = "https://milpeeps.com/dt-admin/"
    
    static var LOGIN = BASE_URL + ""
    static var REGISTER_STEP1 = BASE_URL + "user/register"
    static var REGISTER_STEP2 = BASE_URL + "user/details/"
    static var REGISTER_STEP3 = BASE_URL + "user/verification/"
    
    static var LIST_USER_TYPE = BASE_URL + "user/getutype/"
    static var LIST_COUNTRY = BASE_URL + "user/getcountry/"
    static var LIST_STATES = BASE_URL + "user/getstates/"
    static var LIST_CITIES = BASE_URL + "user/getcities/"
    static var LIST_GENDER = BASE_URL + "user/getgender/"
    static var LIST_ETHNICITY = BASE_URL + "user/getethnicity/"
    static var LIST_BRANCH = BASE_URL + "user/getbranch/"
    static var LIST_MILITARY_BASE = BASE_URL + "user/getmilitarybase/"
    static var LIST_PAYGRADE_ACTIVE = BASE_URL + "user/getactivepay/"
    static var LIST_PAYGRADE_RESERVE = BASE_URL + "user/getreservepay/"
    static var LIST_RELATIONSHIP = BASE_URL + "user/ralationship/"
    static var LIST_LANGUAGES = BASE_URL + "user/getlanguage/"
    static var LIST_JOB_AND_RANK = BASE_URL + "user/getrankjob/"
    
    static var PROFILE_VIEW = BASE_URL + "user/get_userdetails/"
    static var PROFILE_EDIT = BASE_URL + "user/details_update/"
    static var PROFILE_EDIT_PHOTO = BASE_URL + "user/update_profilepic/"
    
    static var PROFILE_LOCK_FIELD = BASE_URL + "user/get_userdetails_islocked/"
    static var PROFILE_PUBLIC_PRIVATE = BASE_URL + "user/ispublic/"
    
    static var ProfilePic_Base_URL = BASE_URL + "images/userprofile/"
    static var POSTVideo_Base_URL = BASE_URL + "images/posts/"
    
    static var USERS_LIST = BASE_URL + "search/searchindex/"
    //static var USERS_LIST = BASE_URL + "search/searchlist/"
    
    static var RANDOM_USERS_LIST = BASE_URL + "search/randomlist/"
    static var FOLLOW_USER = BASE_URL + "follow/sendrequest"
    static var UNFOLLOW_USER = BASE_URL + "follow/unfollow/"
    

    
}
