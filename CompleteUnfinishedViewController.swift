//
//  CompleteUnfinishedViewController.swift
//  eXchange
//
//  Created by James Almeida on 4/8/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit

class CompleteUnfinishedViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

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

    
    
}
