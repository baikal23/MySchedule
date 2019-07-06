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
    var currentWeek:Week!
    //var scheduleArray:[ScheduleBlock] = []
    var weekSchedule:[ScheduleBlock] = []
    var addedToScheduleArray = false
    var mondayDate:Date = Date() // initialize as today
    var weekPickerData:[String] = []
    
    @IBOutlet weak var weekPickerView: UIPickerView!
    @IBOutlet weak var scheduleBlockPicker: UIPickerView!
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scheduleBlockPicker.delegate = self
        self.scheduleBlockPicker.dataSource = self
        weekPickerView.delegate = self
        weekPickerView.dataSource = self
        // Input the data into the array
        pickerData = [kMondayAM, kMondayPM, kTuesdayAM, kTuesdayPM, kWednesdayAM, kWednesdayPM, kThursdayAM, kThursdayPM, kFridayAM, kFridayPM]
        weekPickerData = CalendarDays.getNextMondays()
        // must initialize the currentScheduleBlock
        currentScheduleBlock = ScheduleBlock(scheduleTime: kMondayAM) // make a scheduleBlock
        self.pickerView(self.scheduleBlockPicker, didSelectRow: 0, inComponent: 0)  //initialize Picker
        self.pickerView(self.weekPickerView, didSelectRow: 0, inComponent: 0)  //initialize week Picker
    }
    
    
    
    @IBAction func viewItPressed(_ sender: Any) {
        performSegue(withIdentifier: "viewWeekSegue", sender: self)
    }
    
    @IBAction func addActivityPressed(_ sender: Any) {
        // this adds an activity to the currentScheduleBlock
        let name = activityTextField.text!
        let limit = limitTextField.text!
        let limitNumber = Int(limit)!
        let newActivity = ActivityItem(activityName: name, activityLimit: limitNumber)
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
    
    @IBAction func donePressed(_ sender: Any) {
       // self.scheduleArray.append(currentScheduleBlock)
        currentWeek.scheduleArray = weekSchedule    
        Week.saveWeek(week: currentWeek)
    }

    func updateScheduleBlock() {
        // self.currentScheduleBlock.activityArray.removeAll()  //reset activityArray
        let newScheduleBlock = ScheduleBlock(scheduleTime: currentTime) // make new currentScheduleBlock so new data does not overwrite existing stuff
        newScheduleBlock.displayIndex = currentRow
        newScheduleBlock.activityArray = []
        currentScheduleBlock = newScheduleBlock
    }
    
    func getWeekScheduleArray() {
        weekSchedule = currentWeek.scheduleArray
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.scheduleBlockPicker {
            return pickerData.count
        } else {
            return weekPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.scheduleBlockPicker {
            return pickerData[row]
        } else {
            return weekPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.scheduleBlockPicker {
            currentTime = pickerData[row]
            currentRow = row
        } else {
            mondayDate = CalendarDays.dateFromString(weekPickerData[row])
            print ("Date is \(mondayDate)")
            // try this here - it works
            let date = mondayDate
            currentWeek = Week.getWeekOf(date)
            self.getWeekScheduleArray()
            print("Got the week")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewWeekSegue" {
            let destinationVC = segue.destination as! WeekCollectionViewController
            destinationVC.currentWeek = currentWeek
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
