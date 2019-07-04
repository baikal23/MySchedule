//
//  AdminViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
