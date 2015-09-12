//
//  UserHandler.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import Foundation

class UserManager {
    static let sharedInstance = UserManager()
    
    var email: String?
    var password: String?
    var uid: String?
    
    var loggedIn:Bool = false
    
    func login(email: String, password: String, uid: String) {
        self.email = email
        self.password = password
        self.uid = uid
        
        self.loggedIn = true
    }
}