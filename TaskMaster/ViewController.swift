//
//  ViewController.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var events:[Event] = []
    
    @IBOutlet weak var tableView: UITableView!
    var firebaseRoot:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("eventCell") as! UITableViewCell
        cell.textLabel?.text = events[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("\(events[indexPath.row].name) was selected")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserManager.sharedInstance.loggedIn {
            self.performSegueWithIdentifier("loginStartSegue", sender: self)
            return
        }
        
        firebaseRoot.childByAppendingPath("/events").observeEventType(FEventType.ChildAdded, withBlock: { snapshot in
            self.events.append(Event.parse(snapshot.value as! [String:AnyObject]))
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

