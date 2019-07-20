//
//  ParticipantManagerViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 6/10/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class ParticipantManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var participants:[User] = []
    var currentParticipant:User!
    var itemsToDisplay = reorderedTimes
    let reuseIdentifier = "ScheduleBlockCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var participantTextField: UITextField!
    @IBOutlet weak var forLabel: UILabel!
    @IBOutlet weak var addParticipantButton: UIButton!
    @IBOutlet weak var printWeklyScheduleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.participants = Participants.getParticipants()
        self.currentParticipant = User(name: "SJK")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.collectionView.allowsMultipleSelection = true
        // Do any additional setup after loading the view.
        for index in 0..<itemsToDisplay.count {
            var path = IndexPath(row: 0, section: 0)
                path.row = index
                path.section = 0
            self.collectionView.selectItem(at: path, animated: true, scrollPosition: .top)
        }
        self.setupUI()
    }
    
    func setupUI() {
       self.navigationController?.navigationBar.tintColor = ColorScheme.backButtonColor
        self.view.backgroundColor = ColorScheme.pageBackgroundColor
        self.addParticipantButton.setTitleColor(ColorScheme.buttonTextColor, for: .normal)
        self.addParticipantButton.backgroundColor = ColorScheme.buttonColor
        addParticipantButton.layer.cornerRadius = cornerRadius
        addParticipantButton.layer.borderWidth = borderWidth
        addParticipantButton.layer.borderColor = UIColor.clear.cgColor
        addParticipantButton.clipsToBounds = true
        self.printWeklyScheduleButton.setTitleColor(ColorScheme.buttonTextColor, for: .normal)
        self.printWeklyScheduleButton.backgroundColor = ColorScheme.buttonColor
        printWeklyScheduleButton.layer.cornerRadius = cornerRadius
        printWeklyScheduleButton.layer.borderWidth = borderWidth
        printWeklyScheduleButton.layer.borderColor = UIColor.clear.cgColor
        printWeklyScheduleButton.clipsToBounds = true
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        currentParticipant.name = participantTextField.text!
        if currentParticipant.name == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter a participant name", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.participants = Participants.getParticipants()
        for person in participants {
            if person.name == currentParticipant.name {
                let alert = UIAlertController(title: "Alert", message: "That person is already registered", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                Participants.addParticipant(participant: currentParticipant)
                self.participants = Participants.getParticipants()
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func printSchedulePressed(_ sender: Any) {
        let user = currentParticipant.name
        let lastMonday = CalendarDays.getLastMonday()
        let week = Week.getWeeklyScheduleFor(user, weekOf: lastMonday)
        print("Got the schedule")
        let dateString = CalendarDays.stringFromDate(week.dateStamp)
        let reportTitle = "Schedule for Week of " + dateString
        let reportName = "Schedule"
        ReportGenerator.setupPDFDocumentNamed(name: reportName)
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
                for person in activity.participants {
                    if (user == person) {
                        let activityRect = ReportGenerator.addText(text: activity.activityName, frame: CGRect(x: pdfPadding, y: verticalDistance, width: (pageSize.width) - 2 * pdfPadding, height: pdfTextLineBoxHeight), fontSize: pdfActivityFont)
                        verticalDistance = verticalDistance + activityRect.size.height + pdfPadding
                        if (verticalDistance > pdfPageHeight - pdfBottomMargin) {
                            ReportGenerator.beginPDFPage()
                            verticalDistance = pdfTopMargin
                        }
                    }
                }
            }
        }
        ReportGenerator.finishPDF()
        let pdf = Filehelpers.fileInUserDocumentDirectory(reportName)
        print("report name is: \(reportName)")
        
        if let contents = try? Data(contentsOf: URL(fileURLWithPath: pdf)) {
            let printController = UIPrintInteractionController.shared
            // 2
            let printInfo = UIPrintInfo(dictionary:nil)
            printInfo.outputType = .general
            printInfo.jobName = "PrintFromScheduleApp"
            printController.printInfo = printInfo
            printController.printingItem = contents
            //   printController.present(animated: true, completionHandler: nil)
            printController.present(animated: true) { (controller, success, error) -> Void in
                print("Done printing")
            }
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
        cell!.textLabel?.text = participants[theIndex].name
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
        self.forLabel.text = "for   " + currentParticipant.name
    }
    
    // MARK: UICollectionViewDataSource
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("IndexPath row is \(indexPath.row) and indexPath.section is \(indexPath.section)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ScheduleBlockCell
        cell.backgroundColor = ColorScheme.cellColor
        //cell.label.font = cellFont
        //cell.label.textColor = ColorScheme.cellFontColor
        if cell.isSelected {
            cell.backgroundColor = UIColor.yellow
        }
        let cellItem = itemsToDisplay[indexPath.row]
        cell.label.text = cellItem
        var foundTheTime = false
        if cell.isSelected {
            for item in currentParticipant.scheduleTimes {
                if item == cellItem {
                    foundTheTime = true
                }
            }
            if (!foundTheTime) {
                currentParticipant.scheduleTimes.append(cellItem)
            }
        }
       // cell.isSelected = true
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("we selected a cell")
        let cellItem = itemsToDisplay[indexPath.row]
        var foundTheTime = false
        for item in currentParticipant.scheduleTimes {
            if item == cellItem {
                foundTheTime = true
            }
        }
        if (!foundTheTime) {   currentParticipant.scheduleTimes.append(cellItem)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("we deselected a cell")
        let cellItem = itemsToDisplay[indexPath.row]
        for item in currentParticipant.scheduleTimes {
            if item == cellItem {
                let index = currentParticipant.scheduleTimes.firstIndex(of: item) ?? 0
                currentParticipant.scheduleTimes.remove(at: index)
            }
        }
    }
    // MARK: UICollectionViewDelegateFlowLayout
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionView.bounds.size
        size.height = size.height / 2
        size.width = size.width / 6
       // size.height -= topLayoutGuide.length
        //size.height -= view.safeAreaLayoutGuide.topAnchor
        //size.height -= view.safeAreaLayoutGuide.topAnchor
        size.height -= (sectionInsets.top + sectionInsets.right)
        size.width -= (sectionInsets.left + sectionInsets.right)
        
        return size
        // }
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
