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
    var userNetID: String = "jamespa"
    var currentUser: Student = Student(name: "Emanuel Castaneda", netid: "emanuelc", club: "Cannon", proxNumber: "", image: "")
    var studentsData: [Student] = []
    var netidToStudentMap = [String : Student] ()
    var friendsDict = [String : String]()
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")

    override func viewDidLoad() {
        loadStudents()
        loadFriends()
    }
    
    func loadStudents() {
        let studentsRoot = dataBaseRoot.childByAppendingPath("students")
        studentsRoot.observeEventType(.ChildAdded, withBlock:  { snapshot in
            let student = self.getStudentFromDictionary(snapshot.value as! Dictionary<String, String>)
            self.studentsData.append(student)
            self.netidToStudentMap[student.netid] = student
        })
    }
    
    func loadFriends() {
        let friendsRoot = dataBaseRoot.childByAppendingPath("friends/" + self.userNetID)
        friendsRoot.observeEventType(.ChildAdded, withBlock:  { snapshot in
            print(snapshot.key)
            print(snapshot.value)
            self.friendsDict[snapshot.key] = snapshot.value as? String
            
        })
    }
    
    func getStudentFromDictionary(dictionary: Dictionary<String, String>) -> Student {
        let student = Student(name: dictionary["name"]!, netid: dictionary["netID"]!, club: dictionary["club"]!, proxNumber: dictionary["proxNumber"]!, image: dictionary["image"]!)

        if (student.netid == userNetID) {
            currentUser = student
        }
        
        return student
    }
}
