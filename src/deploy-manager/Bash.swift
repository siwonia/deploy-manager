//
//  Bash.swift
//  deploy-manager
//
//  Created by Tobias Schultka on 18.04.15.
//  Copyright (c) 2015 Tobias Schultka. All rights reserved.
//

import Foundation

// execute bash and return true on success
func isBashTrue(bash: String) -> Bool {
    return runBashs(getBashIfElse(bash)) == "true"
}

// execute bash in project folder and return true on success
func isPathBashTrue(bash: String) -> Bool {
    return runBashs(["cd \(getProjectPath())"] + getBashIfElse(bash)) == "true"
}

// execute bash in project folder
func runPathBashs(bashs: [String]) -> String {
    return runBashs(["cd " + getProjectPath()] + bashs)
}

// execute bash bash
func runBashs(bashs: [String]) -> String {
    
    // define bash task
    let task = NSTask()
    task.launchPath = "/bin/sh"
    task.arguments = ["-c", getSingleBashFromArray(bashs)]
    
    // create pipe and run task
    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()
    
    // read bash output
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    
    // encode output
    var output = NSString(data: data, encoding: NSUTF8StringEncoding)! as String

    // remove \n from the end
    if (output.length >= 2 &&
        output[output.length - 1...output.length - 1] == "\n") {
        output = output[0...output.length - 2]
    }
    
    return output
}

// get bash if else
private func getBashIfElse(bash: String) -> [String] {
    return [
        "if \(bash); then",
            "echo \"true\"",
        "else",
            "echo \"false\"",
        "fi"
    ]
}

// get bash bash from task array
private func getSingleBashFromArray(bashs: [String]) -> String {
    var bash = ""
    
    for line: String in bashs {
        bash += "\n\(line)"
    }
    
    return bash
}
