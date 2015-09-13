//
//  AddTaskViewController.swift
//  TaskMaster
//
//  Created by Bilal Akhtar on 2015-09-12.
//  Copyright (c) 2015 Team Canada (kinda). All rights reserved.
//

import UIKit
import Firebase

class AddTaskViewController: UIViewController {

    var event: Event?
    
    @IBOutlet weak var inputTaskName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSave(sender: AnyObject) {
        var firebaseRoot:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com/tasks/\(event!.id!)")
        var newChild = firebaseRoot.childByAutoId()
        var task:Task = Task()
        task.title = inputTaskName.text
        task.state = TaskState.Backlog
        task.key = newChild.key
        var members:NSArray = event!.people.keys.array
        var assignee: String;
        
        // random person
        //task.assignee = Array(event!.people.keys)[Int(arc4random_uniform(UInt32(event!.people.count)))]
        
        var members2 : [String] = []
        
        var owner_id = event!.owner
        
        var highest_ongoing_tasks = Int()
        
        var firebaseEvent:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com/events/\(event!.id!)")
        firebaseEvent.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let people = snapshot.value["people"] as? NSDictionary
            
            var counter:Int = 0;

            for (key, value) in people! {
                var completed:Int
                var doing:Int
                var busy:Bool
                var assigned:[AnyObject]
                var location_beacon:NSNumber
                
                if value["completed"] != nil {
                    completed = value["completed"] as! Int
                } else {
                    completed = 0
                }
                
                if value["doing"] != nil {
                    doing = value["doing"] as! Int
                } else {
                    doing = 0
                }

                if value["busy"] != nil {
                    busy = value["busy"] as! Bool
                } else {
                    busy = false
                }
                
//                if value["assigned"] != nil {
//                    assigned = value["assigned"] as! Array
//                } else {
//                    assigned = []
//                }
                
                if value["location"] as? Int != nil {
                    location_beacon = value["location"] as! Int
                } else {
                    location_beacon = 0
                }
                
                if (counter == 0) {
                   highest_ongoing_tasks = doing
                }
                
                if ( (!busy) && (doing <= highest_ongoing_tasks) ) {
                    
                    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                    let auth = "Bearer LKKKYZ6G5JJRHW2FELNNIEHRN6VZLUXK"
                    config.HTTPAdditionalHeaders = ["Authorization" : auth]
                    let urlsess = NSURLSession(configuration: config)
                    
                    var titleNonEncode = task.title!
                    var titleEncode = titleNonEncode.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
                    let url = NSURL(string: "https://api.wit.ai/message?v=20150913&q=\(titleEncode)&_t=291")
                    let datatask = urlsess.dataTaskWithURL(url!) {
                        (data,response,error) in
                        var error2:NSError?
                        if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error2){
                            
                            println(jsonResult)
                            var outcomes = jsonResult["outcomes"] as! [[String:AnyObject]]
                            var entities = outcomes[0]["entities"] as? [String:AnyObject]
                            var from = entities?["from"] as? [[String:AnyObject]]
                            if (from == nil) || (from!.count == 0) {
                                task.assignee = key as! String
                                task.onAssigned(self.event!)
                                newChild.setValue(task.toDict())
                                self.navigationController?.popViewControllerAnimated(true)
                                return
                            }
                            var location = from?[0]["value"] as? String
                            
                            if location != nil {
                                switch location! {
                                    case "auditorium", "office", "iOS Cortex", "BBB", "EECS":
                                        if (location_beacon == 3764) {
                                            task.assignee = key as! String
                                            task.onAssigned(self.event!)
                                        }
                                    case "hall", "classroom", "Android Cortex", "Parking Lot":
                                        if (location_beacon == 6434) {
                                            task.assignee = key as! String
                                            task.onAssigned(self.event!)
                                        }
                                    default:
                                        task.assignee = key as! String
                                        task.onAssigned(self.event!)
                                    
                                }
                            } else {
                                task.assignee = key as! String
                                task.onAssigned(self.event!)

                            }
                            newChild.setValue(task.toDict())
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            println(error)
                        }
                    }
                    datatask.resume()
                } else if (busy) {
                    highest_ongoing_tasks = doing
                }
                counter++
            }
        })
        
        

        
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
