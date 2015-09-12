//
//  Task.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import Foundation

enum TaskState:Int {
    case Backlog
    case InProgress
    case Done
}

class Task {
    var key:String?
    var title:String?
    var assignee:String? //uid
    var state:TaskState = .Backlog
    
    class func parse(key: String, value: [String: AnyObject]) -> Task {
        var task:Task = Task()
        task.key = key
        task.title = value["title"] as? String
        task.assignee = value["assignee"] as? String
        task.state = TaskState(rawValue: value["state"] as! Int)!
        return task
    }
}