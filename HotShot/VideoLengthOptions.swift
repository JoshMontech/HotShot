//
//  VideoLengthOptions.swift
//  HotShot
//
//  Created by Jerry on 11/1/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import Foundation

enum VideoLengthOptions: Int {
    case thirtySeconds = 0, oneMinute, twoMinutes, threeMinutes, fiveMinutes, tenMinutes
    
    var description: String {
        switch self {
        case .thirtySeconds:
            return "30 sec"
        case .oneMinute:
            return "1 min"
        case .twoMinutes:
            return "2 min"
        case .threeMinutes:
            return "3 min"
        case .fiveMinutes:
            return "5 min"
        case .tenMinutes:
            return "10 min"
        }
    }
    
    var valueInMinutes: Double {
        switch self {
        case.thirtySeconds:
            return 0.5
        case .oneMinute:
            return 1.0
        case .twoMinutes:
            return 2.0
        case .threeMinutes:
            return 3.0
        case .fiveMinutes:
            return 5.0
        case .tenMinutes:
            return 10.0
        }
    }
    
    static let count: Int = {
        var max = 0
        
        while VideoLengthOptions(rawValue: max) != nil {
            max += 1
        }
        
        return max
    }()
}
