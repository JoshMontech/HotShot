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
import CoreLocation

public var speedMetric = ""
public var showSpeed = 1

class ViewController: UIViewController, FileManagerDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var videosButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var controllView: UIView!
    @IBOutlet weak var recordButton: UIButton!

    let cameraManager = CameraManager()
    let warningMessage = "Please do not interact with the application while operating a vehicle."
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let config = Config.sharedInstance

    
    @IBOutlet weak var speed: UILabel!

    var locationManager: CLLocationManager!
    var lat = ""
    var long = ""

    var location5: CLLocation! {
        didSet {
            lat = "\(location5.coordinate.latitude)"
            long = "\(location5.coordinate.longitude)"
            updateSpeed()
        }
    }

    var shouldShowWarning = true
    var isRecording = false
    var shouldSaveSegment = false

    var startRecordingCount = 1
    var stopRecordingCount = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.controllView.alpha = 0.75
        self.recordButton.backgroundColor = config.recordGreen
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.numberOfTapsRequired = 2
        tapRecognizer.delegate = self
        cameraView.addGestureRecognizer(tapRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        if shouldShowWarning {
            displayInitialAlert()
        }

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()
    }

    func checkCoreLocationPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .restricted {
            // print alert
            print("unauthorized to use location service")
        }
    }

    @objc func updateSpeed() {
        if showSpeed == 0 {
            speed.text = ""
        } else {
            locationManager.startUpdatingLocation()
            if location5 != nil {
                let currentSpeed = location5.speed == -1.0 ? 0 : location5.speed
                if speedMetric == "m/h" {
                    speed.text = "\(Double(round(10 * currentSpeed / 2.23694)/10))" + " m/h"
                    
                } else if speedMetric == "km/h" {
                    speed.text = "\(Double(round(10 * currentSpeed / 3.6)/10))" + " km/h"
                    
                } else {
                    speed.text = "\(Double(round(10 * currentSpeed)/10))" + " m/s"
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location5 = (locations).last
        locationManager.stopUpdatingLocation() // save batter
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        setupCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func handleTap() {
        self.shouldSaveSegment = true
    }

    @IBAction func startRecordingButtonPressed(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            let timerSpeed = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
            timerSpeed.fire()
        }
        guard cameraManager.cameraIsReady else {
            return
        }
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? UIColor.red : config.recordGreen
        if #available(iOS 10.0, *) {
            let timer = Timer.scheduledTimer(timeInterval: 60.0 * appDelegate.clipLength, target: self, selector: #selector(stopAndStartRecording), userInfo: nil, repeats: true)
            
            // start the timer
            let timerSpeed = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
            
            
            // start recording
            if sender.isSelected {
                timer.fire()
                timerSpeed.fire()
                isRecording = true
                videosButton.isUserInteractionEnabled = false
                settingsButton.isUserInteractionEnabled = false
            }
            // stop recording
            else {
                timer.invalidate()
                timerSpeed.invalidate()
                stopRecording()
                isRecording = false
                videosButton.isUserInteractionEnabled = true
                settingsButton.isUserInteractionEnabled = true
            }
        } else {
            // Fallback on earlier versions
            // TODO: check if it works on older iOS versions
            let timer = Timer(timeInterval: 60.0 * appDelegate.clipLength, target: self, selector: #selector(stopAndStartRecording), userInfo: nil, repeats: true)
            // start the timer
            let timerSpeed = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
            // start recording
            if sender.isSelected {
                timer.fire()
                timerSpeed.fire()
                isRecording = true
                videosButton.isUserInteractionEnabled = false
            }
            // stop recording
            else {
                timer.invalidate()
                timerSpeed.invalidate()
                stopRecording()
                isRecording = false
            }
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

    private func stopRecording() {
        cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
            if let errorOccured = error {
                self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
            }
            else {
                self.saveVideo(videoURL: videoURL!)
                self.videosButton.isUserInteractionEnabled = true
                self.settingsButton.isUserInteractionEnabled = true
            }
        })
    }

    @objc private func stopAndStartRecording() {
        guard isRecording else {
            self.cameraManager.startRecordingVideo()
            return
        }

        DispatchQueue.global(qos: .background).async {
            self.cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
                if let errorOccured = error {
                    self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
                }
                else {
                    self.saveVideo(videoURL: videoURL!)
                }
            })
        }

        DispatchQueue.main.async {
            self.cameraManager.startRecordingVideo()
        }


    }

    private func saveVideo(videoURL: URL) {
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
                try FileManager.default.copyItem(at: videoURL, to: savedDocURL)
                let newVideo = Video()
                newVideo.fileName = vidFileName
                newVideo.date = date as NSDate
                if self.shouldSaveSegment {
                    newVideo.isSaved = true
                }
                try! realm.write {
                    realm.add(newVideo)
                }
            }
            catch let error {
                print("There was a problem saving the video")
                NSLog(error.localizedDescription)
            }
        }

        if self.shouldSaveSegment {
            self.shouldSaveSegment = false
        } else {
            self.checkAndRemoveSavedSegments()
        }
    }
    private func checkAndRemoveSavedSegments() {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool{
                let realm = try! Realm()
                let videos = realm.objects(Video.self).filter("isSaved = false").sorted(byProperty: "date")
                let maxClips = self.appDelegate.savedClipsNumber
                let numSavedVids = videos.count

                if maxClips < numSavedVids {
                    var toBeDeletedVideos = [Video]()
                    for i in 0..<numSavedVids - maxClips {
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
            }
        }
    }
}
