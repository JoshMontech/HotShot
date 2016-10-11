//
//  ViewController.swift
//  HotShot
//
//  Created by Jerry on 9/30/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import CameraManager

class ViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var controllView: UIView!
    let cameraManager = CameraManager()
    let warningMessage = "Please do not interact with application while operating a vehicle."
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCamera()
        
        self.controllView.alpha = 0.5
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayInitialAlert()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func displayInitialAlert() {
        let alertController = UIAlertController(title: "Warning", message: warningMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupCamera() {
        let _ = cameraManager.addPreviewLayerToView(self.cameraView)
        cameraManager.writeFilesToPhoneLibrary = false
    }
}

