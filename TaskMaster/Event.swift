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
    var joined:Bool = false
    
    class func parse(key: String?, input: [String:AnyObject]) -> Event {
        var event:Event = Event()
        event.name = key != nil ? key : input["name"] as? String
        event.owner = input["owner"] as? String
        if UserManager.sharedInstance.uid != nil &&
            contains((input["attendees"] as! [String]), UserManager.sharedInstance.uid!) &&
            UserManager.sharedInstance.loggedIn == true {
            event.joined = true
        }
        return event
    }
}