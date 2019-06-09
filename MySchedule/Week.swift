//
//  Week.swift
//  MySchedule
//
//  Created by Susan Kohler on 6/8/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class Week: NSObject, NSCoding {
    var scheduleArray:[ScheduleBlock]
    var dateStamp:Date

    init(weekOf:Date) {
        self.scheduleArray = []
        for (index,element) in weekTimes.enumerated() {
            print("\(index) = \(element)")
            let daySchedule = ScheduleBlock(scheduleTime: element)
            scheduleArray.append(daySchedule)
        }
        self.dateStamp = weekOf
        super.init()
    }
    
    required init(coder: NSCoder) {
        self.dateStamp = coder.decodeObject(forKey: "dateStamp")! as! Date
        self.scheduleArray = coder.decodeObject(forKey: "scheduleArray") as! [ScheduleBlock]
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.dateStamp, forKey:"dateStamp")
        coder.encode(self.scheduleArray, forKey: "scheduleArray")
        
    }
    
    class func saveWeek(week:Week) {
        var array = WeekArray.getWeekArray()
        // update wek in the array if it exists
        for index in 0..<array.count {
            if array[index].dateStamp == week.dateStamp {
                array[index] = week
                WeekArray.saveWeekArray(weekArray: array)
                return
            }
        }
        // only get here if new week
        array.append(week)
        WeekArray.saveWeekArray(weekArray: array)
    }
    
    class func getWeekOf(_ weekOf:Date) -> Week {
        let array = WeekArray.getWeekArray()
        for item in array {
            if item.dateStamp == weekOf {
                return item
            }
        }
        // only get here if existing week is not found
        let newWeek = Week(weekOf: weekOf)
        return newWeek
    }
}
