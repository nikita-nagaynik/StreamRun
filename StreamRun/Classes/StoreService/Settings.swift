//
//  Settings.swift
//  StreamRun
//
//  Created by Nikita Nagaynik on 16/02/15.
//  Copyright (c) 2015 rrunfa. All rights reserved.
//

import Foundation

class Settings {
    var refreshTime: Double = 120.0
    var showOffline: Int = 0
    
    init(fromJson json: JSON) {
        refreshTime = json["refreshTime"].doubleValue
        showOffline = json["showOffline"].intValue
    }
    
    func json() -> JSON {
        return JSON(["refreshTime": refreshTime, "showOffline": showOffline])
    }
}