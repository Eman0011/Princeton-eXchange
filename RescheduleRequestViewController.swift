//
//  RescheduleRequestViewController.swift
//  eXchange
//
//  Created by James Almeida on 4/7/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit

class RescheduleRequestViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var clubPicker: UIPickerView!
    @IBOutlet weak var mealSelectedLabel: UILabel!
    
    var temp: Student = Student(name: "Emanuel Castaneda", netid: "emanuelc", club: "Cannon", proxNumber: "960755555")
    var selectedUser: Student = Student(name: "", netid: "", club: "", proxNumber: "")
    let currentUser: Student = Student(name: "Sumer Parikh", netid: "", club: "Cap & Gown", proxNumber: "")
    var pickerData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData.append(selectedUser.club)
        pickerData.append(currentUser.club)
        mealSelectedLabel.text = selectedUser.name
        clubPicker.dataSource = self
        clubPicker.delegate = self
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        //performSegueWithIdentifier("doneRescheduleSegue", sender: nil)
        //self.dismissViewControllerAnimated(true, completion: {});
        print("tapped done")
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        //performSegueWithIdentifier("cancelRescheduleSegue", sender: nil)
        //self.dismissViewControllerAnimated(true, completion: {});
        print("SENT DATA")
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
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mealSelectedLabel.text = pickerData[row]

    }
    
//    // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "cancelRescheduleSegue" {
//            let newViewController:eXchangeViewController = segue.destinationViewController as! eXchangeViewController
//
//            newViewController.rescheduleDoneButtonHit = false
//            
//            print("canceled")
//            self.dismissViewControllerAnimated(true, completion: {});
//        }
//        else if segue.identifier == "doneRequestSegue" {
//            let newViewController:eXchangeViewController = segue.destinationViewController as! eXchangeViewController
//            
//            newViewController.rescheduleDoneButtonHit = true
//            
//            print("completed")
//            self.dismissViewControllerAnimated(true, completion: {});
//        }
//        
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
    
    
}
