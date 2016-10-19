//
//  NewUserViewController.swift
//  HotShot
//
//  Created by Jake Mayo on 10/18/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import Foundation


class NewUserViewController: UIViewController {
    
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reEnter: UITextField!
    
    @IBAction func Submit(_ sender: Any) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
