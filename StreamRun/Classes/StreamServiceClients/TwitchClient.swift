//
//  TwitchClient.swift
//  StreamRun
//
//  Created by Nikita Nagajnik on 19/10/14.
//  Copyright (c) 2014 rrunfa. All rights reserved.
//

import Foundation

class TwitchClient: NSObject, StreamServiceClient {
    
    func checkOnlineChannel(channel: String, result: (Bool, Bool) -> ()) {
        let url = NSURL(string: "https://api.twitch.tv/kraken/streams".stringByAddQueryParams(["channel": channel]))
        
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            let request = NSURLRequest(URL: url!)
            var response: NSURLResponse?
            var error: NSError?
            var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
            dispatch_async(dispatch_get_main_queue()) {
                if let d = data {
                    let json = JSON(data: d)
                    result(json["streams"].arrayValue.count > 0, false)
                } else {
                    result(false, true)
                }
            }
        }
    }
}
