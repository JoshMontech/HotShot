//
//  SettingsTableViewController.swift
//  HotShot
//
//  Created by Jake Mayo on 10/17/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
    let standardCellIdentifier = "SettingsStandardCell"
    let logOutCellIdentifier = "SettingsLogoutCell"
    let switchCellIdentifier = "SettingsSwitchCell"
    let showVideoOptionsSegueIdentifier = "ShowVideoOptionsSegue"
    
    enum CellTypes {
        case standardCell, switchCell, logoutCell
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
        case email = 0, password, cloud
        
        var cellType: CellTypes {
            switch self {
            case .cloud:
                return CellTypes.standardCell
            case .email:
                return CellTypes.standardCell
            case .password:
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
        case video = 0, travelingSpeedUnit, speed, autoRecord
        
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
            case .video:
                return CellTypes.standardCell
            case .speed:
                return CellTypes.switchCell
            case .travelingSpeedUnit:
                return CellTypes.standardCell
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
        return Sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        case (Sections.account.rawValue, AccountSettings.email.rawValue):
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel!.text = "Email"
        case (Sections.account.rawValue, AccountSettings.password.rawValue):
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel!.text = "Password"
        case (Sections.recording.rawValue, RecordSettings.autoRecord.rawValue):
            let switchCell = self.getCell(cellType: .switchCell) as! SettingsSwitchTableCell
            switchCell.titleLabel.text = "Auto Record"
            cell = switchCell
        case (Sections.recording.rawValue, RecordSettings.speed.rawValue):
            let switchCell = self.getCell(cellType: .switchCell) as! SettingsSwitchTableCell
            switchCell.titleLabel.text = "Speed Watermark"
            cell = switchCell
        case (Sections.recording.rawValue, RecordSettings.travelingSpeedUnit.rawValue):
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel?.text = "Speed Unit"
        case (Sections.recording.rawValue, RecordSettings.video.rawValue):
            cell = self.getCell(cellType: .standardCell)
            cell.textLabel?.text = "Video"
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Sections.recording.rawValue:
            switch indexPath.row {
            case RecordSettings.video.rawValue:
                performSegue(withIdentifier: showVideoOptionsSegueIdentifier, sender: self)
            default:
                return
            }
        case Sections.logout.rawValue:
            //logout stuff
            try! FIRAuth.auth()!.signOut()
            let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {    
        default:
            return
        }
    }
    
    private func getCell(cellType: CellTypes) -> UITableViewCell{
        switch cellType {
        case .standardCell:
            return tableView.dequeueReusableCell(withIdentifier: standardCellIdentifier)!
        case .logoutCell:
            return tableView.dequeueReusableCell(withIdentifier: logOutCellIdentifier)!
        case .switchCell:
            return tableView.dequeueReusableCell(withIdentifier: switchCellIdentifier)!
        }
    }

}
