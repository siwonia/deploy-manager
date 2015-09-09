//
//  Extensions.swift
//  deploy-manager
//
//  Created by Tobias Schultka on 18.03.15.
//  Copyright (c) 2015 Tobias Schultka. All rights reserved.
//

import Foundation

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}

extension String {
    var length: Int {
        return count(self)
    }
}