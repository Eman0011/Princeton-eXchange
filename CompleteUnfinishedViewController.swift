//
//  CompleteUnfinishedViewController.swift
//  eXchange
//
//  Created by James Almeida on 4/8/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import Firebase

class CompleteUnfinishedViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
 
    @IBOutlet var meal: UILabel!
    
    @IBOutlet var club: UILabel!
    
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")

    var selectedUser: Student = Student(name: "", netid: "", club: "", proxNumber: "", image: "")
    var currentUser: Student = Student(name: "", netid: "", club: "", proxNumber: "", image: "")

    var setType: String = ""
    var setClub: String = ""

    override func viewDidLoad() {
        datePicker.minimumDate = NSDate()
        let endDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: daysLeft,
            toDate: NSDate(),
            options: NSCalendarOptions(rawValue: 0))
        datePicker.maximumDate = endDate
        meal.text = setType
        club.text = setClub
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    
    @IBAction func doneButton(sender: AnyObject) {
            let pendingString = "pending/" + self.selectedUser.netid
            let pendingRoot = dataBaseRoot.childByAppendingPath(pendingString)
            var endRoot = -1
            
            pendingRoot.observeSingleEventOfType(.Value, withBlock: { snapshot in
                var num: Int = 0
                let children = snapshot.children
                let count = snapshot.childrenCount
                
                while let child = children.nextObject() as? FDataSnapshot {
                    if (num != Int(child.key)) {
                        endRoot = num
                        break
                    }
                    else {
                        num+=1
                    }
                }
                if (endRoot == -1) {
                    endRoot = Int(count)
                }
            });
            
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
        
            let newEntry: Dictionary<String, String> = ["Date": formatter.stringFromDate(datePicker.date), "Guest": selectedUser.netid, "Host": currentUser.netid, "Type": setType, "Club": setClub]
            
            let delay = 1 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                let newPendingRoot = self.dataBaseRoot.childByAppendingPath(pendingString + "/" + String(endRoot))
    
                newPendingRoot.updateChildValues(newEntry)
                
                self.dismissViewControllerAnimated(true, completion: {});
            }
        }
    
    }
    

