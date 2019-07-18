//
//  AddActivitiesViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class AddActivitiesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

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
    var activeField:UITextField!
    var lastOffset = CGPoint(x: 0,y: 0)
    var keyboardHeight = CGFloat(0.0)
    
    @IBOutlet weak var weekPickerView: UIPickerView!
    @IBOutlet weak var scheduleBlockPicker: UIPickerView!
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addActivitiesButton: UIButton!
    @IBOutlet weak var viewWeekButton: UIButton!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scheduleBlockPicker.delegate = self
        self.scheduleBlockPicker.dataSource = self
        self.activityTextField.delegate = self
        self.limitTextField.delegate = self
        weekPickerView.delegate = self
        weekPickerView.dataSource = self
        // Input the data into the array
        pickerData = [kMondayAM, kMondayPM, kTuesdayAM, kTuesdayPM, kWednesdayAM, kWednesdayPM, kThursdayAM, kThursdayPM, kFridayAM, kFridayPM]
        weekPickerData = CalendarDays.getNextMondays()
        // must initialize the currentScheduleBlock
        currentScheduleBlock = ScheduleBlock(scheduleTime: kMondayAM) // make a scheduleBlock
        self.pickerView(self.scheduleBlockPicker, didSelectRow: 0, inComponent: 0)  //initialize Picker
        self.pickerView(self.weekPickerView, didSelectRow: 0, inComponent: 0)  //initialize week Picker
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(AddActivitiesViewController.keyboardWillShow(_:)),
             name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(AddActivitiesViewController.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(AddActivitiesViewController.donePressed))
        self.navigationItem.leftBarButtonItem = newBackButton
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    func setupUI() {
        self.contentView.backgroundColor = ColorScheme.pageBackgroundColor
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func viewItPressed(_ sender: Any) {
        performSegue(withIdentifier: "viewWeekSegue", sender: self)
    }
    
    @IBAction func addActivityPressed(_ sender: Any) {
        // this adds an activity to the currentScheduleBlock
        let name = activityTextField.text!
        let limit = limitTextField.text!
        if ((name == "") || (limit == "")) {
            let alert = UIAlertController(title: "Alert", message: "Please fill in activity name and limit", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let limitNumber = Int(limit)
        if limitNumber == nil {
            let alert = UIAlertController(title: "Alert", message: "Please enter a number for the limit", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let newActivity = ActivityItem(activityName: name, activityLimit: limitNumber ?? 50)
        // add activity to currentBlock or save it and make a new schedule block
        /*if (currentScheduleBlock.scheduleTime != currentTime) {
           // self.scheduleArray.append(currentScheduleBlock)
            self.updateScheduleBlock()
        }*/
        for item in weekSchedule {
            if item.scheduleTime == currentTime {
                var alreadyAdded = false // prevent double entry
                for activity in item.activityArray {
                    if activity.activityName == newActivity.activityName {
                        alreadyAdded = true
                    }
                }
                if (!alreadyAdded) {
                    item.activityArray.append(newActivity)
                }
            }
        }
       /* currentScheduleBlock.activityArray.append(newActivity)
        print("Activity is" + newActivity.activityName)
        print("Added to " + currentScheduleBlock.scheduleTime)*/
    }
    
    @objc func donePressed() {
       // self.scheduleArray.append(currentScheduleBlock)
        currentWeek.scheduleArray = weekSchedule    
        Week.saveWeek(week: currentWeek)
         _ = navigationController?.popViewController(animated: true)
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
    
    // MARK: Keyboard control
    @objc func keyboardWillShow(_ notification: Notification) {
        if keyboardHeight != 0.0 {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.contentViewHeight.constant += self.keyboardHeight
            })
            // move if keyboard hide input field
            let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            if collapseSpace < 0 {
                // no collapse
                return
            }
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
   @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.contentViewHeight.constant -= self.keyboardHeight
            self.scrollView.contentOffset = self.lastOffset
        }
        keyboardHeight = 0.0
    }
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
