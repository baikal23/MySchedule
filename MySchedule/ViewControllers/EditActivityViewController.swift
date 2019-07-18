//
//  EditActivityViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/28/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class EditActivityViewController: UIViewController {

    var selectedArrayIndex:Int = 0
    var chosenActivity:ActivityItem!
    var currentWeek:Week!
    @IBOutlet weak var participantTextField: UITextField!
    @IBOutlet weak var activityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Activity is " + chosenActivity.activityName)
        self.activityNameLabel.text = chosenActivity.activityName
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    func setupUI() {
        self.view.backgroundColor = ColorScheme.pageBackgroundColor
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        chosenActivity.participants.append(participantTextField.text!)
        print("Added participant. Count is \(chosenActivity.participants.count)")
        Week.updateActivityInScheduleBlockforWeek(selectedArrayIndex, activityToUpdate: chosenActivity, newParticipants: chosenActivity.participants, currentWeek: currentWeek)
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        for index in 0..<chosenActivity.participants.count {
            if chosenActivity.participants[index] == participantTextField.text! {
                chosenActivity.participants.remove(at: index)
                print("Removed participant.  Count is \(chosenActivity.participants.count)")
                Week.updateActivityInScheduleBlockforWeek(selectedArrayIndex, activityToUpdate: chosenActivity, newParticipants: chosenActivity.participants, currentWeek: currentWeek)
                return
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
