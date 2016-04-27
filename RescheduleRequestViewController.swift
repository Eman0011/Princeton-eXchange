//
//  RescheduleRequestViewController.swift
//  eXchange
//
//  Created by James Almeida on 4/7/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import Firebase

class RescheduleRequestViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var clubPicker: UIPickerView!
    
    @IBOutlet var mealTypePicker: UIPickerView!
    

    var selectedUser: Student = Student(name: "", netid: "", club: "", proxNumber: "")
    var currentUser: Student = Student(name: "", netid: "", club: "", proxNumber: "")
    var pickerData: [String] = []
    
    var mealTypePickerData: [String] = []
    
    var selectedClub: String = ""
    var selectedType: String = ""

    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData.append("Please select a club")
        pickerData.append(selectedUser.club)
        pickerData.append(currentUser.club)
        mealTypePickerData.append("Please select a meal")
        mealTypePickerData.append("Lunch")
        mealTypePickerData.append("Dinner")
        clubPicker.dataSource = self
        clubPicker.delegate = self
        mealTypePicker.dataSource = self
        mealTypePicker.delegate = self

    }
    
  
    @IBAction func doneButton(sender: AnyObject) {
        print("HERE")
        let pendingString = "pending/" + self.selectedUser.netid
        let pendingRoot = dataBaseRoot.childByAppendingPath(pendingString)
        var endRoot = -1
        
        pendingRoot.observeEventType(.Value, withBlock: { snapshot in
            let counter = snapshot.childrenCount
            print(counter)
            endRoot = Int(counter)
        });
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        var host: Student? = nil
        var guest: Student? = nil
        
        if (selectedClub == selectedUser.club) {
            host = selectedUser
            guest = currentUser
        }
        else {
            host = currentUser
            guest = selectedUser
        }
        
        let newEntry: Dictionary<String, String> = ["Date": formatter.stringFromDate(datePicker.date), "Guest": (guest?.netid)!, "Host": (host?.netid)!, "Type": "Lunch"]
        
        let delay = 1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            let newPendingRoot = self.dataBaseRoot.childByAppendingPath(pendingString + "/")
            //updateChildValues is exactly like setValue except it doesn't delete the old data
            newPendingRoot.updateChildValues(newEntry)
            
            let pendingString1 = "pending/" + self.currentUser.netid + "/"
            
            /*let pendingString2 = pendingString1 + String(chil + String(endRoot))
             d.key)
             let pendingRootToRemove = self.dataBaseRoot.childByAppendingPath(pendingString2)
             pendingRootToRemove.removeValue()*/
            
            self.dismissViewControllerAnimated(true, completion: {});
            print("RESCHEDULED DATA")
        }

    }
   

    @IBAction func cancelButton(sender: AnyObject) {
        print("annuler")
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return pickerData[row]
        }
        else {
            return mealTypePickerData[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            selectedClub = pickerData[row]
        }
        else {
            selectedType = mealTypePickerData[row]
        }
    }
    
    
}
