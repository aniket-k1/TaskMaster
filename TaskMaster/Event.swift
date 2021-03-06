//
//  Event.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import Foundation
import Firebase

class Event {
    var id:String?
    var name:String?
    var owner:String?
    var people:[String:[String:AnyObject]] = [:]
    var joined:Bool = false
    
    class func parse(key: String?, input: [String:AnyObject]) -> Event {
        var event:Event = Event()
        event.id = key
        event.name = input["name"] as? String
        event.owner = input["owner"] as? String
        event.people = input["people"] as! [String:[String:AnyObject]]
        if UserManager.sharedInstance.uid != nil &&
            event.people[UserManager.sharedInstance.uid!] != nil &&
            UserManager.sharedInstance.loggedIn == true {
            event.joined = true
        }
        return event
    }
    
    func toDict() -> [String:AnyObject] {
        var returnValue:[String:AnyObject] = [
            "name": self.name!,
            "owner": self.owner!,
            "people": self.people
        ]
        
        return returnValue
    }
    func syncPeople() {
        var firebaseRoot:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com/events/\(self.id!)/people/")
        firebaseRoot.setValue(self.people)
    }
}