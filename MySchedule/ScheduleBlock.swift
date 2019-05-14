//
//  ScheduleBlock.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class ScheduleBlock: NSObject {
    var scheduleTime:String
    var dateStamp:Date
    var displayIndex:Int
    var activityArray:[ActivityItem]

    init(scheduleTime:String, dateStamp:Date) {
        self.scheduleTime = scheduleTime
        self.dateStamp = dateStamp
        self.displayIndex = 0  // to seed the value
        if scheduleTime == kMondayAM {
            self.displayIndex = 0
        } else if scheduleTime == kMondayPM {
            self.displayIndex = 1
        } else if scheduleTime == kTuesdayAM {
            self.displayIndex = 2
        } else if scheduleTime == kTuesdayPM {
            self.displayIndex = 3
        } else if scheduleTime == kWednesdayAM {
            self.displayIndex = 4
        } else if scheduleTime == kWednesdayPM {
            self.displayIndex = 5
        } else if scheduleTime == kThursdayAM {
            self.displayIndex = 6
        } else if scheduleTime == kThursdayPM {
            self.displayIndex = 7
        } else if scheduleTime == kFridayAM {
            self.displayIndex = 8
        } else if scheduleTime == kFridayPM {
            self.displayIndex = 9
        }
        self.activityArray = []
    }
    
    required init(coder: NSCoder) {
        self.scheduleTime = coder.decodeObject(forKey: "scheduleTime")! as! String
        self.dateStamp = coder.decodeObject(forKey: "dateStamp")! as! Date
        self.displayIndex = coder.decodeObject(forKey: "displayIndex")! as! Int
        self.activityArray = coder.decodeObject(forKey: "activityArray") as! [ActivityItem]
        super.init()
    }
    
    func encodeWithCoder(_ coder: NSCoder) {
        coder.encode(self.scheduleTime, forKey: "scheduleTime")
        coder.encode(self.dateStamp, forKey:"dateStamp")
        coder.encode(self.displayIndex, forKey:"displayIndex")
        coder.encode(self.activityArray, forKey: "activityArray")
    }
}
