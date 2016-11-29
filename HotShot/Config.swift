//
//  Config.swift
//  HotShot
//
//  Created by Jerry on 11/2/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class Config {
    static let sharedInstance = Config()
    let recordGreen = UIColor(red:0.31, green:0.56, blue:0.13, alpha:1.00)
    let burntOrange = UIColor(red: 191/255, green: 87/255, blue: 0, alpha: 1)
    let starYellow = UIColor(red:0.91, green:0.64, blue:0.15, alpha:1.00)
    
    let settingsPowerSaverTitle = "Power Saving Mode"
    let settingsDisplaySpeedTitle = "Display Speed"
    let settingsAutoRecordTitle = "Auto Record at Launch"
}
