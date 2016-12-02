//
//  SettingsSpeedCell.swift
//  HotShot
//
//  Created by Jake Mayo on 11/28/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

public var selectedIndex = 0

class SettingsSpeedCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var SpeedUnitSelector: UISegmentedControl!
    
    @IBAction func unitSwitch(_ sender: Any) {
        speedMetric = SpeedUnitSelector.titleForSegment(at: SpeedUnitSelector.selectedSegmentIndex)!
        selectedIndex = SpeedUnitSelector.selectedSegmentIndex
    }
    
    
}
