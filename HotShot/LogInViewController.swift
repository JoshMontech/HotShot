//
//  LogInViewController.swift
//  HotShot
//
//  Created by Jake Mayo on 10/18/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import Foundation
import Firebase

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LogInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func enterLogIn(_ sender: Any) {
        if email.text == "" || password.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Incorrect Login Info", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if error == nil /*&& (user?.isEmailVerified)!*/ {
                    // go to mainVC
                    
                    //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    /*let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = mainVC*/
                    
                    
                   /*
                    let viewController = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
                    let navController = UINavigationController(rootViewController: viewController)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = viewController
                    viewController.present(navController, animated:true, completion: nil)
                    */

                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
                    
                    // Creating a navigation controller with viewController at the root of the navigation stack.
                    let navController = UINavigationController(rootViewController: viewController)
                    self.present(navController, animated:true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
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
