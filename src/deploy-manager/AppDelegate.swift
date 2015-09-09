//
//  AppDelegate.swift
//  deploy-manager
//
//  Created by Tobias Schultka on 14.03.15.
//  Copyright (c) 2015 Tobias Schultka. All rights reserved.
//

import Cocoa

let delegate = NSApplication.sharedApplication().delegate as! AppDelegate

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var backupCount: NSSlider!
    @IBOutlet weak var backupCountDisplay: NSTextField!
    @IBOutlet weak var commitMessage: NSTextField!
    @IBOutlet weak var devBranchName: NSTextField!
    @IBOutlet weak var pathButton: NSButton!
    @IBOutlet var console: NSTextView!

    // start applicaition
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // remove initial focus
        window.makeFirstResponder(nil)
        
        // load saved app settings from storage
        loadAppData()
    }
    
    // reopen app after closing it
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        window.makeKeyAndOrderFront(self)
        window.makeFirstResponder(nil)
        return true
    }
    
    // terminate application
    func applicationWillTerminate(aNotification: NSNotification) {}
    
    // select project folder
    @IBAction func selectProject(sender: AnyObject) {
        setProjectPath()
    }
    
    // backup button
    @IBAction func backupButton(sender: AnyObject) {
        startTasks("backup")
    }
    
    // pull button
    @IBAction func pullButton(sender: AnyObject) {
        startTasks("pull")
    }
    
    // deploy button
    @IBAction func deployButton(sender: AnyObject) {
        startTasks("deploy")
    }
}

