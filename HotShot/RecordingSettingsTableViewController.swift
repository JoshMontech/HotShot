//
//  RecordingSettingsTableViewController.swift
//  HotShot
//
//  Created by Jerry on 11/2/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class RecordingSettingsTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let videoOptionCellIdentifier = "VideoOptionsCell"
    let switchCellIdentifier = "SettingsSwitchCell"
    
    var selectedSegmentLength = Set<Int>()
    var selectedNumberOfSegments = Set<Int>()
    
    enum Sections: Int {
        case recordingLength = 0, clipNumbers, audio
        
        static let count: Int = {
            var max = 0
            
            while Sections(rawValue: max) != nil {
                max += 1
            }
            
            return max
        }()
    }
    
    override func viewDidLoad() {
        switch appDelegate.clipLength {
        case 0.5:
            selectedSegmentLength.insert(VideoLengthOptions.thirtySeconds.rawValue)
        case 1.0:
            selectedSegmentLength.insert(VideoLengthOptions.oneMinute.rawValue)
        case 2.0:
            selectedSegmentLength.insert(VideoLengthOptions.twoMinutes.rawValue)
        case 3.0:
            selectedSegmentLength.insert(VideoLengthOptions.threeMinutes.rawValue)
        case 5.0:
            selectedSegmentLength.insert(VideoLengthOptions.fiveMinutes.rawValue)
        case 10.0:
            selectedSegmentLength.insert(VideoLengthOptions.tenMinutes.rawValue)
        default:
            NSLog("Error! Somehow no clipLength is not one of the preset values. Actual value: \(appDelegate.clipLength)")
            appDelegate.clipLength = 2.0
            selectedSegmentLength.insert(VideoLengthOptions.twoMinutes.rawValue)
        }
        
        selectedNumberOfSegments.insert(appDelegate.savedClipsNumber)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.recordingLength.rawValue:
            return VideoLengthOptions.count
        case Sections.clipNumbers.rawValue:
            return SavedTempVideoNumberOptions.count
        case Sections.audio.rawValue:
            return 1
        default:
            return 0
        }
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Sections.recordingLength.rawValue:
            return "Video Segment Length"
        case Sections.clipNumbers.rawValue:
            return "Number of Segments"
        case Sections.audio.rawValue:
            return "Video Capture with Audio"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case Sections.audio.rawValue:
            return "Off to allow music playback"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellLocation = (indexPath.section, indexPath.row)
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: videoOptionCellIdentifier)!
        
        switch cellLocation {
            //MARK: Segment Length
        case (Sections.recordingLength.rawValue, VideoLengthOptions.thirtySeconds.rawValue):
            cell.textLabel?.text = VideoLengthOptions.thirtySeconds.description
            cell.accessoryType = selectedSegmentLength.contains(indexPath.row) ? .checkmark : .none
        case (Sections.recordingLength.rawValue, VideoLengthOptions.oneMinute.rawValue):
            cell.textLabel?.text = VideoLengthOptions.oneMinute.description
            cell.accessoryType = selectedSegmentLength.contains(indexPath.row) ? .checkmark : .none
        case (Sections.recordingLength.rawValue, VideoLengthOptions.twoMinutes.rawValue):
            cell.textLabel?.text = VideoLengthOptions.twoMinutes.description
            cell.accessoryType = selectedSegmentLength.contains(indexPath.row) ? .checkmark : .none
        case (Sections.recordingLength.rawValue, VideoLengthOptions.threeMinutes.rawValue):
            cell.textLabel?.text = VideoLengthOptions.threeMinutes.description
            cell.accessoryType = selectedSegmentLength.contains(indexPath.row) ? .checkmark : .none
        case (Sections.recordingLength.rawValue, VideoLengthOptions.fiveMinutes.rawValue):
            cell.textLabel?.text = VideoLengthOptions.fiveMinutes.description
            cell.accessoryType = selectedSegmentLength.contains(indexPath.row) ? .checkmark : .none
        case (Sections.recordingLength.rawValue, VideoLengthOptions.tenMinutes.rawValue):
            cell.textLabel?.text = VideoLengthOptions.tenMinutes.description
            cell.accessoryType = selectedSegmentLength.contains(indexPath.row) ? .checkmark : .none
        //MARK: Number of Saved Segments
        case (Sections.clipNumbers.rawValue, SavedTempVideoNumberOptions.zero.rawValue):
            cell.textLabel?.text = SavedTempVideoNumberOptions.zero.description
            cell.accessoryType = selectedNumberOfSegments.contains(indexPath.row) ? .checkmark : .none
        case (Sections.clipNumbers.rawValue, SavedTempVideoNumberOptions.one.rawValue):
            cell.textLabel?.text = SavedTempVideoNumberOptions.one.description
            cell.accessoryType = selectedNumberOfSegments.contains(indexPath.row) ? .checkmark : .none
        case (Sections.clipNumbers.rawValue, SavedTempVideoNumberOptions.two.rawValue):
            cell.textLabel?.text = SavedTempVideoNumberOptions.two.description
            cell.accessoryType = selectedNumberOfSegments.contains(indexPath.row) ? .checkmark : .none
        case (Sections.clipNumbers.rawValue, SavedTempVideoNumberOptions.three.rawValue):
            cell.textLabel?.text = SavedTempVideoNumberOptions.three.description
            cell.accessoryType = selectedNumberOfSegments.contains(indexPath.row) ? .checkmark : .none
        case (Sections.clipNumbers.rawValue, SavedTempVideoNumberOptions.five.rawValue):
            cell.textLabel?.text = SavedTempVideoNumberOptions.five.description
            cell.accessoryType = selectedNumberOfSegments.contains(indexPath.row) ? .checkmark : .none
        case (Sections.clipNumbers.rawValue, SavedTempVideoNumberOptions.ten.rawValue):
            cell.textLabel?.text = SavedTempVideoNumberOptions.ten.description
            cell.accessoryType = selectedNumberOfSegments.contains(indexPath.row) ? .checkmark : .none
        //MARK: Audio Recording
        case (Sections.audio.rawValue, 0):
            if let switchCell = tableView.dequeueReusableCell(withIdentifier: switchCellIdentifier) as? SettingsSwitchTableCell {
                switchCell.titleLabel.text = "Audio Recording"
                switchCell.settingsSwitch.isEnabled = false
                switchCell.settingsSwitch.setOn(appDelegate.shouldRecordAudio, animated: false)
                cell = switchCell
            }
        default:
            return cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Sections.recordingLength.rawValue {
            guard !selectedSegmentLength.contains(indexPath.row) else {
                return
            }
            for selectedRow in selectedSegmentLength {
                let selectedIndexPath = IndexPath(row: selectedRow, section: indexPath.section)
                tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
                selectedSegmentLength.remove(selectedRow)
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedSegmentLength.insert(indexPath.row)
            
            self.appDelegate.clipLength = getSegmentLength(row: indexPath.row)
        }
        else if indexPath.section == Sections.clipNumbers.rawValue {
            guard !selectedNumberOfSegments.contains(indexPath.row) else {
                return
            }
            for selectedRow in selectedNumberOfSegments {
                let selectedIndexPath = IndexPath(row: selectedRow, section: indexPath.section)
                tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
                selectedNumberOfSegments.remove(selectedRow)
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedNumberOfSegments.insert(indexPath.row)

            self.appDelegate.savedClipsNumber = getNumberOfSegments(row: indexPath.row)
        }
        else {  // audio
            if let switchCell = tableView.cellForRow(at: indexPath) as? SettingsSwitchTableCell {
                switchCell.settingsSwitch.setOn(!switchCell.settingsSwitch.isOn, animated: true)
                appDelegate.shouldRecordAudio = switchCell.settingsSwitch.isOn
            }
        }
    }
    
    private func getSegmentLength(row: Int) -> Double {
        switch row {
        case VideoLengthOptions.thirtySeconds.rawValue:
            return VideoLengthOptions.thirtySeconds.valueInMinutes
        case VideoLengthOptions.oneMinute.rawValue:
            return VideoLengthOptions.oneMinute.valueInMinutes
        case VideoLengthOptions.twoMinutes.rawValue:
            return VideoLengthOptions.twoMinutes.valueInMinutes
        case VideoLengthOptions.threeMinutes.rawValue:
            return VideoLengthOptions.threeMinutes.valueInMinutes
        case VideoLengthOptions.fiveMinutes.rawValue:
            return VideoLengthOptions.fiveMinutes.valueInMinutes
        case VideoLengthOptions.tenMinutes.rawValue:
            return VideoLengthOptions.tenMinutes.valueInMinutes
        default:
            NSLog("Error! No matched clipLength! Selected row is \(row)")
            return appDelegate.clipLength
        }
    }
    
    private func getNumberOfSegments(row: Int) -> Int {
        switch row {
        case SavedTempVideoNumberOptions.zero.rawValue:
            return 0
        case SavedTempVideoNumberOptions.one.rawValue:
            return 1
        case SavedTempVideoNumberOptions.two.rawValue:
            return 2
        case SavedTempVideoNumberOptions.three.rawValue:
            return 3
        case SavedTempVideoNumberOptions.five.rawValue:
            return 5
        case SavedTempVideoNumberOptions.ten.rawValue:
            return 10
        default:
            NSLog("Error! No matched number of clips! Selected row is \(row)")
            return appDelegate.savedClipsNumber
        }
    }
    
}
