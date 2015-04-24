//
//  StoreService.swift
//  StreamRun
//
//  Created by Nikita Nagajnik on 18/10/14.
//  Copyright (c) 2014 rrunfa. All rights reserved.
//

import Foundation

class StoreService: NSObject {
    
    class func parseStreams() -> [String: StreamerData]? {
        var streamersDataList: [String: StreamerData] = [:]
        if let json = self.jsonFromFile("streams", fileType: "json") {
            for (name, streams) in json.dictionaryValue {
                var streamsDataList: [StreamData] = []
                for (number, description) in streams.dictionaryValue {
                    let service = description["service"].stringValue
                    let channel = description["channel"].stringValue
                    let streamData = StreamData(name: name, service: service, channel: channel)
                    streamsDataList.append(streamData)
                }
                streamersDataList.updateValue(StreamerData(name: name, streams: streamsDataList), forKey: name)
            }
            return streamersDataList
        }
        return nil
    }
    
    class func parseSettings() -> Settings? {
        var settings: [String: AnyObject] = Dictionary(minimumCapacity: 2)
        if let json = self.jsonFromFile("settings", fileType: "json") {
            return Settings(fromJson: json)
        }
        return nil
    }
    
    class func storeSettings(settings: Settings) {
        saveFile("settings", fileType: "json", content: settings.json().rawString()!)
    }
    
    class func jsonFromFile(fileName: String, fileType: String) -> JSON? {
        if let dataString = self.readFile(fileName, fileType: fileType) {
            let data = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            return JSON(data: data!)
        }
        return nil
    }
    
    class func readFile(fileName: String, fileType: String) -> String? {
        var filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
        var contents = NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil)
        return String(contents!)
    }
    
    class func saveFile(fileName: String, fileType: String, content: String) {
        var filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
        content.writeToFile(filePath!, atomically: true, encoding: NSUTF8StringEncoding, error: nil);
    }
}
