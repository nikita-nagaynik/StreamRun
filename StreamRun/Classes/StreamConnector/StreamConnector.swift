//
//  StreamConnector.swift
//  StreamRun
//
//  Created by Nikita Nagajnik on 18/10/14.
//  Copyright (c) 2014 rrunfa. All rights reserved.
//

import Foundation

class StreamConnector: NSObject {
    
    func startTaskForUrl(url: String, quality: String) {
        let path = self.pathForUrl(url, quality: quality)
        self.taskForPath(path).launch()
    }
    
    func checkOnlineForService(url: String) -> Bool {
        var streamInfo = self.outputDataForUrl(url)
        let error = streamInfo.substringToIndex(5);
        return error != "error"
    }
    
    func qualitiesForService(url: String) -> [String] {
        var streamInfo = self.outputDataForUrl(url)
        
        streamInfo = streamInfo.stringByReplacingOccurrencesOfString("(best)", withString: "")
        streamInfo = streamInfo.stringByReplacingOccurrencesOfString("(worst, best)", withString: "")
        streamInfo = streamInfo.stringByReplacingOccurrencesOfString("(worst)", withString: "")
        
        var components = streamInfo.componentsSeparatedByString(":") as! [String]
        streamInfo = components[1]
        streamInfo = streamInfo.stringByReplacingCharactersInRange(NSRange(location: 0, length: 1), withString: "")
        streamInfo = streamInfo.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        components = streamInfo.componentsSeparatedByString(",") as! [String]
        
        return components
    }
    
    func outputDataForUrl(url: String) -> NSString {
        let path = self.pathForUrl(url)
        
        let task = self.taskForPath(path)
        task.standardOutput = NSPipe()
        
        let file = task.standardOutput.fileHandleForReading
        
        task.launch()
        
        let data = file.readDataToEndOfFile()
        var stringData: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        return stringData
    }
    
    func taskForPath(path: String) -> NSTask {
        let task = NSTask()
        task.launchPath = "/bin/bash"
        task.arguments = ["-l", "-c", path]
        return task
    }
    
    func pathForUrl(url: String, quality: String? = nil) -> String {
        var path = String(format: "%@ %@", "livestreamer", url)
        if let q = quality {
            path = path.stringByAppendingString(String(format: " %@", q))
        }
        return path
    }
}
