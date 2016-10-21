//
//  VideosTableViewController.swift
//  HotShot
//
//  Created by Jerry on 10/11/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class VideosTableViewController: UITableViewController {
    
    var videoCount:Int = 0
    
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
        cell.videoNameLabel.text = "derp"
        cell.videoPreviewThumbnail.image = nil
        return cell
    }
    
    //helper functions
    func getVideoCount() -> Int {
        //once videos are working properly, will have more sophisticated handling
        return 4
    }
}
