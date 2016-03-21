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
    
    init(host: Student, guest: Student, type: MealType) {
        self.host = host
        self.guest = guest
        let meal = Meal(date: NSDate(), type:type)
        self.meal1 = meal
    }
}