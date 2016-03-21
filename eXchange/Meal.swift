//
//  Meal.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 3/20/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import Foundation

enum MealType {
    case Lunch
    case Dinner
}

class Meal {
    var date: NSDate
    var type: MealType
    init(date: NSDate, type: MealType) {
        self.date = date
        self.type = type
    }
}