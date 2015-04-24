//
//  NSColor+Hex.swift
//  StreamRun
//
//  Created by Nikita Nagajnik on 19/10/14.
//  Copyright (c) 2014 rrunfa. All rights reserved.
//

import Foundation
import AppKit
import Cocoa

extension NSColor {
    
    var R: CGFloat {
        return CGColorGetComponents(self.CGColor)[0];
    }
    
    var G: CGFloat {
        return CGColorGetComponents(self.CGColor)[1];
    }
    
    var B: CGFloat {
        return CGColorGetComponents(self.CGColor)[2];
    }
    
    class func colorByHex(hex: String) -> NSColor {
        return self.colorByHex(hex, alpha: 1.0)
    }
    
    class func colorByHex(hex: NSString, alpha: CGFloat) -> NSColor {
        let set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var cString: NSString = hex.stringByTrimmingCharactersInSet(set).uppercaseString
        
        if cString.length < 6 {
            return NSColor.grayColor()
        }
        
        if cString.hasPrefix("0X") {
            cString = cString.substringFromIndex(2)
        }
        
        if cString.length != 6 {
            return NSColor.grayColor()
        }
        
        var range = NSRange(location: 0, length: 2)
        let rString = cString.substringWithRange(range)
        
        range.location = 2
        let gString = cString.substringWithRange(range)
        
        range.location = 4
        let bString = cString.substringWithRange(range)
        
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        let _r: CGFloat = CGFloat(r) / CGFloat(255)
        let _g: CGFloat = CGFloat(g) / CGFloat(255)
        let _b: CGFloat = CGFloat(b) / CGFloat(255)
        
        return NSColor(red: _r, green: _g, blue: _b, alpha: alpha)
    }
}