//
//  AppNetworkFetcher.swift
//  DogTags
//
//  Created by vijay kumar on 28/09/16.
//  Copyright © 2016 viji kumar. All rights reserved.
//

import Haneke

public class AppNetworkFetcher<T: DataConvertible> : NetworkFetcher<T> {
    
    public override var session : NSURLSession {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = [
            "Session-Id": "your_session_id",
            "Client-Version": "your_app_version"
        ]
        
        // Set the method to POST
        //request.HTTPMethod = "POST"
        return NSURLSession(configuration: configuration)
    }
    
    public override init(URL : NSURL) {
        super.init(URL: URL)
    }
}
