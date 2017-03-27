//
//  Reachability.swift
//  DogTags
//
//  Created by Vijayakumar on 11/5/15.
//  Copyright (c) 2015 Vijayakumar. All rights reserved.
//

import Foundation

public class Reachability {
    /**
    * Check if internet connection is available
    */
    class func isConnectedToNetwork() -> Bool {
        var status:Bool = false
        
        let url = NSURL(string: "http://google.com")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 8.0
        
        var response:NSURLResponse?
        
        var data = (try? NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        
        return status
    }
}