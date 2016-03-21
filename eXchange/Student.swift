//
//  Student.swift
//  Exchange
//
//  Created by Emanuel Castaneda on 3/11/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import Foundation

class Student {
    var name: String
    var netid: String
    var club: String
    var proxNumber: String
    var imageName: String
    
    init(name: String, netid: String, club: String, proxNumber: String) {
        self.name = name
        self.netid = netid
        self.club = club
        self.proxNumber = proxNumber
        self.imageName = name + ".jpg"
    }
}