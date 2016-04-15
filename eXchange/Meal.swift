//
//  Meal.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 3/20/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import Foundation

class Meal {
    var host: Student
    var guest: Student
    var date: String
    var type: String
    var likes: Int
    
    init(date: String, type: String, host: Student, guest: Student) {
        self.host = host
        self.guest = guest
        self.date = date
        self.type = type
        self.likes = 0
    }
}