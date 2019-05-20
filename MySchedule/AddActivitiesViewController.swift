//
//  AddActivitiesViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class AddActivitiesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var pickerData: [String] = [String]()
    var currentTime:String = ""
    var currentRow = 0
    var currentScheduleBlock:ScheduleBlock!  // must initialize before use
    //var scheduleArray:[ScheduleBlock] = []
    var weekSchedule:[ScheduleBlock] = []
    var addedToScheduleArray = false
    
    @IBOutlet weak var weekPicker: UIDatePicker!
    @IBOutlet weak var scheduleBlockPicker: UIPickerView!
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
    @IBOutlet weak var allDayTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scheduleBlockPicker.delegate = self
        self.scheduleBlockPicker.dataSource = self
        // Input the data into the array
        pickerData = [kMondayAM, kMondayPM, kTuesdayAM, kTuesdayPM, kWednesdayAM, kWednesdayPM, kThursdayAM, kThursdayPM, kFridayAM, kFridayPM]
        // must initialize the currentScheduleBlock
        currentScheduleBlock = ScheduleBlock(scheduleTime: kMondayAM, dateStamp: weekPicker.date) // make a scheduleBlock
        self.pickerView(self.scheduleBlockPicker, didSelectRow: 0, inComponent: 0)  //initialize Picker
        // Do any additional setup after loading the view.
        self.weekPicker.datePickerMode = .date
        self.makeWeekScheduleArray()
    }
    
    @IBAction func addActivityPressed(_ sender: Any) {
        // this adds an activity to the currentScheduleBlock
        let name = activityTextField.text!
        let limit = limitTextField.text!
        let limitNumber = Int(limit)!
        var allDay = false
        if (allDayTextField.text == "Y") {
            allDay = true
        }
        let newActivity = ActivityItem(activityName: name, activityLimit: limitNumber, allDay: allDay)
        // add activity to currentBlock or save it and make a new schedule block
        /*if (currentScheduleBlock.scheduleTime != currentTime) {
           // self.scheduleArray.append(currentScheduleBlock)
            self.updateScheduleBlock()
        }*/
        for item in weekSchedule {
            if item.scheduleTime == currentTime {
                item.activityArray.append(newActivity)
            }
        }
       /* currentScheduleBlock.activityArray.append(newActivity)
        print("Activity is" + newActivity.activityName)
        print("Added to " + currentScheduleBlock.scheduleTime)*/
    }
    @IBAction func nextTimeBlockPressed(_ sender: Any) {
        let newRow = currentRow + 1
        self.scheduleBlockPicker.selectRow(newRow, inComponent: 0, animated: true)
        self.pickerView(self.scheduleBlockPicker, didSelectRow: newRow, inComponent: 0)
        self.activityTextField.text = ""
        self.limitTextField.text = ""
        self.allDayTextField.text = "n"
        self.view.setNeedsDisplay()
    }
    
    @IBAction func donePressed(_ sender: Any) {
       // self.scheduleArray.append(currentScheduleBlock)
        ScheduleBlock.saveSchedules(scheduleArray: weekSchedule)
    }

    func updateScheduleBlock() {
        // self.currentScheduleBlock.activityArray.removeAll()  //reset activityArray
        let newScheduleBlock = ScheduleBlock(scheduleTime: currentTime, dateStamp: weekPicker.date) // make new currentScheduleBlock so new data does not overwrite existing stuff
        newScheduleBlock.displayIndex = currentRow
        newScheduleBlock.activityArray = []
        currentScheduleBlock = newScheduleBlock
    }
    
    func makeWeekScheduleArray() {
        weekSchedule = []
        for (index,element) in weekTimes.enumerated() {
            print("\(index) = \(element)")
            let daySchedule = ScheduleBlock(scheduleTime: element, dateStamp: weekPicker.date)
            weekSchedule.append(daySchedule)
        }
        ScheduleBlock.saveSchedules(scheduleArray: weekSchedule)

    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentTime = pickerData[row]
        currentRow = row
        print("currentTime is \(currentTime)")
        print("CurrentRow is \(currentRow)")
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
