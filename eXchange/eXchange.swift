//
//  eXchange.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 3/20/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import Foundation

class eXchange {
    var host: Student
    var guest: Student
    var meal1: Meal
    var meal2: Meal?
    var completed: Bool
    
    init(host: Student, guest: Student, type: String) {
        self.host = host
        self.guest = guest
        let meal1 = Meal(date: NSDate(), type: type, host: host, guest: guest)
        self.meal1 = meal1
        let meal2 = Meal(date: NSDate(), type: type, host: host, guest: guest)
        self.meal2 = meal2
        self.completed = false
    }
    
    func completeExchange(date: NSDate, type: String, host: Student, guest: Student) {
        self.meal2 = Meal(date: date, type: type, host: host, guest: guest)
    }
}