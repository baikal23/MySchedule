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
    var reportName = ""
    var summaryArray: [(name: String, count: Int)] = []
    
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
        reportName = "WeeklySchedule"
        ReportGenerator.setupPDFDocumentNamed(name: reportName)
        for item in weeksInRange {
            self.makePDFreportFor(week:item, withParticipants: true)
        }
        ReportGenerator.finishPDF()
        let nextViewController = PDFViewController()
        nextViewController.reportName = reportName
        nextViewController.userName = ""
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func blankSchedulePushed(_ sender: Any) {
        let currentWeek = Week.getWeekOf(currentStartTime)
        reportName = "BlankSchedule"
        ReportGenerator.setupPDFDocumentNamed(name: reportName)
        self.makePDFreportFor(week:currentWeek, withParticipants: false)
        ReportGenerator.finishPDF()
        let nextViewController = PDFViewController()
        nextViewController.reportName = reportName
        nextViewController.userName = ""
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    @IBAction func participantReportPushed(_ sender: Any) {
        var activitiesForReport:[String] = []
        var activitySummary = (name:"name", count:0)
        let person = participantTextField.text!
        if person == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter a participant name", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        var peopleArray:[String] = [person]
        let userArray:[User] = Participants.getParticipants()
        reportName = "WeeklySchedule"
         ReportGenerator.setupPDFDocumentNamed(name: reportName)
        if person == "ALL" {
            peopleArray = []
            for item in userArray {
                peopleArray.append(item.name)
            }
        }
        for person in peopleArray {
            summaryArray = []
            activitiesForReport = []
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
                activitySummary.count = 0 // reinitialize
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
            makeReportFromSummaryArray(forPerson: person)
        }
        ReportGenerator.finishPDF()
        let nextViewController = PDFViewController()
        nextViewController.reportName = reportName
        nextViewController.userName = ""
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    func makeReportFromSummaryArray(forPerson:String){
        let reportTitle = "Activity Summary for " + forPerson
        let pageSize = CGSize(width: pdfPageWidth, height: pdfPageHeight)
        ReportGenerator.beginPDFPage()
        let titleTextRect = ReportGenerator.addText(text: reportTitle, frame: CGRect(x: pdfPadding, y: pdfPadding, width: (pageSize.width) - 2 * pdfPadding, height: pdfTitleBoxHeight), fontSize: pdfTitleFont)
        var verticalDistance = pdfPadding + titleTextRect.size.height + pdfPadding
        let blueLineRect = ReportGenerator.addLineWithFrame(frame: CGRect(x: pdfPadding, y: verticalDistance + pdfPadding, width: (pageSize.width) - 2 * pdfPadding, height: pdfLineBoxHeight), color: pdfLineColor)
        verticalDistance = verticalDistance + blueLineRect.size.height + pdfPadding
        let startDate:String = CalendarDays.stringFromDate(currentStartTime)
        let endDate = CalendarDays.stringFromDate(currentEndTime)
        let headingText = "Week of " + startDate + " to Week of " + endDate
        let headingRect = ReportGenerator.addText(text: headingText, frame: CGRect(x: pdfPadding, y: verticalDistance, width: (pageSize.width) - 2 * pdfPadding, height: pdfHeadingBoxHeight), fontSize: pdfHeadingFont)
        verticalDistance = verticalDistance + headingRect.size.height + pdfPadding
        for item in summaryArray {
            let activityText = item.name + "\t\t" + String(item.count) + "  times"
            let activityRect = ReportGenerator.addText(text: activityText, frame: CGRect(x: pdfPadding, y: verticalDistance, width: (pageSize.width) - 2 * pdfPadding, height: pdfTextLineBoxHeight), fontSize: pdfActivityFont)
            verticalDistance = verticalDistance + activityRect.size.height + pdfPadding
            if (verticalDistance > pdfPageHeight - pdfBottomMargin) {
                ReportGenerator.beginPDFPage()
                verticalDistance = pdfTopMargin
            }
        }
    }
    func makePDFreportFor(week:Week, withParticipants:Bool){
        let dateString = CalendarDays.stringFromDate(week.dateStamp)
        let reportTitle = "Schedule for Week of " + dateString
        //let reporter = ReportGenerator()
        let pageSize = CGSize(width: pdfPageWidth, height: pdfPageHeight)
        ReportGenerator.beginPDFPage()
        let titleTextRect = ReportGenerator.addText(text: reportTitle, frame: CGRect(x: pdfPadding, y: pdfPadding, width: (pageSize.width) - 2 * pdfPadding, height: pdfTitleBoxHeight), fontSize: pdfTitleFont)
        var verticalDistance = pdfPadding + titleTextRect.size.height + pdfPadding
        let blueLineRect = ReportGenerator.addLineWithFrame(frame: CGRect(x: pdfPadding, y: verticalDistance + pdfPadding, width: (pageSize.width) - 2 * pdfPadding, height: pdfLineBoxHeight), color: pdfLineColor)
        verticalDistance = verticalDistance + blueLineRect.size.height + pdfPadding
        
        for block in week.scheduleArray {
            let headingRect = ReportGenerator.addText(text: block.scheduleTime, frame: CGRect(x: pdfPadding, y: verticalDistance, width: (pageSize.width) - 2 * pdfPadding, height: pdfHeadingBoxHeight), fontSize: pdfHeadingFont)
            verticalDistance = verticalDistance + headingRect.size.height + pdfPadding
            for activity in block.activityArray {
                var activityText = activity.activityName
                if (withParticipants) {
                    let joined = activity.participants.joined(separator: ", ")
                    activityText = activityText + ":  " + joined
                }
                let activityRect = ReportGenerator.addText(text: activityText, frame: CGRect(x: pdfPadding, y: verticalDistance, width: (pageSize.width) - 2 * pdfPadding, height: pdfTextLineBoxHeight), fontSize: pdfActivityFont)
                verticalDistance = verticalDistance + activityRect.size.height + pdfPadding
                if (verticalDistance > pdfPageHeight - pdfBottomMargin) {
                    ReportGenerator.beginPDFPage()
                    verticalDistance = pdfTopMargin
                }
            }
        }
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
