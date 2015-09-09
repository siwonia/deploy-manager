//
//  Branch.swift
//  deploy-manager
//
//  Created by Tobias Schultka on 18.04.15.
//  Copyright (c) 2015 Tobias Schultka. All rights reserved.
//

import Foundation

let REFS_HEADS = "refs/heads/"
let BACKUP_NAME = "backup-"
let BACKUP_DATE_FORMAT = "yyyy-MM-dd-HH-mm-ss"

// get branches
func getBranches() -> [String] {
    var normalizedBranches: [String] = []
    
    // get all branch names
    let branchesString = runPathBashs([
        "git for-each-ref --format='%(refname)' \(REFS_HEADS)"
    ])
    
    // split branches string into array
    var branches = branchesString.componentsSeparatedByString("\n")
    
    // filter backup branches
    for branch: String in branches {
        
        // check if branch name has is long enough
        if (count(branch) <= count(REFS_HEADS)) {
            continue
        }
        
        // append branch name to array
        normalizedBranches.append(
            branch[count(REFS_HEADS)...count(branch) - 1]
        )
    }
    
    log(true, "Found \(normalizedBranches.count) branches")
    
    return normalizedBranches
}

// remove local and remote dev branch
func removeDevBranch(devBranch: String) {
    
    // delete local dev branch
    if (isPathBashTrue("git show-ref --verify --quiet \"\(REFS_HEADS + devBranch)\"")) {
        runPathBashs(["git branch --quiet -D \(devBranch)"])
        log(true, "Removed local dev branch '\(devBranch)'")
    }
    
    // delete remote dev branch
    runPathBashs([
        "git config push.default current",
        "git push origin --delete \(devBranch) --quiet"
    ])
    
    log(true, "Removed remote dev branch '\(devBranch)'")
}

// create dev branch
func createDevBranch(devBranch: String) {
    
    // create and checkout dev branch
    runPathBashs(["git checkout --quiet -b \(devBranch)"])
    log(true, "Created and checked out '\(devBranch)'")
    
    // push to remote branch
    runPathBashs([
        "git config push.default current",
        "git push origin \(devBranch) --quiet"
    ])
    
    log(true, "Pushed '\(devBranch)' to remote")
}

// remove backup branches
func removeBackupBranches(branches: [String], backupCount: Int) {
    var backupBranches: [String] = []
    
    // filter backup branches
    for branch: String in branches {
        
        // push branch name to backups array
        if (count(branch) == count(BACKUP_NAME + BACKUP_DATE_FORMAT) &&
            branch[0...count(BACKUP_NAME) - 1] == BACKUP_NAME) {
                backupBranches.append(branch);
        }
    }
    
    // delete backup branches
    var counter = backupBranches.count - backupCount
    for branch: String in backupBranches {
        if (counter <= 0) {
            break
        }
        
        counter--
        
        runPathBashs([" git branch --quiet -D  \(branch)"])
        log(true, "Removed local branch '\(branch)'")
    }
}
