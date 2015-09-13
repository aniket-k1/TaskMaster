//
//  Task.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import Foundation
import Firebase

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
    
    func toDict() -> [String:AnyObject] {
        return [
            "title": self.title!,
            "assignee": self.assignee!,
            "state": self.state.rawValue
        ]
    }
    
    func onAssigned(event: Event) {
        var uid = self.assignee!
        var assignedList = event.people[uid]!["assigned"] as? [String]
        if assignedList == nil {
            assignedList = []
        }
        assignedList!.append(self.key!)
        (event.people[uid]!)["assigned"] = assignedList!
            
        var firebaseRoot:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com")
        firebaseRoot.childByAppendingPath("/events/\(event.id!)/people").setValue(event.people)
    }
    
    func transitionStateForward(event: Event) {
        if self.state == TaskState.Backlog {
            self.state = TaskState.InProgress
            if self.assignee != nil && count(self.assignee!) > 0 {
                event.people[self.assignee!]!["busy"] = true
                var doing = (event.people[self.assignee!]!)["doing"] as! Int
                event.people[self.assignee!]!["doing"] = ++doing
            }
            event.syncPeople()
        } else if self.state == TaskState.InProgress {
            self.state = TaskState.Done
            if self.assignee != nil && count(self.assignee!) > 0 {
                var doing = (event.people[self.assignee!]!)["doing"] as! Int
                event.people[self.assignee!]!["doing"] = --doing
                var completed = (event.people[self.assignee!]!)["completed"] as! Int
                event.people[self.assignee!]!["completed"] = ++completed
            
                if (doing == 0) {
                    event.people[self.assignee!]!["busy"] = false
                }
            }
            
            event.syncPeople()
        }
        var firebaseRoot:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com/tasks/\(event.id!)/\(self.key!)/state")
        firebaseRoot.setValue(self.state.rawValue)
    }
}