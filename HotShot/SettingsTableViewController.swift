//
//  SettingsTableViewController.swift
//  HotShot
//
//  Created by Jake Mayo on 10/17/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

var lst = ["jake", "seth"]

class SettingsTableViewController: UITableViewController {
    var textCellIdentifier = "SettingsCell"
    
    enum sections: Int {
        case recording = 0, general, account
        
        static let count: Int = {
            var max = 0
            
            while sections(rawValue: max) != nil {
                max += 1
            }
            
            return max
        }()
    }
    
    enum generalSettings: Int {
        case powerSaving = 0, about
        
        static let count: Int = {
            var max = 0
            
            while generalSettings(rawValue: max) != nil {
                max += 1
            }
            
            return max
        }()
    }
    
    enum accountSettings: Int {
        case email = 0, passWord, username, firstName, lastName, cloud, logOut
        
        static let count: Int = {
            var max = 0
            
            while accountSettings(rawValue: max) != nil {
                max += 1
            }
            
            return max
        }()
    }
    
    enum recordSettings: Int {
        case lengthOfClip = 0, numberOfClipsSaved, travelingSpeedUnit, speed, autoRecord
        
        static let count: Int = {
            var max = 0
            
            while recordSettings(rawValue: max) != nil {
                max += 1
            }
            
            return max
        }()
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
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case sections.general.rawValue:
            return generalSettings.count
        case sections.account.rawValue:
            return accountSettings.count
        case sections.recording.rawValue:
            return recordSettings.count
        default:
            return 0
        }

    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case sections.account.rawValue:
            return "Account"
        case sections.general.rawValue:
            return "General"
        case sections.recording.rawValue:
            return "Recording"
        default:
            return ""
        }
    }
    
    
//    override func tableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier)
        let indexValue = (indexPath.section, indexPath.row)
//        let person = lst[indexPath.row]
//        
//        cell!.detailTextLabel!.text = "party"
//        cell!.textLabel!.text = person
//        
//
        switch indexValue {
        case (sections.general.rawValue, generalSettings.powerSaving.rawValue):
            cell!.textLabel!.text = "Power Saving Mode"
        case (sections.general.rawValue, generalSettings.about.rawValue):
            cell!.textLabel!.text = "About"
        case (sections.account.rawValue, accountSettings.cloud.rawValue):
            cell!.textLabel!.text = "Cloud"
        case (sections.account.rawValue, accountSettings.username.rawValue):
            cell!.textLabel!.text = "Username"
        case (sections.account.rawValue, accountSettings.firstName.rawValue):
            cell!.textLabel!.text = "First Name"
        case (sections.account.rawValue, accountSettings.lastName.rawValue):
            cell!.textLabel!.text = "Last Name"
        case (sections.account.rawValue, accountSettings.email.rawValue):
            cell!.textLabel!.text = "Email"
        case (sections.account.rawValue, accountSettings.logOut.rawValue):
            cell!.textLabel!.text = "Log Out"
        case (sections.account.rawValue, accountSettings.passWord.rawValue):
            cell!.textLabel!.text = "Password"
        case (sections.recording.rawValue, recordSettings.autoRecord.rawValue):
            cell!.textLabel!.text = "Auto Record"
        case (sections.recording.rawValue, recordSettings.speed.rawValue):
            cell!.textLabel!.text = "Speed"
        case (sections.recording.rawValue, recordSettings.travelingSpeedUnit.rawValue):
            cell!.textLabel!.text = "Speed Unit"
        case (sections.recording.rawValue, recordSettings.numberOfClipsSaved.rawValue):
            cell!.textLabel!.text = "Number of Clips Saved"
        case (sections.recording.rawValue, recordSettings.lengthOfClip.rawValue):
            cell!.textLabel!.text = "Video Length"
        default:
            cell!.textLabel!.text = "Default"
        }
        return cell!
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
