//
//  LoginViewController.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController : UIViewController {
    var firebaseRoot:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com")

    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!

    @IBAction func onLogin(sender: AnyObject) {
        let email = inputEmail.text,
            password = inputPassword.text
        
        firebaseRoot.authUser(email, password: password) { (error, authdata) -> Void in
            if (error != nil) {
                return
            }
            UserManager.sharedInstance.login(email, password: password, uid: authdata.uid)
            self.dismissViewControllerAnimated(false, completion: {
                self.performSegueWithIdentifier("loginEndSegue", sender: self)
            })
        }
    }
    
}
