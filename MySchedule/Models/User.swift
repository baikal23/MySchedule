//
//  User.swift
//  MySchedule
//
//  Created by Susan Kohler on 6/11/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    var name:String
    var scheduleTimes:[String]

    init(name:String) {
        self.name = name
        self.scheduleTimes = [] // these will be filled in later
        super.init()
        
    }
    required init(coder: NSCoder) {
        self.scheduleTimes = coder.decodeObject(forKey: "scheduleTimes")! as! [String]
        self.name = coder.decodeObject(forKey: "name") as! String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.scheduleTimes, forKey: "scheduleTimes")
        coder.encode(self.name, forKey:"name")
    }
}
