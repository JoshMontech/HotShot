//
//  VideoLengthOptions.swift
//  HotShot
//
//  Created by Jerry on 11/1/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import Foundation

enum VideoLengthOptions: Int {
    case thirtySeconds = 0, twoMinutes, threeMinutes, fiveMinutes, tenMinutes
    
    var description: String {
        switch self {
        case .thirtySeconds:
            return "30 sec"
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
}
