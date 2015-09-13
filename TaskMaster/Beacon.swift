//
//  Beacon.swift
//  TaskMaster
//
//  Created by Aniket Kulkarni on 9/12/15.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

// not used
struct Beacons {
    
    var allBeacons:[CLBeacon] = []
    
}

func updateLocation() {
    var baseUrl = "https://thetaskmaster.firebaseio.com/events/"
    
    if (UserManager.sharedInstance.uid == nil) {
        println("abort update location")
        return
    }
    
    for var i = 0; i < UserManager.sharedInstance.eventArray.count; i++ {
        var locUrl = Firebase(url: baseUrl + UserManager.sharedInstance.eventArray[i]! + "/" + "people" + "/" + UserManager.sharedInstance.uid! + "/" + "location")
        locUrl.setValue(UserManager.sharedInstance.currentLoc)
        
    }
}


