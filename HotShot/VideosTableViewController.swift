//
//  VideosTableViewController.swift
//  HotShot
//
//  Created by Jerry on 10/11/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import RealmSwift

class VideosTableViewController: UITableViewController {
    let avPlayerController = AVPlayerViewController()
    let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    
    var avPlayer: AVPlayer? = nil
    var recentVideos: [Video] = [Video]()
    var savedVideos: [Video] = [Video]()
    
    enum Sections: Int {
        case recent = 0, saved
        
        static let count: Int = {
            var max = 0
            
            while Sections(rawValue: max) != nil {
                max += 1
            }
            
            return max
        }()
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        let realm = try! Realm()
        let resultForRecent = realm.objects(Video.self).filter("isSaved = false").sorted(byProperty: "date", ascending: false)
        for i in 0 ..< resultForRecent.count {
            recentVideos.append(resultForRecent[i])
        }
        
        let resultForSaved = realm.objects(Video.self).filter("isSaved = true").sorted(byProperty: "date", ascending: false)
        for i in 0 ..< resultForSaved.count {
            savedVideos.append(resultForSaved[i])
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Sections.recent.rawValue:
            return "Recent Videos"
        case Sections.saved.rawValue:
            return "Saved Videos"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.recent.rawValue:
            return recentVideos.count
        case Sections.saved.rawValue:
            return savedVideos.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoPreviewCell", for: indexPath) as! VideoTableCell
        
        var video: Video!
        
        if indexPath.section == Sections.recent.rawValue {
            video = recentVideos[indexPath.row]
        } else {
            video = savedVideos[indexPath.row]
        }
        
        let videoURL = URL(string: "file:///private\(self.documentDir)/\(video!.fileName)")
        let thumbnail = getVideoPreviewThumbnail(sourceURL: videoURL!)
        
        if indexPath.section == Sections.recent.rawValue {
            cell.videoNameLabel.text = "Recording \(indexPath.row + 1)"
        } else {
            cell.videoNameLabel.text = "Saved Recording \(indexPath.row + 1)"
        }
        cell.videoPreviewThumbnail.image = thumbnail
        cell.videoURL = videoURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! VideoTableCell
        
        if let url = cell.videoURL {
            self.avPlayer = AVPlayer(url: url as URL)
            self.avPlayerController.player = self.avPlayer
            present(self.avPlayerController, animated: true, completion: {
                self.avPlayerController.player?.play()
            })
        }
        else {
            NSLog("Error! URL is nil: \(cell.videoURL)")
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action in
            switch indexPath.section {
            case Sections.recent.rawValue:
                self.deleteVideo(videoName: self.recentVideos[indexPath.row].fileName)
                self.recentVideos.remove(at: indexPath.row)
            case Sections.saved.rawValue:
                self.deleteVideo(videoName: self.savedVideos[indexPath.row].fileName)
                self.savedVideos.remove(at: indexPath.row)
            default: break
            }
        }
        
        if indexPath.section == Sections.saved.rawValue {
            return [deleteAction]
        }
        
        let saveAction = UITableViewRowAction(style: .normal, title: "Save") {action in
            let video = self.recentVideos[indexPath.row]
            let realm = try! Realm()
            self.recentVideos.remove(at: indexPath.row)
            try! realm.write {
                video.isSaved = true
            }
            self.savedVideos = self.insertVideoSorted(video: video, videos: self.savedVideos)
            let indexSet = IndexSet(0..<self.tableView.numberOfSections)
            self.tableView.reloadSections(indexSet, with: .automatic)
        }
        
        return [deleteAction, saveAction]
    }
    
    private func deleteVideo(videoName: String) {
        DispatchQueue.global(qos: .background).async {
            
                let realm = try! Realm()
                do {
                    let videos = realm.objects(Video.self).filter("fileName = '\(videoName)'")
                    
                    for video in videos {
                        let vidUrl = "\(self.documentDir)/\(video.fileName)"
                        try! realm.write {
                            realm.delete(video)
                        }
                        try FileManager.default.removeItem(atPath: vidUrl)
                    }
                    
                } catch let error {
                    print("There was a problem deleting the video")
                    NSLog(error.localizedDescription)
                }
        }
        DispatchQueue.main.async {
            let indexSet = IndexSet(0..<self.tableView.numberOfSections)
            self.tableView.reloadSections(indexSet, with: .automatic)
        }
    }
    
    private func insertVideoSorted(video: Video, videos: [Video], ascending: Bool = true) -> [Video] {
        var videos = videos
        let videoDate = video.date
        for i in 0 ..< videos.count {
            switch videoDate.compare(videos[i].date as Date) {
            case .orderedAscending:
                if ascending {
                    videos.insert(video, at: i)
                    return videos
                }
            case .orderedDescending:
                if !ascending {
                    videos.insert(video, at: i)
                    return videos
                }
            case .orderedSame:
                continue
            }
        }
        videos.append(video)
        return videos
    }
    
    private func getVideoPreviewThumbnail(sourceURL:URL) -> UIImage {
        let asset = AVAsset(url: sourceURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 1)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            NSLog(error.localizedDescription)
            return #imageLiteral(resourceName: "flame")
        }
    }
    
}
