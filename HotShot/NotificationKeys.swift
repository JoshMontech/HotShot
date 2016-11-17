//
//  NotificationKeys.swift
//  HotShot
//
//  Created by Jerry on 11/15/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import Foundation

private let _sharedInstance = NotificationKeys()

class NotificationKeys {
    class var sharedInstance: NotificationKeys {
        return _sharedInstance
    }
    
    let displaySpeedKey = "displaySpeed"
    let recordAtLaunchKey = "recordAtLaunch"
    let powerSaverKey = "powerSaver"
}
