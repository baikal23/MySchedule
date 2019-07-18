//
//  AdminViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {

    var peopleWhoNeedSignUp:[String] = []
    @IBOutlet weak var signUpTextView: UITextView!
    @IBOutlet weak var participantManagerButton: UIButton!
    @IBOutlet weak var activitiesManagerButton: UIButton!
    
    @IBOutlet weak var reportManagerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    func setupUI() {
        self.view.backgroundColor = ColorScheme.pageBackgroundColor
    }
    override func viewWillAppear(_ animated: Bool) {
        let peopleArray = Participants.getParticipants()
        peopleWhoNeedSignUp = []
        let lastMonday = CalendarDays.getLastMonday()
        for person in peopleArray {
            if person.lastLogin < lastMonday {
                peopleWhoNeedSignUp.append(person.name)
            }
        }
        let joined = peopleWhoNeedSignUp.joined(separator: ", ")
        self.signUpTextView.text = joined
    }
    
    @IBAction func activitiesManagerPushed(_ sender: Any) {
        performSegue(withIdentifier: "activitiesManagerSegue", sender: self)
    }
    
    @IBAction func participantManagerPushed(_ sender: Any) {
        performSegue(withIdentifier: "participantManagerSegue", sender: self)
    }
    @IBAction func reportManagerPushed(_ sender: Any) {
        performSegue(withIdentifier: "reportManagerSegue", sender: self)
    }

    @IBAction func clearOldSchedulesPressed(_ sender: Any) {
        WeekArray.deleteAllWeeks()
    }
    
    @IBAction func getAllSchedulesPressed(_ sender: Any) {
        let theWeekArray = WeekArray.getWeekArray()
        if theWeekArray.count > 0 {
            print("We have \(theWeekArray.count) weeks")
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
