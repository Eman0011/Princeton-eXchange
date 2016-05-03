//
//  CreateRequestViewController.swift
//  eXchange
//
//  Created by James Almeida on 4/1/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import Firebase

class CreateRequestViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var clubPicker: UIPickerView!
    @IBOutlet weak var mealTypePicker: UIPickerView!
    
    var currentUser: Student = Student(name: "", netid: "", club: "", proxNumber: "")
    var selectedUser: Student = Student(name: "", netid: "", club: "", proxNumber: "")
    var pickerData: [String] = []
    var mealTypePickerData: [String] = []

    var selectedType: String = ""
    var selectedClub: String = ""
    
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")

    
    override func viewDidLoad() {
        datePicker.minimumDate = NSDate()
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
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        if ((selectedClub == selectedUser.club || selectedClub == currentUser.club) && (selectedType == "Lunch" || selectedType == "Dinner")) {
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
            
            let newEntry: Dictionary<String, String> = ["Date": formatter.stringFromDate(datePicker.date), "Guest": (guest?.netid)!, "Host": (host?.netid)!, "Type": selectedType, "Club": selectedClub]
            
            let delay = 1 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                let newPendingRoot = self.dataBaseRoot.childByAppendingPath(pendingString + "/" + String(endRoot))
                newPendingRoot.updateChildValues(newEntry)
                self.dismissViewControllerAnimated(true, completion: {});
            }
        }
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
