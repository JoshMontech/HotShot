//
//  SettingsSwitchTableCell.swift
//  HotShot
//
//  Created by Jerry on 11/1/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class SettingsSwitchTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        print("Jake")
    }
    
}
