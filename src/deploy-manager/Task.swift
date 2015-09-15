//
//  Run.swift
//  deploy-manager
//
//  Created by Tobias Schultka on 29.04.15.
//  Copyright (c) 2015 Tobias Schultka. All rights reserved.
//

import Foundation
import Async

func startTasks(task: String) {
    var kill = false
    var currentBranch = ""
    var backupBranch = ""
    var branches: [String] = []
    
    let commit = delegate.commitMessage.stringValue
    let devBranch = delegate.devBranchName.stringValue
    
    // save input fields in app storage
    saveAppData()

    Async
        .main {
            
            // log empty line and scroll console to top
            logLine("")
            delegate.console.scrollRangeToVisible(NSMakeRange(0, 0))
            
        }.main { if (kill) { return }
        
            // check if path exists
            if (isBashTrue("[ -d \(getProjectPath()) ]")) {
                log(true, "Project path is valid")
            } else {
                log(false, "Couldn't find \"\(getProjectPath())\" directory")
                kill = true
            }
        }.main { if (kill) { return }
            
            // check if Git is installed
            if (isPathBashTrue("[ $(which git) ]")) {
                log(true, "Git found")
            } else {
                log(false, "Git isn't installed on your machine")
                kill = true
            }
        }.main { if (kill) { return }
            
            // check if commit message is valid
            if (commit.length > 0) {
                log(true, "Commit message '\(commit)' is valid")
            } else {
                log(false, "Commit message '\(commit)' is not valid")
                kill = true
            }
        }.main { if (kill) { return }
            
            // check if dev branch name is valid
            if (devBranch.length > 0) {
                log(true, "Deploy branch name '\(devBranch)' is valid")
            } else {
                log(false, "Deploy branch name '\(devBranch)' is not valid")
                kill = true
            }
        }.main { if (kill) { return }
            
            // get current branch name
            currentBranch = runPathBashs(["git rev-parse --abbrev-ref HEAD"])
            
        }.main { if (kill) { return }
            
            // get all branches in repository
            branches = getBranches()
            
        }.main { if (kill) { return }
            
            // stage all files
            runPathBashs(["git add -A"])
            log(true, "Stages all files")
            
        }.main { if (kill) { return }
            
            var dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = BACKUP_DATE_FORMAT
            backupBranch = BACKUP_NAME + dateFormatter.stringFromDate(NSDate())
            
            // check if backup branch name already exists
            if (isPathBashTrue("git show-ref --verify --quiet \"\(REFS_HEADS + backupBranch)\"")) {
                log(false, "A branch named '\(backupBranch)' already exists")
                kill = true
            } else {
                log(true, "Backup branch name is valid")
                branches.append(backupBranch)
            }
        }.main { if (kill) { return }
            
            // create and check out backup branch
            runPathBashs(["git checkout --quiet -b \(backupBranch)"])
            log(true, "Created and checked out '\(backupBranch)'")
            
        }.main { if (kill) { return }
            
            // create commit
            let changedFiles = runPathBashs(["git status -uno --porcelain"])
            if (changedFiles != "") {
                runPathBashs(["git commit --quiet -m \'\(commit)\'"])
                log(true, "Created backup commit '\(commit)'")
            }
        }.main { if (kill) { return }
            
            // remove local and remote dev branch
            if (task == "deploy") {
                removeDevBranch(devBranch)
            }
        }.main { if (kill) { return }
            
            // create and push dev branch
            if (task == "deploy") {
                createDevBranch(devBranch)
            }
        }.main { if (kill) { return }
            
            // check out original branch
            runPathBashs(["git checkout --quiet \(currentBranch)"])
            log(true, "Checked out '\(currentBranch)'")
            
        }.main { if (kill) { return }
            
            // pull original branch
            if (task == "pull") {
                runPathBashs(["git pull --quiet"])
                log(true, "Pulled '\(currentBranch)'")
            }
        }.main { if (kill) { return }

            // cherry pick last changes from backup without a commit
            runPathBashs(["git cherry-pick -n \(backupBranch)"])
            log(true, "Cherry picked last changes from '\(backupBranch)'")
            
        }.main { if (kill) { return }
            
            // unstage all files
            if (task != "pull") {
                runPathBashs(["git reset --quiet"])
                log(true, "Unstaged all files")
            }
        }.main { if (kill) { return }
            
            // remove backup branches
            removeBackupBranches(branches, delegate.backupCount.integerValue)
            
        }.main { if (kill) { return }
            
            // done
            log(true, "Done")
    }
}