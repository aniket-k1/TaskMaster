//
//  EventDetailViewController.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import UIKit
import Firebase

class EventDetailViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var event:Event?
    var backlog:[Task] = []
    var inProgress:[Task] = []
    var done:[Task] = []
    var firebaseRoot:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com/tasks")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.processTasks()
    }
    
    func addTask(snapshot: FDataSnapshot!) {
        let task:Task = Task.parse(snapshot.key, value: snapshot.value as! [String:AnyObject])
        if snapshot.value["status"] as! Int == TaskState.Backlog.rawValue {
            self.backlog.append(task)
        } else if snapshot.value["status"] as! Int == TaskState.InProgress.rawValue {
            self.inProgress.append(task)
        } else {
            self.done.append(task)
        }
        self.tableView.reloadData()
    }
    
    func removeTask(key: String) {
        for var i=0; i<self.backlog.count; i++ {
            if self.backlog[i].key == key {
                self.backlog.removeAtIndex(i)
            }
        }
        for var i=0; i<self.inProgress.count; i++ {
            if self.inProgress[i].key == key {
                self.inProgress.removeAtIndex(i)
            }
        }
        for var i=0; i<self.done.count; i++ {
            if self.done[i].key == key {
                self.done.removeAtIndex(i)
            }
        }
    }
    
    func processTasks() {
        if event == nil {
            return
        }
        
        firebaseRoot.childByAppendingPath("\(event!.id)/").observeEventType(FEventType.ChildAdded, withBlock: {snapshot in
            self.addTask(snapshot)
            
        })
        
        firebaseRoot.childByAppendingPath("\(event!.id)/").observeEventType(FEventType.ChildChanged, withBlock: {snapshot in
            // Find task by key, remove it
            self.removeTask(snapshot.key)
            self.addTask(snapshot)
        })
        
        firebaseRoot.childByAppendingPath("\(event!.id)/").observeEventType(FEventType.ChildRemoved, withBlock: {snapshot in
            // Find task by key, remove it
            self.removeTask(snapshot.key)
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("eventTaskTypeCell") as! UITableViewCell
        switch indexPath.row {
        case 0:
            // Backlog
            cell.detailTextLabel?.text = "(\(backlog.count))"
            cell.textLabel?.text = "Backlog"
        case 1:
            // In progress
            cell.detailTextLabel?.text = "(\(inProgress.count))"
            cell.textLabel?.text = "In Progress"
        case 2:
            // Done
            cell.detailTextLabel?.text = "(\(done.count))"
            cell.textLabel?.text = "Done"
        default:
            println("This isn't supposed to happen")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepareForSegue(segue, sender: sender)
        
        (segue.destinationViewController as! AddTaskViewController).event = self.event
    }
    

}
