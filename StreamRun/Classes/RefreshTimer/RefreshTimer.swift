//
//  RefreshTimer.swift
//  StreamRun
//
//  Created by Nikita Nagajnik on 19/10/14.
//  Copyright (c) 2014 rrunfa. All rights reserved.
//

import Cocoa

class RefreshTimer: NSObject {

    let refreshTime: Double
    let action: () -> ()
    
    var timer: NSTimer?
    
    init(refreshTime: Double, action: () -> ()) {
        self.refreshTime = refreshTime
        self.action = action
    }
    
    func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(
            refreshTime,
            target: self,
            selector: "onTimer",
            userInfo: nil,
            repeats: true
        )
    }
    
    func onTimer() {
        action()
    }
    
    func stop() {
        if let t = timer {
            t.invalidate()
        }
        timer = nil
    }
}
