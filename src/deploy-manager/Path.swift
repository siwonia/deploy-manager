//
//  Path.swift
//  deploy-manager
//
//  Created by Tobias Schultka on 18.04.15.
//  Copyright (c) 2015 Tobias Schultka. All rights reserved.
//

import Foundation
import Cocoa

// get project path
func getProjectPath() -> String {
    return getStorage("path", "") as! String
}

// set project path
func setProjectPath() {
    var openPanel = NSOpenPanel()
    
    openPanel.canChooseDirectories = true
    openPanel.canChooseFiles = false
    openPanel.canCreateDirectories = false
    openPanel.allowsMultipleSelection = false
    
    if (openPanel.runModal() == NSModalResponseOK) {
        var projectPath = "\(openPanel.URLs[0] as! NSURL)"
        
        projectPath = projectPath.stringByReplacingOccurrencesOfString("file://", withString: "")
        setStorage("path", projectPath)
    }
}
