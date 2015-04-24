//
//  StreamerData.swift
//  StreamRun
//
//  Created by Nikita Nagaynik on 16/02/15.
//  Copyright (c) 2015 rrunfa. All rights reserved.
//

import Foundation

class StreamerData {
    
    let streams: [StreamData]
    let name: String
    
    init(name: String, streams: [StreamData]) {
        self.streams = streams
        self.name = name
    }
}