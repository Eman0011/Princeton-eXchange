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
    
    init(host: Student, guest: Student, type: String) {
        self.host = host
        self.guest = guest
        let meal = Meal(date: NSDate(), type: type, host: host, guest: guest)
        self.meal1 = meal
    }
    
    func completeExchange(date: NSDate, type: String, host: Student, guest: Student) {
        self.meal2 = Meal(date: date, type: type, host: host, guest: guest)
    }
}