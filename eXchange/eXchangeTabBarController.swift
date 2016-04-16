//
//  eXchangeTabBarController.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 4/6/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import Firebase

class eXchangeTabBarController: UITabBarController {
    var userNetID: String = ""
    var studentsData: [Student] = []
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")

    override func viewDidLoad() {
        loadStudents()
    }
    func loadStudents() {
        let studentsRoot = dataBaseRoot.childByAppendingPath("students")
        studentsRoot.observeEventType(.ChildAdded, withBlock:  { snapshot in
            let student = self.getStudentFromDictionary(snapshot.value as! Dictionary<String, String>)
            self.studentsData.append(student)
            })
    }
    
    func getStudentFromDictionary(dictionary: Dictionary<String, String>) -> Student {
        let student = Student(name: dictionary["name"]!, netid: dictionary["netID"]!, club: dictionary["club"]!, proxNumber: dictionary["proxNumber"]!)
        return student
    }
}
