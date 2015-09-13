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
            
            UserManager.sharedInstance.eventArray = []
            
            // QUERY ALL EVENTS
            var ref = Firebase(url:"https://thetaskmaster.firebaseio.com/events")
            
            ref.observeEventType(.Value, withBlock: { snapshot in
                //println(snapshot.value)
                
                var result = snapshot.value as? Dictionary<String, AnyObject>
                if result == nil {
                    return
                }
                
                // for each event
                for (key, value) in result! {
                    
                    var baseUrl = "https://thetaskmaster.firebaseio.com/events/"
                    var eventUrl = baseUrl + key
                    
                    var ref2 = Firebase(url: eventUrl)
                    ref2.observeEventType(.Value, withBlock: { snapshot in
                        println("event id")
                        println(key)
                        //println(snapshot.value.objectForKey("people"))
                        
                        // Get people for each event
                        var peopleDict = snapshot.value.objectForKey("people") as! Dictionary<String, AnyObject>
                        
                        for (key2, value) in peopleDict{
                            println(key2)
                            println("our ID: ")
                            println(UserManager.sharedInstance.uid)
                            
                            if (key2 == UserManager.sharedInstance.uid) {
                                println("add event key: ")
                                println(key)
                                UserManager.sharedInstance.eventArray.append(key)
                                println(UserManager.sharedInstance.eventArray.count)
                            }
                            
                            
                        }
                        
                        
                        }, withCancelBlock: { error in
                            println(error.description)
                    })
                    
                }
                

                
                }, withCancelBlock: { error in
                    println(error.description)
            })
            
            // print array
            println("print array")
            for element in UserManager.sharedInstance.eventArray {
                print(element, appendNewline: false)
            }
            
            
            UserManager.sharedInstance.login(email, password: password, uid: authdata.uid)
            self.dismissViewControllerAnimated(false, completion: {
                self.performSegueWithIdentifier("loginEndSegue", sender: self)
            })
        }
    }
    
}
