//
//  StreamServiceClient.swift
//  StreamRun
//
//  Created by Nikita Nagajnik on 18/10/14.
//  Copyright (c) 2014 rrunfa. All rights reserved.
//

import Foundation

protocol StreamServiceClient {
    func checkOnlineChannel(channel: String, result: (Bool, Bool) -> ())
}