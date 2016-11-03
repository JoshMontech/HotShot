//
//  SavedTempVideoNumberOptions.swift
//  HotShot
//
//  Created by Jerry on 11/1/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import Foundation

enum SavedTempVideoNumberOptions: Int {
    case zero = 0, one, two, three, five, ten
    
    var description: String {
        switch self {
        case .zero:
            return "None"
        case .one:
            return "One"
        case .two:
            return "Two"
        case .three:
            return "Three"
        case .five:
            return "Five"
        case .ten:
            return "Ten"
        }
    }
    
    var value: Int {
        switch self {
        case .zero:
            return 0
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .five:
            return 5
        case .ten:
            return 10
        }
    }
    
    static let count: Int = {
        var max = 0
        
        while SavedTempVideoNumberOptions(rawValue: max) != nil {
            max += 1
        }
        
        return max
    }()
}
