//
//  CreateRequestViewController.swift
//  eXchange
//
//  Created by James Almeida on 4/1/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit

class CreateRequestViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var clubPicker: UIPickerView!
    @IBOutlet weak var mealSelectedLabel: UILabel!
    var temp: Student = Student(name: "Emanuel Castaneda", netid: "emanuelc", club: "Cannon", proxNumber: "960755555")
    
    override func viewDidLoad() {
        mealSelectedLabel.text = temp.name
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
//    @IBAction func doneButton(sender: AnyObject) {
//        
//    }
    
    
    
}
