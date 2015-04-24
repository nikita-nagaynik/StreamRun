//
//  StreamData.swift
//  StreamRun
//
//  Created by Nikita Nagajnik on 18/10/14.
//  Copyright (c) 2014 rrunfa. All rights reserved.
//

import Foundation

enum StreamStatus: UInt {
    case NA = 0
    case Offline
    case Online
}

class StreamData: NSObject {
    let name: String
    let service: String
    let channel: String
    
    var status: StreamStatus
    var serviceClient: StreamServiceClient?
    var streamUrlGen: ((String, String) -> String) = { $0 + "/" + $1 }
    
    init(name: String, service: String, channel: String) {
        self.name = name;
        self.service = service;
        self.channel = channel;
        self.status = .NA
    }
    
    func stremUrl() -> String {
        return streamUrlGen(service, channel)
    }
    
//    func description() -> String {
//        return String(format: "%@", self.name)
//    }
}

func >(left: StreamData, right: StreamData) -> Bool {
    return left.status.rawValue > right.status.rawValue
}

func <(left: StreamData, right: StreamData) -> Bool {
    return right > left
}

func ==(left: StreamData, right: StreamData) -> Bool {
    return left.status.rawValue == right.status.rawValue
}

func !=(left: StreamData, right: StreamData) -> Bool {
    return !(left == right)
}