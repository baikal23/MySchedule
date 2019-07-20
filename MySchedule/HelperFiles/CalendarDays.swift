//
//  CalendarDays.swift
//  MySchedule
//
//  Created by Susan Kohler on 6/2/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class CalendarDays: NSObject {
    class func getLastMonday() ->Date {
        let mondayArray = CalendarDays.getPreviousMondays()
        let lastMonday = CalendarDays.dateFromString(mondayArray[0])
        return lastMonday
    }
    class func getNextMondays() -> [String]{
        var mondays:[String] = []
        let cal = Calendar.current
        // Get the date of 1 year ahead of today
        let stopDate = cal.date(byAdding: .year, value: 1, to: Date())!
        // We want to find dates that match on Mondays at midnight local time
        var components = DateComponents()
        components.weekday = 2 // Monday
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d yyyy"
        var dateString:String = ""
        // Enumerate all of the dates
        let yesterday = Calendar.current.date(byAdding: .day, value: -8, to: Date())!
        //let yesterday = Calendar.current.date(byAdding: .day, value: -29, to: Date())!
        cal.enumerateDates(startingAfter: yesterday
        , matching: components, matchingPolicy: .previousTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .forward) { (date, match, stop) in
            if let date = date {
                if date > stopDate {
                    stop = true // We've reached the end, exit the loop
                } else {
                    
                    dateString = formatter.string(from: date)
                    print("\(dateString)") // do what you need with the date
                    mondays.append(dateString)
                }
            }
        }
        return mondays
    }
    
    class func getPreviousMondays() -> [String]{
        var mondays:[String] = []
        let cal = Calendar.current
        // Get the date of 1 year ago today
        let stopDate = cal.date(byAdding: .year, value: -1, to: Date())!
        
        // We want to find dates that match on Mondays
        var components = DateComponents()
        components.weekday = 2 // Monday
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d yyyy"
        var dateString:String = ""
        // Enumerate all of the dates
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        cal.enumerateDates(startingAfter: tomorrow, matching: components, matchingPolicy: .previousTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .backward) { (date, match, stop) in
            if let date = date {
                if date < stopDate {
                    stop = true // We've reached the end, exit the loop
                } else {
                    dateString = formatter.string(from: date)
                    print("Original date is \(date)")
                    print("Date string is \(dateString)") // do what you need with the date
                    let testDate = CalendarDays.dateFromString(dateString)
                    print("Test date is \(testDate)")
                    mondays.append(dateString)
                }
            }
        }
        return mondays
    }
    class func dateIsCurrentWeek(_ date:Date) ->Bool {
        let cal = Calendar.current
        let startDate = cal.date(byAdding: .day, value: -6, to: Date())!
        let stopDate = cal.date(byAdding: .day, value: 6, to: Date())!
        if ((date >= startDate) && (date <= stopDate)) {
               return true
            } else {
               return false
        }
    }
    
    class func dateFromString(_ dateString:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d yyyy"
        guard let date = formatter.date(from: dateString) else { return Date() }
        return date
    }
    
    class func stringFromDate(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
}
