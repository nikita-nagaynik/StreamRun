//
//  GCD+Shorts.swift
//  StreamRun
//
//  Created by Nikita Nagaynik on 20/02/15.
//  Copyright (c) 2015 rrunfa. All rights reserved.
//

import Foundation

class Gcd {
    class func dispatchAfter(seconds: UInt, after: () -> ()) {
        let time = dispatch_time(DISPATCH_TIME_NOW,  Int64(Double(seconds) * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), after)
    }
    
    class func dispatchAfter(seconds: UInt, queue: dispatch_queue_t!, after: () -> ()) {
        let time = dispatch_time(DISPATCH_TIME_NOW,  Int64(Double(seconds) * Double(NSEC_PER_SEC)))
        dispatch_after(time, queue, after)
    }
}