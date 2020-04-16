//
//  AppDelegate.swift
//  gol
//
//  Created by Gadi Lifshitz on 14/04/2020.
//  Copyright © 2020 Gadi Lifshitz. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        print("app will terminate")
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        print("should I terminate? Oh, yes..")
        return true
    }
    
    
}
