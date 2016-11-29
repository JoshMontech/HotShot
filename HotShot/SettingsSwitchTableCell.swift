//
//  SettingsSwitchTableCell.swift
//  HotShot
//
//  Created by Jerry on 11/1/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class SettingsSwitchTableCell: UITableViewCell {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let config = Config.sharedInstance
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        let title = titleLabel.text!
        if title == config.settingsPowerSaverTitle {
            appDelegate.powerSavingModeIsOn = sender.isOn
        } else if title == config.settingsAutoRecordTitle {
            appDelegate.autoRecordAtLaunchIsOn = sender.isOn
        } else if title == config.settingsDisplaySpeedTitle {
            appDelegate.shouldShowSpeedInfo = sender.isOn
        }
    }
    
}
