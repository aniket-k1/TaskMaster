//
//  ViewController.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var firebaseRoot:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserManager.sharedInstance.loggedIn {
            self.performSegueWithIdentifier("loginStartSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

