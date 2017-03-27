//
//  Urls.swift
//  TouchBase
//
//  Created by Suraj MAC3 on 29/08/16.
//  Copyright © 2016 Suraj MAC3. All rights reserved.
//

import UIKit

struct Urls_UI {
    
    static var BASE_URL = "https://milpeeps.com/dt-admin/"
    
    static var LOGIN = BASE_URL + "user/signin/"
    static var REGISTER_STEP1 = BASE_URL + "user/register"
    static var REGISTER_STEP2 = BASE_URL + "user/details/"
    static var REGISTER_STEP3 = BASE_URL + "user/verification/"
    
    
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
    
    static var CREATE_NEW_POST = BASE_URL + "posts/addpost/"
    static var EDIT_POST = BASE_URL + "posts/editpost/"
    static var EDIT_CAPTION = BASE_URL + "posts/editcaption/"
    
    static var CHANGE_PASSWORD = BASE_URL + "user/changepass/"
    static var FORGOT_PASSWORD = BASE_URL + "user/forgotpassword/"
    static var REPROT_PROBLEM = BASE_URL + "problem/report/"
    
    
    static var UPGRADE_MEMBERSHIP = BASE_URL + "user/upgrade/"
    
    static var UPDATE_DEVICE_TOKEN = BASE_URL + "user/device_token/"

    //Read Notification
    static var READ_LIKE_COUNT = BASE_URL + "posts/viewlikes/"
    //static var READ_COMMENT_COUNT = BASE_URL + "posts/viewcomments/"
    static var READ_COMMENT_COUNT = BASE_URL + "posts/readnotify/"
    static var READ_EACH_COMMENT_COUNT = BASE_URL + "posts/readnotifypost/"
    
    
    
    static var UPDATE_BADGE = BASE_URL + "user/reset_badge/"
    
    //Messaging
    static var LIST_MESSAGE_THREAD = BASE_URL + "messages/getmessage_receiver/"
    static var ONE_TO_ONE_MESSAGE = BASE_URL + "messages/getmessage_information/"
    static var SEND_MESSAGE = BASE_URL + "messages/send_newmessage/"
    static var FETCH_USER_LIST = BASE_URL + "user/list_user/"
    static var FETCH_NEW_MESSAGE_COUNT = BASE_URL + "messages/unread/"
    static var READ_MESSAGE_COUNT = BASE_URL + "messages/read_messages/"
    static var CLEAR_MESSAGE_THREAD = BASE_URL + "messages/del_chat_temp/"
    //  static var CLEAR_MESSAGE_THREAD = BASE_URL + "messages/del_chat/"
   
    
    static var FETCH_APP_COUNT = BASE_URL + "/user/notify_counts_notify/"
    //  static var FETCH_APP_COUNT = BASE_URL + "/user/notify_counts/"

    
    
    //Followers
    static var FOLLOWERS_FOLOWING_COUNT = BASE_URL + "follow/follower/"
    static var FOLLOWER_REQUEST_LIST = BASE_URL + "follow/followrequest/"
    static var FOLLOW_BACK = BASE_URL + "follow/followrequestback/"
    static var APPROVE_FOLLOWER_REQUEST = BASE_URL + "follow/approve/"
    static var LIST_FOLLOWERS = BASE_URL + "follow/followerlist/"
    static var DECLINE_FOLLOW_REQUEST = BASE_URL + "follow/declined/"
    
    
    //Following
    static var LIST_FOLLOWING = BASE_URL + "follow/followingrequest/"
    static var UNFOLLOW_FOLLOWING = BASE_URL + "follow/unfollow/"
    
    static var LIKE_COUNT = BASE_URL + "posts/mypostlike/"
    static var COMMENT_COUNT = BASE_URL + "posts/mypostcmt/"
    
    
    //POST
    static var LIST_POST = BASE_URL + "activity/myfeedsindex/"
    static var SINGLE_POST = BASE_URL + "activity/singlefeeds/"
    

    //static var LIST_POST = BASE_URL + "activity/myfeeds/"
    
    static var LIKE_POST = BASE_URL + "posts/likepost/"
    static var UNLIKE_POST = BASE_URL + "posts/unlike/"
    static var COMMENT_LIST = BASE_URL + "posts/commentlist/"
    static var ADD_NEW_COMMENT = BASE_URL + "/posts/commentnotify/"
    //static var ADD_NEW_COMMENT = BASE_URL + "/posts/comment/"
    
    
    static var EDIT_COMMENT = BASE_URL + "/posts/editcomment/"
    static var MY_POST_LIST = BASE_URL + "/posts/myposts/"
    static var MY_POST_DELETE = BASE_URL + "/posts/delete/"
    
    static var REPORT_POST = BASE_URL + "posts/reportpost/"
    static var BLOCK_FOLLOWER = BASE_URL + "follow/block/"
    
    static var OTHER_USER_PROFILE = BASE_URL + "user/other_profile/"
    static var MY_POST_LIST_INDEX = BASE_URL + "posts/mypostsindex/"
    
    
    //Comment
    static var DELETE_MY_COMMENT = BASE_URL + "posts/delete_comment/"
    
    
    //DogTags
    static var CHANGE_DOGTAG = BASE_URL + "dogtag/mydogtag/"
    
    //Notification
    static var FETCH_LIKE_NOTIFICATION = BASE_URL + "posts/like_users/"
    static var FETCH_COMMENT_NOTIFICATION = BASE_URL + "posts/participant/"
    // static var FETCH_COMMENT_NOTIFICATION = BASE_URL + "posts/comment_users/"
    
    
    
    
    //Logout
    static var LOGOUT_USER = BASE_URL + "/user/logout/"
    
    //Profile
    static var PROFILE_PUBLIC_PRIVATE = BASE_URL + "user/ispublic/"
    static var DELETE_ACCOUNT = BASE_URL + "user/deleteacc/"
    
    
    
    
    //References
    static var MY_REFERENCE_LIST = BASE_URL + "user/myreference/"
    static var APPROVE_REFERENCE = BASE_URL + "user/approveref/"
    
    
    //Block List
    static var BLOCKED_USERS_LIST = BASE_URL + "follow/blocklist/"
    static var UNBLOCK_USER = BASE_URL + "follow/unblock/"
    
    
    
}
