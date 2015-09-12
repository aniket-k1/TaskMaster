//
//  Event.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import Foundation

class Event {
    var name:String?
    var owner:String?
    var people:[String] = []
    var joined:Bool = false
    
    class func parse(input: [String:AnyObject]) -> Event {
        var event:Event = Event()
        event.name = input["name"] as? String
        event.owner = input["owner"] as? String
        event.people = input["people"] as! [String]
        if UserManager.sharedInstance.uid != nil &&
            contains((input["people"] as! [String]), UserManager.sharedInstance.uid!) &&
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
}