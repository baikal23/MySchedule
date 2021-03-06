//
//  Participants.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/27/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class Participants: NSObject {
    class func getParticipants() -> [User]
    {
        let participantArchive = Filehelpers.fileInUserDocumentDirectory("participants")
        let manager = FileManager.default
        let participantData = manager.contents(atPath: participantArchive) as Data?
        if (participantData == nil ) {
            print("no participants")
        } else {
            do {
                if let loadedParticipants = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(participantData!) as? [User] {
                    return loadedParticipants
                }
            } catch {
                print("Couldn't read file.")
            }
        }
        return []
    }
    
    class func saveParticipants(participantArray:[User]) {
        let participantArchive = Filehelpers.fileInUserDocumentDirectory("participants")
        let participantURL = URL(fileURLWithPath: participantArchive)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: participantArray, requiringSecureCoding: false)
            try data.write(to: participantURL)
        } catch {
            print("Couldn't write file")
        }
    }
    class func getParticipantWithName(_ name:String)-> User {
        var participantArray = Participants.getParticipants()
        var index = 0
        for item in participantArray {
            if item.name == name {
                index = participantArray.firstIndex(of: item) ?? 0
            }
        }
        return participantArray[index]
    }
    class func removeParticipant(participant:User) {
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
    
    class func addParticipant(participant:User) {
        var array = Participants.getParticipants()
        array.append(participant)
        Participants.saveParticipants(participantArray: array)
    }
    
    class func verifyParticipant(_ participantName:String) -> Bool {
        let array = Participants.getParticipants()
        for item in array {
            if item.name == participantName {
               return true
            }
        }
        return false
    }
    
    class func updateParticipantLoginTime(_ participantName:String) {
        let array = Participants.getParticipants()
        for item in array {
            if item.name == participantName {
                item.lastLogin = Date()
            }
        }
        Participants.saveParticipants(participantArray: array)
    }
}
