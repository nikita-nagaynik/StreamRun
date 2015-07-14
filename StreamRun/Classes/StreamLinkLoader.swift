//
//  StreamLinkLoader.swift
//  StreamRun
//
//  Created by Nikita Nagaynik on 14/07/15.
//  Copyright (c) 2015 rrunfa. All rights reserved.
//

import Foundation

class StreamLinkLoader {
    func loadStreams(done: (json: JSON?) -> Void) {
        let urlString = "https://www.dropbox.com/s/qjk5xmiq3ok3fh5/StreamRunStreams.json?dl=1"
        var finalPath: NSURL!
        
        request(.GET, urlString).response { (_, _, data, _) -> Void in
            if let data = data as? NSData {
                done(json: JSON(data: data))
            }
        }
    }
}