//
//  Participants.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/27/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class Participants: NSObject {
    class func getParticipants() -> [String]
    {
        let participantArchive = Filehelpers.fileInUserDocumentDirectory("participants")
        let manager = FileManager.default
        let participantData = manager.contents(atPath: participantArchive) as Data?
        if (participantData == nil ) {
            print("no participants")
        } else {
            do {
                if let loadedParticipants = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(participantData!) as? [String] {
                    return loadedParticipants
                }
            } catch {
                print("Couldn't read file.")
            }
        }
        return []
    }
    
    class func saveParticipants(participantArray:[String]) {
        let participantArchive = Filehelpers.fileInUserDocumentDirectory("participants")
        let participantURL = URL(fileURLWithPath: participantArchive)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: participantArray, requiringSecureCoding: false)
            try data.write(to: participantURL)
        } catch {
            print("Couldn't write file")
        }
    }
    
    class func removeParticipant(participant:String) {
        var participantArray = Participants.getParticipants()
        for item in participantArray {
            if item == participant {
                let index = participantArray.firstIndex(of: item) ?? 0
                participantArray.remove(at: index)
            }
        }
        // check to make sure all is okay
        for item in participantArray {
            print (item)
        }
        Participants.saveParticipants(participantArray: participantArray)
    }
    
    class func addParticipant(participant:String) {
        var array = Participants.getParticipants()
        array.append(participant)
        Participants.saveParticipants(participantArray: array)
    }
    
    class func verifyParticipant(_ participant:String) -> Bool {
        let array = Participants.getParticipants()
        for item in array {
            if item == participant {
               return true
            }
        }
        return false
    }
}
