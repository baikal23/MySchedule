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
        var activitiesForReport:[String] = []
        var activitySummary = (name:"name", count:0)
        var testName = activitySummary.name
        var summaryArray: [(name: String, count: Int)] = []
        let person = participantTextField.text!
        let schedule = WeekArray.getScheduleInRangeFor(person,  startDate:currentStartTime, endDate:currentEndTime)
        // this logic is to count occurances of the activities
        // first get them and alphabetize them
        
        for week in schedule {
            for block in week.scheduleArray {
                for activity in block.activityArray {
                    activitiesForReport.append(activity.activityName)
                }
            }
        }
        // then sort the activities alphabetically
        var sortedActivities = activitiesForReport.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        // then count occurences of each name
        if sortedActivities.count != 0 {
            activitySummary.name = sortedActivities[0] // seed with first activity
        }
        for item in sortedActivities {
            if activitySummary.name == item {
                activitySummary.count = activitySummary.count + 1
            } else {
                summaryArray.append(activitySummary)
                activitySummary.name = item
                activitySummary.count = 1
            }
        }
        summaryArray.append(activitySummary) // get the last one
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
    func makeReportFromSummaryArray()
    
    {
        
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
