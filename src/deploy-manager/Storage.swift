//
//  Storage.swift
//  deploy-manager
//
//  Created by Tobias Schultka on 19.04.15.
//  Copyright (c) 2015 Tobias Schultka. All rights reserved.
//

import Foundation

// get app data from storage
func loadAppData() {
    delegate.commitMessage.stringValue = getStorage("commit", "") as! String
    delegate.devBranchName.stringValue = getStorage("branch", "") as! String
    
    let projectPath = getStorage("path", "") as! String
    let projectPathSplit = projectPath.componentsSeparatedByString("/")
    
    // set button title
    delegate.pathButton.title = projectPath != ""
        ? projectPathSplit[projectPathSplit.endIndex - 2]
        : "Find"
    
    // get backup count
    let count = getStorage("backupCount", 3) as! Int
    delegate.backupCount.integerValue = count
    delegate.backupCountDisplay.stringValue = String(count)
}

// save app data in storage
func saveAppData() {
    setStorage("commit", delegate.commitMessage.stringValue)
    setStorage("branch", delegate.devBranchName.stringValue)
    setStorage("backupCount", delegate.backupCount.integerValue)
}

// get text from storage
func getStorage(key: String, defaultValue: AnyObject) -> AnyObject {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // check if storage key exists
    if let value: AnyObject = userDefaults.valueForKey(key) {
        return value
    } else {
        return defaultValue
    }
}

// set text to storage
func setStorage(key: String, value: AnyObject) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    userDefaults.setObject(value, forKey: key)
    userDefaults.synchronize()
}
