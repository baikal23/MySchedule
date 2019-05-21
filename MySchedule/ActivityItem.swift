//
//  ActivityItem.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class ActivityItem: NSObject, NSCoding {
    var activityName:String
    var activityLimit:Int
    var participants:[String]
    var allDay:Bool
    var chosen:Bool
    
    init(activityName:String,activityLimit:Int,allDay:Bool) {
        self.activityName = activityName
        self.activityLimit = activityLimit
        self.participants = []
        self.allDay = allDay
        self.chosen = false
    }
    
    required init(coder: NSCoder) {
        self.activityName = coder.decodeObject(forKey: "activityName")! as! String
        self.activityLimit = coder.decodeInteger(forKey: "activityLimit")
        self.participants = coder.decodeObject(forKey: "participants")! as! [String] 
        self.allDay = coder.decodeObject(forKey: "allDay") as? Bool ?? coder.decodeBool(forKey: "allDay")
        self.chosen = coder.decodeObject(forKey: "chosen") as? Bool ?? coder.decodeBool(forKey: "chosen")
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.activityName, forKey: "activityName")
        coder.encode(self.activityLimit, forKey:"activityLimit")
        coder.encode(self.participants, forKey:"participants")
        coder.encode(self.allDay, forKey: "allDay")
        coder.encode(self.chosen, forKey: "chosen")
    }

    

}
