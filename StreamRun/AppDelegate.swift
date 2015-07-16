//
//  AppDelegate.swift
//  StreamRun
//
//  Created by Nikita Nagajnik on 18/10/14.
//  Copyright (c) 2014 rrunfa. All rights reserved.
//

import Foundation
import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,
    NSTableViewDataSource,
    NSTableViewDelegate,
    NSUserNotificationCenterDelegate,
    NSMenuDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var addChannelWindow: NSPanel!
    @IBOutlet var channelsText: NSTextView!
    @IBOutlet weak var table: NSTableView!
    @IBOutlet weak var showOfflineCheckmark: NSButton!
    @IBOutlet weak var preferencesWindow: NSPanel!
    
    var streamConnector = StreamConnector()
    var streamers: [String: StreamerData]!
    var visibleStreams: [StreamData]!
    
    var settings: Settings!
    var refreshTime: Double!
    var refreshTimer: RefreshTimer!
    var linkLoader: StreamLinkLoader!
    
    var statusBar: NSStatusItem!
    var streamsOpened: Bool = false
    
    override func awakeFromNib() {
        statusBar = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
        statusBar.highlightMode = true
        statusBar.title = "S"
        statusBar.menu = NSMenu()
        statusBar.menu?.autoenablesItems = false
        statusBar.menu?.delegate = self;
    }
    
    func menuWillOpen(menu: NSMenu) {
        menu.removeAllItems()
        if NSEvent.pressedMouseButtons() == 2 {
            menu.addItem(NSMenuItem(title: "Show from clipboard", action: "onPaste:", keyEquivalent: ""))
        } else {
            streamsOpened = true;
            updateMenuToStreams(menu);
        }
    }
    
    func menuDidClose(menu: NSMenu) {
        streamsOpened = false;
    }
    
    func updateMenuToStreams(menu: NSMenu) {
        menu.removeAllItems()
        if visibleStreams == nil || visibleStreams.count == 0 {
            let item = NSMenuItem(title: "All offline", action: nil, keyEquivalent: "")
            item.enabled = false
            menu.addItem(item)
        } else {
            for (index, stream) in enumerate(visibleStreams) {
                let item = NSMenuItem(title: getVisibleName(index), action: "menuItemClicked:", keyEquivalent: "")
                item.enabled = true
                item.tag = index
                menu.addItem(item);
            }
        }
    }
    
    func menuItemClicked(sender: NSMenuItem) {
        streamConnector.startTaskForUrl(visibleStreams[sender.tag].stremUrl(), quality: "best")
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
        table.doubleAction = "doubleClick"
        
        let reachability = Reachability.reachabilityForInternetConnection()
        reachability.whenReachable = { reachability in
            self.scanForOnlineWithNotification(false)
        }
        reachability.startNotifier()
        
        linkLoader = StreamLinkLoader();
        linkLoader.loadStreams { (json) -> Void in
            self.loadStreams(json!)
            self.refreshTimer.start()
        }
    }
    
    @IBAction func onPaste(sender: AnyObject) {
        let pasteboard = NSPasteboard.generalPasteboard()
        let url = pasteboard.stringForType(NSPasteboardTypeString)
        if let url = url {
            streamConnector.startTaskForUrl(url, quality: "best")
        }
    }
    
    func loadStreams(json: JSON) {
        if let streamers = StoreService.parseStreams(json) {
            self.streamers = streamers
        }
        if let settings = StoreService.parseSettings() {
            self.settings = settings
            self.showOfflineCheckmark.state = self.settings.showOffline
            refreshTimer = RefreshTimer(refreshTime: settings.refreshTime) {
                self.scanForOnlineWithNotification(true)
            }
        }
        self.setupServiceClients()
        self.scanForOnlineWithNotification(false)
    }
    
    func sortByOnline() {
        refreshVisibleStreams()
        visibleStreams.sort { $0 > $1 }
    }
    
    func refreshVisibleStreams() {
        self.visibleStreams = []
        for streamer in streamers {
            for stream in streamer.1.streams {
                if self.showOfflineCheckmark.state == 0 {
                    if stream.status == .Online {
                        visibleStreams.append(stream)
                    }
                } else {
                    visibleStreams.append(stream)
                }
            }
        }
    }
    
    func applicationShouldHandleReopen(theApplication: NSApplication,
        hasVisibleWindows flag: Bool) -> Bool {
            window.setIsVisible(true)
            return true
    }
    
    @IBAction func addChannelClick(sender: AnyObject) {
        self.populateChannelsText()
        window.beginSheet(addChannelWindow) { (let response) in
            
        }
    }

    @IBAction func preferencesClick(sender: AnyObject) {
        window.beginSheet(preferencesWindow) { (let response) in
            
        }
    }
    
    @IBAction func donePreferencesClick(sender: AnyObject) {
        window.endSheet(preferencesWindow)

        self.settings.showOffline = self.showOfflineCheckmark.state
        StoreService.storeSettings(self.settings)
        scanForOnlineWithNotification(true)
    }
    
    func populateChannelsText() {
        let streamsContent = StoreService.readFile("streams", fileType: "json")
        if let text = streamsContent {
            channelsText.string = text
        }
    }
    
    @IBAction func doneAddChannelsClick(sender: AnyObject) {
        window.endSheet(addChannelWindow)
    }
    
    @IBAction func saveChannelsClick(sender: AnyObject) {
        StoreService.saveFile("streams", fileType: "json", content: channelsText.string!)
    }
    
    func setupServiceClients() {
        for streamer in streamers {
            for streamData in streamer.1.streams {
                switch streamData.service {
                case "twitch.tv":
                    streamData.serviceClient = TwitchClient()
                case "cybergame.tv":
                    streamData.serviceClient = CybergameClient()
                case "goodgame.ru":
                    streamData.serviceClient = GoodgameClient()
                    streamData.streamUrlGen = { (service, channel) in
                        return service + "/channel/" + channel + "/"
                    }
                default:
                    println("No service client for: \(streamData.service)")
                }
            }
        }
    }
    
    func scanForOnlineWithNotification(useNotification: Bool) {
        for streamer in streamers {
            for streamData in streamer.1.streams {
                if let client = streamData.serviceClient {
                    client.checkOnlineChannel(streamData.channel, result: { online, ignore in
                        if ignore {
                            return
                        }
                        if useNotification && streamData.status == .Offline && online {
                            self.showNotificationByTitle(streamData.name)
                        }
                        streamData.status = online ? .Online: .Offline
                        self.sortByOnline()
                        self.table.reloadData()
                        if self.streamsOpened {
                            self.updateMenuToStreams(self.statusBar.menu!)
                        }
                    })
                }
            }
        }
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter,
        shouldPresentNotification notification: NSUserNotification) -> Bool {
            return true
    }
    
    func showNotificationByTitle(title: String) {
        let not = NSUserNotification()
        
        not.title = title;
        not.informativeText = String(format: "%@ %@", title, "stream is online");
        not.soundName = nil;
    
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(not);
    }
    
    func doubleClick() {
        let row = table.selectedRow
        if row < visibleStreams.count {
            streamConnector.startTaskForUrl(visibleStreams[row].stremUrl(), quality: "best")
        }
    }

    
    //MARK: - TableDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let count = visibleStreams?.count {
            return count
        }
        return 0
    }
    
    func tableView(
        tableView: NSTableView,
        objectValueForTableColumn
        tableColumn: NSTableColumn?,
        row: Int) -> AnyObject? {
            
            return getVisibleName(row)
    }
    
    func getVisibleName(row: Int) -> String {
        let streamData = visibleStreams[row]
        let streamer = streamers[streamData.name]
        if streamer?.streams.filter({ $0.status == StreamStatus.Online }).count > 1 {
            return "\(streamData.name) (\(streamData.service))"
        }
        return streamData.name
    }
    
    func tableView(tableView: NSTableView, willDisplayCell cell: AnyObject, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        let cell = cell as! NSTextFieldCell
        let service = visibleStreams[row].service
        let channel = visibleStreams[row].channel
        let status = visibleStreams[row].status
        
        if status == .Online {
            cell.textColor = NSColor.colorByHex("10A83F")
        } else if status == .Offline {
            cell.textColor = NSColor.colorByHex("C40E14")
        } else {
            cell.textColor = NSColor.darkGrayColor()
        }
    }
}

