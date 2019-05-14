//
//  ActivityItem.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class ActivityItem: NSObject {
    var activityName:String
    var activityLimit:Int
    var participants:[String]
    var dateStamp:Date
    var allDay:Bool
    
    init(activityName:String,activityLimit:Int, dateStamp:Date, allDay:Bool) {
        self.activityName = activityName
        self.activityLimit = activityLimit
        self.participants = []
        self.dateStamp = dateStamp
        self.allDay = allDay
    }
    
    required init(coder: NSCoder) {
        self.activityName = coder.decodeObject(forKey: "activityName")! as! String
        self.activityLimit = coder.decodeObject(forKey: "activityLimit")! as! Int
        self.participants = coder.decodeObject(forKey: "participants")! as! [String]
        self.dateStamp = coder.decodeObject(forKey: "dateStamp") as! Date
        self.allDay = coder.decodeObject(forKey: "allDay") as? Bool ?? coder.decodeBool(forKey: "allDay")
        super.init()
    }
    
    func encodeWithCoder(_ coder: NSCoder) {
        coder.encode(self.activityName, forKey: "activityName")
        coder.encode(self.activityLimit, forKey:"activityLimit")
        coder.encode(self.participants, forKey:"participants")
        coder.encode(self.dateStamp, forKey: "dateStamp")
        coder.encode(self.allDay, forKey: "allDay")
    }

    

}
