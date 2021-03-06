//
//  TaskDetailViewController.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import UIKit
import Firebase

class TaskDetailViewController: UITableViewController, UITableViewDelegate {

    var task:Task?
    var event:Event?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var assigneeLabel: UILabel!
    @IBOutlet weak var movetoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.delegate = self
        
    }
    func getEmailAddress(input:String) -> String {
        var dictionary:[String:String] = [
            "5d67075e-a3e0-4ac4-a90d-f11289f43d3b": "Bilal",
            "9c366979-4080-4041-8eb9-1a9b160f0b0d": "Aniket",
            "3d218e2c-edfd-4b77-b488-076f51fbf723": "Kashav"
        ]
        return dictionary[input]!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        titleLabel.text = task?.title
        if task?.assignee == UserManager.sharedInstance.uid {
            assigneeLabel.text = "Assigned to you"
        } else if (count(task!.assignee!) > 0) {
            // Gotta look it up
            var firebaseEvent:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com/events/\(event!.id!)")
            assigneeLabel.text = "Assigned to \(getEmailAddress(task!.assignee!))"
        }
        movetoLabel.text = task?.state == TaskState.InProgress ? "Complete Task" : "Move to In Progress"
        
        if task?.state == TaskState.Done {
            movetoLabel.hidden = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        switch indexPath.row {
        case 0:
            // Move to next state
            task!.transitionStateForward(event!)
            
        case 1:
            // Defer
            // TODO
            fallthrough
        default:
            return
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
