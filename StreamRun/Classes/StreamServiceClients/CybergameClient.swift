//
//  CybergameClient.swift
//  StreamRun
//
//  Created by Nikita Nagajnik on 18/10/14.
//  Copyright (c) 2014 rrunfa. All rights reserved.
//

import Foundation

class CybergameClient: NSObject, StreamServiceClient {
    
    func checkOnlineChannel(channel: String, result: (Bool, Bool) -> ()) {
        let url = NSURL(string: "http://api.cybergame.tv/w/streams.php".stringByAddQueryParams(["channel": channel]))
        
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            let request = NSURLRequest(URL: url!)
            var response: NSURLResponse?
            var error: NSError?
            if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error) {
                let json = JSON(data: data)
                dispatch_async(dispatch_get_main_queue()) {
                    result(json["online"].boolValue, false)
                }
            }
        }
    }
}
