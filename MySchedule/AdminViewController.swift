//
//  AdminViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var participants:[String] = ["SK"]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var participantTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.participants = Participants.getParticipants()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        Participants.addParticipant(participant: participantTextField.text!)
        self.participants = Participants.getParticipants()
        self.tableView.reloadData()
    }
    @IBAction func clearOldSchedulesPressed(_ sender: Any) {
        ScheduleBlock.deleteAllOldSchedules()
    }
    
    @IBAction func getAllSchedulesPressed(_ sender: Any) {
        let theSchedules = ScheduleBlock.getSchedules()
        if theSchedules.count > 0 {
            print("We have schedules")
        }
    }

    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")
        if (cell != nil) {
            cell = UITableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        let theIndex = indexPath.row
        cell!.textLabel?.text = participants[theIndex]
        
        return cell!
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
