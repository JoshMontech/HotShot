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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    
    var shouldShowWarning = true
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.controllView.alpha = 0.75
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldShowWarning {
            displayInitialAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        setupCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func startRecordingButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? UIColor.red : UIColor.green
        
        // start recording
        if sender.isSelected {
            if #available(iOS 10.0, *) {
                let timer = Timer.scheduledTimer(timeInterval: 60.0 * appDelegate.clipLength, target: self, selector: #selector(startRecording), userInfo: nil, repeats: true)
                timer.fire()
                isRecording = true
            } else {
                // Fallback on earlier versions
                // TODO: support older iOS versions
            }
        }
        // stop recording
        else {
            stopRecording()
            isRecording = false
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
        let outputMode = appDelegate.shouldRecordAudio ? CameraOutputMode.videoWithMic : CameraOutputMode.videoOnly
        let _ = cameraManager.addPreviewLayerToView(self.cameraView, newCameraOutputMode: outputMode)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
        cameraManager.writeFilesToPhoneLibrary = false
    }
    
    @objc private func startRecording() {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool{
                if self.isRecording {
                    self.stopRecording()
                }
                let realm = try! Realm()
                let videos = realm.objects(Video.self).sorted(byProperty: "date")
                let maxClips = self.appDelegate.savedClipsNumber
                let numSavedVids = videos.count
                // remove oldest saved videos
                if maxClips <= numSavedVids {
                    var toBeDeletedVideos = [Video]()
                    for i in 0...numSavedVids - maxClips {
                        toBeDeletedVideos.append(videos[i])
                    }
                    
                    for video in toBeDeletedVideos {
                        do {
                            let vidUrl = "\(self.documentDir)/\(video.fileName)"
                            try FileManager.default.removeItem(atPath: vidUrl)
                            try! realm.write {
                                realm.delete(video)
                            }
                        }
                        catch let error {
                            print("There was a problem deleting the video")
                            NSLog(error.localizedDescription)
                        }
                    }
                }
                self.cameraManager.startRecordingVideo()
            }
        }
    }
    
    private func stopRecording() {
        cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
            if let errorOccured = error {
                self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
            }
            else {
                let realm = try! Realm()
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "US_en")
                dateFormatter.dateFormat = "MMMddyyyy-HHmmss"
                let dateString = dateFormatter.string(from: date)
                let savedDocPath = "\(self.documentDir)/\(dateString).mp4"
                let vidFileName = "\(dateString).mp4"
                
                if let savedDocURL = URL(string: "file:///private\(savedDocPath)") {
                    do {
                        try FileManager.default.copyItem(at: videoURL!, to: savedDocURL)
                        let newVideo = Video()
                        newVideo.fileName = vidFileName
                        newVideo.date = date as NSDate
                        try! realm.write {
                            realm.add(newVideo)
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

