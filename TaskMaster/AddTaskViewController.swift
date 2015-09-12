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
        var firebaseRoot:Firebase = Firebase(url: "https://thetaskmaster.firebaseio.com/tasks/\(event!.id)")
        var newChild = firebaseRoot.childByAutoId()
        var task:Task = Task()
        task.title = inputTaskName.text
        task.state = TaskState.Backlog
        task.assignee = ""
        newChild.setValue(task.toDict())
        
        self.navigationController?.popViewControllerAnimated(true)
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
