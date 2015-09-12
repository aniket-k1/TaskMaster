//
//  AddEventViewController.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import UIKit
import Firebase

class AddEventViewController : UIViewController {
    
    @IBOutlet weak var inputName: UITextField!
    
    @IBAction func onSave(sender: AnyObject) {
        var firebaseRoot:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com/events")
        var newChild = firebaseRoot.childByAutoId()
        var event:Event = Event()
        event.name = inputName.text
        event.owner = UserManager.sharedInstance.uid
        event.people = [UserManager.sharedInstance.uid!]
        newChild.setValue(event.toDict())
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
