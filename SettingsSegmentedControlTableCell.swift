//
//  SettingsSegmentedControlTableCell.swift
//  HotShot
//
//  Created by Jerry on 11/1/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class SettingsSegmentedControlTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingsSegmentedControl: UISegmentedControl!
    
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    }
}
