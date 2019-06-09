//
//  WeekArray.swift
//  MySchedule
//
//  Created by Susan Kohler on 6/9/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class WeekArray: NSObject, NSCoding {
    var weekArray:[Week]

    required init(coder: NSCoder) {
        self.weekArray = coder.decodeObject(forKey: "weekArray") as! [Week]
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.weekArray, forKey: "weekArray")
    }
    
    class func saveWeekArray(weekArray:[Week]) {
        let weekPath = "weekArchive"
        let weekArchive = Filehelpers.fileInUserDocumentDirectory(weekPath)
        let weekURL = URL(fileURLWithPath: weekArchive)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: weekArray, requiringSecureCoding: false)
            try data.write(to: weekURL)
        } catch {
            print("Couldn't write file")
        }
    }
    
    class func getWeekArray() -> [Week] {
        let weekPath = "weekArchive"
        let weekArchive = Filehelpers.fileInUserDocumentDirectory(weekPath)
        
        let manager = FileManager.default
        let weekData = manager.contents(atPath: weekArchive) as Data?
        if (weekData == nil ) {
            print("no weekArchive")
        } else {
            do {
                if let loadedWeeks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(weekData!) as? [Week] {
                    return loadedWeeks
                }
            } catch {
                print("Couldn't read file.")
            }
        }
        // only get here if existing week is not found
        let array:[Week] = []
        return array // returns an empty archive
    }
    
    class func deleteWeeks(from:Date, to:Date) {
        
        //TO DO:  Make this work
    }
    
    class func deleteAllWeeks() {
        let array:[Week] = []
        WeekArray.saveWeekArray(weekArray: array)
    }
}
