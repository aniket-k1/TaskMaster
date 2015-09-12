//
//  Task.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import Foundation

enum TaskState {
    case Backlog
    case InProgress
    case Done
}

class Task {
    var title:String?
    var assignee:String? //uid
    var state:TaskState = .Backlog
}