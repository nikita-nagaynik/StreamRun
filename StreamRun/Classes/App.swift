//
//  App.swift
//  StreamRun
//
//  Created by Nikita Nagaynik on 17/07/15.
//  Copyright (c) 2015 rrunfa. All rights reserved.
//

import Cocoa
import Foundation
import AppKit

class NSApp: NSApplication {
    
    override class func sharedApplication() -> NSApplication {
        return super.sharedApplication()
    }
    
    override func sendEvent(event: NSEvent) {
        if event.type == .KeyDown {
            if (event.modifierFlags & .DeviceIndependentModifierFlagsMask) == .CommandKeyMask {
                if event.charactersIgnoringModifiers == "v" {
                    self.sendAction("onPaste", to: nil, from: self);
                    return
                }
            }
        }
        super.sendEvent(event)
    }
}