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

class VideosTableViewController: UITableViewController {
    
    var videoCount:Int = 0
    let avPlayerController = AVPlayerViewController()
    var avPlayer: AVPlayer? = nil
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        videoCount = getVideoCount()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoPreviewCell", for: indexPath) as! VideoTableCell
        cell.videoNameLabel.text = "derp" //fix
        cell.videoPreviewThumbnail.image = #imageLiteral(resourceName: "flame") //fix
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoPreviewCell", for: indexPath) as! VideoTableCell
        if let url = cell.videoURL {
            self.avPlayer = AVPlayer(url: url as URL)
            self.avPlayerController.player = self.avPlayer
            present(self.avPlayerController, animated: true, completion: {
                self.avPlayerController.player?.play()
            })
        } else {
            print("derp")
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //helper functions
    func getVideoCount() -> Int {
        //once videos are working properly, will have more sophisticated handling
        return 4 //fix
    }
}
