//
//  EventDetailViewController.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import UIKit

class EventDetailViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var event:Event?
    var backlog:[Task] = []
    var inProgress:[Task] = []
    var done:[Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.processTasks()
    }
    
    func processTasks() {
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
