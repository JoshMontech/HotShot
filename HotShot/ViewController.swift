//
//  ViewController.swift
//  HotShot
//
//  Created by Jerry on 9/30/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import CameraManager
import RealmSwift

class ViewController: UIViewController, FileManagerDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var controllView: UIView!
    let cameraManager = CameraManager()
    let warningMessage = "Please do not interact with the application while operating a vehicle."
    let burntOrange = UIColor(red: 191/255, green: 87/255, blue: 0, alpha: 1)
    let realm = try! Realm()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var shouldShowWarning = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCamera()
        self.controllView.alpha = 0.75
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldShowWarning {
            displayInitialAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func startRecordingButtonPressed(_ sender: UIButton) {
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        var toBeDeletedVideosUrls = [String]()
        
        sender.isSelected = !sender.isSelected
//        sender.setTitle(" ", for: UIControlState.selected)
//        sender.titleLabel?.text = sender.isSelected ? "Stop Recording" : "Start Recording"
        sender.backgroundColor = sender.isSelected ? UIColor.red : UIColor.green
        
        // start recording
        if sender.isSelected {
            DispatchQueue.global(qos: .background).async {
                autoreleasepool{
                    let realm = try! Realm()
                    let videos = realm.objects(Video.self).sorted(byProperty: "date")
                    let maxClips = self.appDelegate.savedClipsNumber
                    let numSavedVids = videos.count
                    
                    do {
                        try print(FileManager().contentsOfDirectory(atPath: documentDir))
                    }
                    catch let error {
                        NSLog(error.localizedDescription)
                    }
                    // remove oldest saved videos
                    if maxClips <= numSavedVids {
                        for i in 0...numSavedVids - maxClips {
                            toBeDeletedVideosUrls.append(videos[i].urlString)
                        }
                        
                        for url in toBeDeletedVideosUrls {
                            let videoFile = FileHandle(forReadingAtPath: url)
                            do {
                                videoFile?.closeFile()
                                try FileManager.default.removeItem(atPath: url)
                                try! realm.write {
                                    let predicate = NSPredicate(format: "urlString = %@", url)
                                    let vid = realm.objects(Video.self).filter(predicate)
                                    realm.delete(vid)
                                    
                                }
                            }
                            catch let error {
                                print("There was a problem deleting the video")
                                NSLog(error.localizedDescription)
                            }
                        }
                    }
                    
                    do {
                        try print(FileManager().contentsOfDirectory(atPath: documentDir))
                    }
                    catch let error {
                        NSLog(error.localizedDescription)
                    }
                }
            }
            cameraManager.startRecordingVideo()
        }
        // stop recording
        else {
            cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
                if let errorOccured = error {
                    self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
                }
                else {
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "US_en")
                    dateFormatter.dateFormat = "MMMddyyyy-HHmmss"
                    let dateString = dateFormatter.string(from: date)
                    let savedDocPath = "\(documentDir)/\(dateString).mp4"
                    
//                    print(FileManager().contentsOfDirectory(atPath: documentDir))
                    
                    if let savedDocURL = URL(string: "file:///private\(savedDocPath)") {
                        do {
                            try FileManager.default.copyItem(at: videoURL!, to: savedDocURL)
                            let newVideo = Video()
                            newVideo.urlString = savedDocPath
                            newVideo.date = date as NSDate
                            try! self.realm.write {
                                self.realm.add(newVideo)
                            }
                            
                        }
                        catch let error {
                            print("There was a problem saving the video")
                            NSLog(error.localizedDescription)
                        }
                    }
                    
                    
                }
            })
        }
    }
    
    private func displayInitialAlert() {
        let alertController = UIAlertController(title: "Warning", message: warningMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
        shouldShowWarning = false
    }
    
    private func setupCamera() {
        // TODO: replace CameraOutputMode.videoWithMic with the user settings (user defaults)
        let _ = cameraManager.addPreviewLayerToView(self.cameraView, newCameraOutputMode: CameraOutputMode.videoOnly)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
        cameraManager.writeFilesToPhoneLibrary = false
    }
}

