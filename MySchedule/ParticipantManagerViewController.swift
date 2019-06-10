//
//  ParticipantManagerViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 6/10/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class ParticipantManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var participants:[String] = ["SK"]
    var currentParticipant = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var participantTextField: UITextField!
    @IBOutlet weak var forLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.participants = Participants.getParticipants()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        Participants.addParticipant(participant: participantTextField.text!)
        self.participants = Participants.getParticipants()
        self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.participants.remove(at: indexPath.row)
            Participants.saveParticipants(participantArray: participants)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentParticipant = self.participants[indexPath.row]
        self.forLabel.text = "for   " + currentParticipant
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
