//
//  SignUpCollectionViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SignUpCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var headerView: UICollectionReusableView!
    
    fileprivate var itemsToDisplay = [ActivityItem]()
    var currentBlock = 0
    var doubleArray = [[ActivityItem]]()
    let reuseIdentifier = "ActivityCell"
    var participant:User!
    var currentWeek:Week!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentBlock = self.verifyBlock(theBlock: currentBlock)
        //let lastMonday = CalendarDays.getLastMonday()
       // currentWeek = Week.getWeekOf(lastMonday)
        print("Current week is \(currentWeek.dateStamp)")
        self.getItemsToDisplay()
        self.collectionView.allowsMultipleSelection = true
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    func setupUI() {
        self.navigationController?.navigationBar.tintColor = ColorScheme.backButtonColor
    }
    // convenience function to get activityItem from array
    func activityItemForIndexPath(_ indexPath: IndexPath) -> ActivityItem {
        var returnItem:ActivityItem!
        if indexPath.section == 0 {
            returnItem = doubleArray[currentBlock][indexPath.row]
        }/* else if indexPath.section == 1 {
            returnItem = doubleArray[currentDay * 2 + 1][indexPath.row]
        }*/
        return returnItem
    }
    
    func activityArrayForIndexPath(_ indexPath: IndexPath) -> [ActivityItem] {
        var returnArray:[ActivityItem] = []
        if indexPath.section == 0 {
            returnArray = doubleArray[currentBlock]
        } /*else if indexPath.section == 1 {
            returnArray = doubleArray[currentDay * 2 + 1]
        }*/
        return returnArray
    }
    func getItemsToDisplay() {
        let theSchedules = currentWeek.scheduleArray
        if theSchedules.count > 0 {
            print("We have schedules")
            for item in theSchedules {
                for index in 0..<item.activityArray.count {
                    item.activityArray[index].chosen = false  // no activities chosen yet by current user
                }
                doubleArray.append(item.activityArray)
            }
        }
    }

    func verifyBlock(theBlock:Int)->Int {
        var block = weekTimes[theBlock] // just to initialize
        for index in theBlock ..< 9 {
            block = weekTimes[index]
            for item in participant.scheduleTimes {
                if item == block {
                    return index
                }
            }
        }
        return currentBlock // if no matches found
    }
    
    func updateActivityParticipants() {
        let theSchedules = currentWeek.scheduleArray
        if theSchedules.count == 10 {
            print("We have schedules")
            for index in 0...9 {
                theSchedules[index].activityArray = doubleArray[index]
            }
        }
        for item in theSchedules {
            for activity in item.activityArray {
                print(activity.activityName + " has  \(activity.participants.count) " + " participants ")
            }
        }
        //ScheduleBlock.saveSchedules(scheduleArray: theSchedules)
        Week.saveWeek(week: currentWeek)
            
        
    }
    func registerParticipant() {
        Participants.updateParticipantLoginTime(participant.name)
        var alreadyRegistered = false
        for item in doubleArray[currentBlock] {
            if item.chosen == true {
                for person in item.participants {
                    if person == participant.name {
                        alreadyRegistered = true
                    }
                }
                if (!alreadyRegistered) {
                    item.participants.append(participant.name)
                }
            }
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        self.registerParticipant()
        self.updateActivityParticipants()
        DispatchQueue.main.async {
            let alertTitle = "Would you print the schedule?"
            let alert = UIAlertController(title:alertTitle, message:"", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action)->Void in
                self.printSchedule()
                return
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
                self.performSegue(withIdentifier: "unwindToFirstPageSegue", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        self.registerParticipant()
        self.updateActivityParticipants()
        if currentBlock != 9 {
            currentBlock = currentBlock + 1
            currentBlock = self.verifyBlock(theBlock: currentBlock)
            self.collectionView.reloadData()
        }
    }
    
    func printSchedule() {
        print("Printing the schedule")
        let dateString = CalendarDays.stringFromDate(currentWeek.dateStamp)
        let reportTitle = "Schedule for Week of " + dateString
        let reportName = "Schedule"
        ReportGenerator.setupPDFDocumentNamed(name: reportName)
        let pageSize = CGSize(width: pdfPageWidth, height: pdfPageHeight)
        ReportGenerator.beginPDFPage()
        let titleTextRect = ReportGenerator.addText(text: reportTitle, frame: CGRect(x: pdfPadding, y: pdfPadding, width: (pageSize.width) - 2 * pdfPadding, height: pdfTitleBoxHeight), fontSize: pdfTitleFont)
        var verticalDistance = pdfPadding + titleTextRect.size.height + pdfPadding
        let blueLineRect = ReportGenerator.addLineWithFrame(frame: CGRect(x: pdfPadding, y: verticalDistance + pdfPadding, width: (pageSize.width) - 2 * pdfPadding, height: pdfLineBoxHeight), color: pdfLineColor)
        verticalDistance = verticalDistance + blueLineRect.size.height + pdfPadding
        for block in currentWeek.scheduleArray {
            let headingRect = ReportGenerator.addText(text: block.scheduleTime, frame: CGRect(x: pdfPadding, y: verticalDistance, width: (pageSize.width) - 2 * pdfPadding, height: pdfHeadingBoxHeight), fontSize: pdfHeadingFont)
            verticalDistance = verticalDistance + headingRect.size.height + pdfPadding
            for activity in block.activityArray {
                for person in activity.participants {
                    if (participant.name == person) {
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
                self.performSegue(withIdentifier: "unwindToFirstPageSegue", sender: self)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return doubleArray[currentBlock].count
        } 
        return doubleArray[currentBlock].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActivityCell
        cell.backgroundColor = ColorScheme.cellColor
        cell.label.font = cellFont
        cell.label.textColor = ColorScheme.cellFontColor
        let cellActivityItem = activityItemForIndexPath(indexPath)
        if cellActivityItem.activityLimit == cellActivityItem.participants.count {
            cell.label.text! = "ACTIVITY FULL"
        } else {
            cell.label.text! = cellActivityItem.activityName
        }
        if cellActivityItem.chosen {
            cell.isSelected = true
            cell.checkView.image = UIImage(named: "check.png")
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        } else {
            cell.checkView.image = UIImage(named: "blank.png")
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        // 1
        switch kind {
        // 2
        case UICollectionView.elementKindSectionHeader:
            // 3
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "SignUpHeaderView",
                    for: indexPath) as? SignUpHeaderCollectionReusableView
                else {
                    fatalError("Invalid view type")
            }
            if (indexPath.section == 0) {
                headerView.backgroundColor = ColorScheme.headerViewBackgroundColor
                headerView.signUpHeaderLabel.text = weekTimes[currentBlock]
                headerView.signUpHeaderLabel.textColor = ColorScheme.headerTextColor
            }
            return headerView
        default:
            // 4
            assert(false, "Invalid element type")
        }
    }
    // MARK: UICollectionViewDelegateFlowLayout
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = collectionView.bounds.size
        size.height = size.height / 4
        size.width = size.width / 2
        size.height -= topLayoutGuide.length
        //size.height -= view.safeAreaLayoutGuide.topAnchor
        //size.height -= view.safeAreaLayoutGuide.topAnchor
        size.height -= (sectionInsets.top + sectionInsets.right)
        size.width -= (sectionInsets.left + sectionInsets.right)
        
        return size
        // }
    }
    
    // specify spacings for margins
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    // MARK: UICollectionViewDelegate
    // MARK: UICollectionViewDelegate
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ActivityCell else {
            return
        }
        cell.checkView.image = UIImage(named:"check.png")
       
        let selectedArray = activityArrayForIndexPath(indexPath)
        let chosenActivity = activityItemForIndexPath(indexPath)
        for item in selectedArray {
            if item.activityName == chosenActivity.activityName {
                item.chosen = true
                print("\(item.activityName) selected")
            } else {
                item.chosen = false  // so only the currently selected activity is true
                print("\(item.activityName) NOT selected")
            }
        }
        let selectedIndexPaths = self.collectionView.indexPathsForSelectedItems!
        for path in selectedIndexPaths {
            
            if((path.section == indexPath.section) && (path.row != indexPath.row)) {
                guard let cell = collectionView.cellForItem(at: path) as? ActivityCell else {
                    return
                }
                cell.checkView.image = UIImage(named:"blank.png")
                self.collectionView.deselectItem(at: path, animated: false)
            } 
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ActivityCell else {
            return
        }
        cell.checkView.image = UIImage(named:"")
        let selectedArray = activityArrayForIndexPath(indexPath)
        let chosenActivity = activityItemForIndexPath(indexPath)
        for item in selectedArray {
            if item.activityName == chosenActivity.activityName {
                item.chosen = false
                print("\(item.activityName) has been deselected")
            }
        }
        
        
    }
    /* Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }*/
   

    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cellActivityItem = activityItemForIndexPath(indexPath)
        if cellActivityItem.activityLimit == cellActivityItem.participants.count {
            return false
        }
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
