//
//  ReportManagerViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 6/10/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class ReportManagerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var startPickerData: [String] = [String]()
    var endPickerData: [String] = [String]()
    var currentStartTime = Date()
    var currentEndTime = Date()
    
    @IBOutlet weak var startDatePicker: UIPickerView!
    @IBOutlet weak var endDatePicker: UIPickerView!
    @IBOutlet weak var participantTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startDatePicker.delegate = self
        self.startDatePicker.dataSource = self
        endDatePicker.delegate = self
        endDatePicker.dataSource = self
        startPickerData = CalendarDays.getPreviousMondays()
        endPickerData = CalendarDays.getPreviousMondays()
        self.pickerView(self.startDatePicker, didSelectRow: 0, inComponent: 0)  //initialize Picker
        self.pickerView(self.endDatePicker, didSelectRow: 0, inComponent: 0)  //initialize week Picker
        // Do any additional setup after loading the view.
    }
    @IBAction func makeReportPushed(_ sender: Any) {
        let weeksInRange = WeekArray.getWeeksInRangeFrom(currentStartTime, endDate: currentEndTime)
        print("Got the schedules")
    }
    
    @IBAction func participantReportPushed(_ sender: Any) {
        let person = participantTextField.text!
        let schedule = WeekArray.getScheduleInRangeFor(person,  startDate:currentStartTime, endDate:currentEndTime)
        print("Got the schedule")
    }
    // MARK: - Picker Views
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.startDatePicker {
            return startPickerData.count
        } else {
            return endPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.startDatePicker {
            return startPickerData[row]
        } else {
            return endPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.startDatePicker {
            currentStartTime = CalendarDays.dateFromString(startPickerData[row])
            print (" Start Date is \(currentStartTime)")
        } else {
            currentEndTime = CalendarDays.dateFromString(endPickerData[row])
            print (" End Date is \(currentEndTime)")
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
