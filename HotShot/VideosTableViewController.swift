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
    var videos: [Video] = [Video]()
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        let result = realm.objects(Video.self).sorted(byProperty: "date")
        for i in 0 ..< result.count {
            videos.append(result[i])
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoPreviewCell", for: indexPath) as! VideoTableCell
        // "\(self.documentDir)/\(dateString).mp4"
        let video = videos[indexPath.row]
        let videoURL = URL(string: "file:///private\(self.documentDir)/\(video.fileName)")
        let thumbnail = getVideoPreviewThumbnail(sourceURL: videoURL!)
        
        cell.videoNameLabel.text = "Recording\(indexPath.row + 1)"
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
