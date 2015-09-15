//
//  Log.swift
//  deploy-manager
//
//  Created by Tobias Schultka on 22.04.15.
//  Copyright (c) 2015 Tobias Schultka. All rights reserved.
//

import Foundation

// console log
func log(isValid: Bool, text: String) {

    // define log icon
    let logIcon = isValid ? "✓" : "✗"

    logLine("\(logIcon) \(text)")
}

// log text to console
func logLine(text: String) {
    
    // write output into text view
    let console = delegate.console.textStorage
    console!.mutableString.setString("\(text)\n\(console!.string)")
}
