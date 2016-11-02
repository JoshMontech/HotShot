//
//  NewUserViewController.swift
//  HotShot
//
//  Created by Jake Mayo on 10/18/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reEnter: UITextField!
    
    @IBAction func Submit(_ sender: Any) {
        if (email.text == "" || password.text == "" || reEnter.text == "") && password.text != reEnter.text{
            let alertController = UIAlertController(title: "Error", message: "Incorrect info entered", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.createUser(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
                if error == nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = mainVC
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func dismissSignUpButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
