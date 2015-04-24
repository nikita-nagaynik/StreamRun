//
//  GoodgameClient.swift
//  StreamRun
//
//  Created by Nikita Nagaynik on 12/02/15.
//  Copyright (c) 2015 rrunfa. All rights reserved.
//

import Foundation

class GoodgameClient: NSObject, StreamServiceClient {
    
    func checkOnlineChannel(channel: String, result: (Bool, Bool) -> ()) {
        let url = NSURL(string: "http://goodgame.ru/api/getggchannelstatus".stringByAddQueryParams(["id": channel, "fmt": "json"]))
        
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            let request = NSURLRequest(URL: url!)
            var response: NSURLResponse?
            var error: NSError?
            if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error) {
                let json = JSON(data: data)
                for part in enumerate(json.dictionaryValue) {
                    dispatch_async(dispatch_get_main_queue()) {
                        result(part.element.1["status"].stringValue == "Live", false)
                    }
                }
            }
        }
    }
}