//
//  SettingsTableViewController.swift
//  HotShot
//
//  Created by Jake Mayo on 10/17/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    let standardCellIdentifier = "SettingsStandardCell"
    let logOutCellIdentifier = "SettingsLogoutCell"
    let switchCellIdentifier = "SettingsSwitchCell"
    let segmentedControlCellIdentifier = "SettingsSegmentedCell"
    
    enum CellTypes {
        case standardCell, switchCell, segmentedControlCell, logoutCell
    }
    
    enum Sections: Int {
        case recording = 0, general, account, logout
        
        static let count: Int = {
            var max = 0
            
            while Sections(rawValue: max) != nil {
                max += 1
            }
            
            return max
        }()
    }
    
    enum GeneralSettings: Int {
        case powerSaving = 0, about
        
        var cellType: CellTypes {
            switch self {
            case .powerSaving:
                return CellTypes.switchCell
            case .about:
                return CellTypes.standardCell
            }
        }
        
        static let count: Int = {
            var max = 0
            
            while GeneralSettings(rawValue: max) != nil {
                max += 1
            }
            
            return max
        }()
    }
    
    enum AccountSettings: Int {
        case email = 0, passWord, firstName, lastName, cloud
        
        var cellType: CellTypes {
            switch self {
            case .cloud:
                return CellTypes.standardCell
            case .email:
                return CellTypes.standardCell
            case .firstName:
                return CellTypes.standardCell
            case .lastName:
                return CellTypes.standardCell
            case .passWord:
                return CellTypes.standardCell
            }
        }
        
        static let count: Int = {
            var max = 0
            
            while AccountSettings(rawValue: max) != nil {
                max += 1
            }
            
            return max
        }()
    }
    
    enum RecordSettings: Int {
        case lengthOfClip = 0, numberOfClipsSaved, travelingSpeedUnit, speed, autoRecord
        
        static let count: Int = {
            var max = 0
            
            while RecordSettings(rawValue: max) != nil {
                max += 1
            }
            
            return max
        }()
        
        var cellType: CellTypes {
            switch self {
            case .autoRecord:
                return CellTypes.switchCell
            case .lengthOfClip:
                return CellTypes.segmentedControlCell
            case .numberOfClipsSaved:
                return CellTypes.segmentedControlCell
            case .speed:
                return CellTypes.switchCell
            case .travelingSpeedUnit:
                return CellTypes.segmentedControlCell
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of Sections
        return Sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case Sections.general.rawValue:
            return GeneralSettings.count
        case Sections.account.rawValue:
            return AccountSettings.count
        case Sections.recording.rawValue:
            return RecordSettings.count
        case Sections.logout.rawValue:
            return 1
        default:
            return 0
        }

    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Sections.account.rawValue:
            return "Account"
        case Sections.general.rawValue:
            return "General"
        case Sections.recording.rawValue:
            return "Recording"
        default:
            return ""
        }
    }
    
    
//    override func tableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        let indexValue = (indexPath.section, indexPath.row)
        
        switch indexValue {
        case (Sections.general.rawValue, GeneralSettings.powerSaving.rawValue):
            let switchCell = self.getCell(cellType: .switchCell) as! SettingsSwitchTableCell
            switchCell.titleLabel.text = "Power Saving Mode"
            cell = switchCell
        case (Sections.general.rawValue, GeneralSettings.about.rawValue):
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel!.text = "About"
        case (Sections.account.rawValue, AccountSettings.cloud.rawValue):
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel!.text = "Cloud"
        case (Sections.account.rawValue, AccountSettings.firstName.rawValue):
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel!.text = "First Name"
        case (Sections.account.rawValue, AccountSettings.lastName.rawValue):
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel!.text = "Second Name"
        case (Sections.account.rawValue, AccountSettings.email.rawValue):
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel!.text = "Email"
        case (Sections.account.rawValue, AccountSettings.passWord.rawValue):
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel!.text = "Password"
        case (Sections.recording.rawValue, RecordSettings.autoRecord.rawValue):
            let switchCell = self.getCell(cellType: .switchCell) as! SettingsSwitchTableCell
            switchCell.titleLabel.text = "Auto Record"
            cell = switchCell
        case (Sections.recording.rawValue, RecordSettings.speed.rawValue):
            let switchCell = self.getCell(cellType: .switchCell) as! SettingsSwitchTableCell
            switchCell.titleLabel.text = "Speed"
            cell = switchCell
        case (Sections.recording.rawValue, RecordSettings.travelingSpeedUnit.rawValue):
            let segmentedCell = self.getCell(cellType: .segmentedControlCell) as! SettingsSegmentedControlTableCell
            segmentedCell.titleLabel.text = "Speed Unit"
            cell = segmentedCell
        case (Sections.recording.rawValue, RecordSettings.numberOfClipsSaved.rawValue):
            let segmentedCell = self.getCell(cellType: .segmentedControlCell) as! SettingsSegmentedControlTableCell
            segmentedCell.titleLabel.text = "Number of Clips Saved"
            cell = segmentedCell
        case (Sections.recording.rawValue, RecordSettings.lengthOfClip.rawValue):
            let segmentedCell = self.getCell(cellType: .segmentedControlCell) as! SettingsSegmentedControlTableCell
            let lengthOptions = VideoLengthOptions.self
            let newSegmentWidth = segmentedCell.settingsSegmentedControl.widthForSegment(at: 0) * 0.6
            print(segmentedCell.settingsSegmentedControl.widthForSegment(at: 0))
            print(newSegmentWidth)
            segmentedCell.settingsSegmentedControl.setTitle(lengthOptions.thirtySeconds.description, forSegmentAt: lengthOptions.thirtySeconds.rawValue)
            segmentedCell.settingsSegmentedControl.setTitle(lengthOptions.twoMinutes.description, forSegmentAt: lengthOptions.twoMinutes.rawValue)
            segmentedCell.settingsSegmentedControl.insertSegment(withTitle: lengthOptions.threeMinutes.description, at: lengthOptions.threeMinutes.rawValue, animated: false)
            segmentedCell.settingsSegmentedControl.insertSegment(withTitle: lengthOptions.fiveMinutes.description, at: lengthOptions.fiveMinutes.rawValue, animated: false)
            segmentedCell.settingsSegmentedControl.insertSegment(withTitle: lengthOptions.tenMinutes.description, at: lengthOptions.tenMinutes.rawValue, animated: false)
            
            for i in 0 ..< segmentedCell.settingsSegmentedControl.numberOfSegments {
                segmentedCell.settingsSegmentedControl.setWidth(newSegmentWidth, forSegmentAt: i)
            }
            
            
            segmentedCell.titleLabel.text = "Video Length"
            cell = segmentedCell
        case (Sections.logout.rawValue, 0):
            let logoutCell = self.getCell(cellType: .logoutCell) as! SettingsLogoutTableCell
            logoutCell.logoutLabel.textColor = UIColor.red
            logoutCell.logoutLabel.text = "Log Out"
            cell = logoutCell
        default:
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel!.text = "Default"
        }
        
        return cell
    }
    
    private func getCell(cellType: CellTypes) -> UITableViewCell{
        switch cellType {
        case .standardCell:
            return tableView.dequeueReusableCell(withIdentifier: standardCellIdentifier)!
        case .logoutCell:
            return tableView.dequeueReusableCell(withIdentifier: logOutCellIdentifier)!
        case .segmentedControlCell:
            return tableView.dequeueReusableCell(withIdentifier: segmentedControlCellIdentifier)!
        case .switchCell:
            return tableView.dequeueReusableCell(withIdentifier: switchCellIdentifier)!
        }
    }

}
