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
    var currentUser: Student = Student(name: "Emanuel Castaneda", netid: "emanuelc", club: "Cannon", proxNumber: "", image: "")
    var studentsData: [Student] = []
    var netidToStudentMap = [String : Student] ()
    var friendsDict = [String : String]()
    var friendsData: [Student] = []
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")

    override func viewDidLoad() {
        loadStudents()
        loadFriends()
        let delay = 2 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.getFriendsFromDict()
        }
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
            self.friendsDict[snapshot.key] = snapshot.value as? String
            
        })
    }
    
    func getFriendsFromDict() {
        let byValue = {
            (elem1:(key: String, val: String), elem2:(key: String, val: String))->Bool in
            if Int(elem1.val) > Int(elem2.val) {
                return true
            } else {
                return false
            }
        }
        
        let sortedDict = self.friendsDict.sort(byValue)
        
        for (key, value) in sortedDict {
            let student = netidToStudentMap[key]!
            student.friendScore = Int(value)!
            friendsData.append(student)
        }
    }
    
    func getStudentFromDictionary(dictionary: Dictionary<String, String>) -> Student {
        let student = Student(name: dictionary["name"]!, netid: dictionary["netID"]!, club: dictionary["club"]!, proxNumber: dictionary["proxNumber"]!, image: dictionary["image"]!)

        if (student.netid == userNetID) {
            currentUser = student
        }
        
        return student
    }
}
