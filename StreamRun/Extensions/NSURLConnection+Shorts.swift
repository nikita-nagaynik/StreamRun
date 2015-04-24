//
//  NSURLConnection+Shorts.swift
//  StreamRun
//
//  Created by Nikita Nagaynik on 12/02/15.
//  Copyright (c) 2015 rrunfa. All rights reserved.
//

import Foundation

extension NSURLConnection {
    class func sendAsynchronousRequest(request: NSURLRequest, completionHandler handler: (NSURLResponse!, NSData!, NSError!) -> Void) {
        sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: handler)
    }
}