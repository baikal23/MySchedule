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
    var currentDay = 0
    var doubleArray = [[ActivityItem]]()
    let reuseIdentifier = "ActivityCell"
    var participant:String = "SK"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print("In viewDidLoad for SignUp View")
         self.getItemsToDisplay()
        // Do any additional setup after loading the view.
    }
    // convenience function to get activityItem from array
    func activityItemForIndexPath(_ indexPath: IndexPath) -> ActivityItem {
        var returnItem:ActivityItem!
        if indexPath.section == 0 {
            returnItem = doubleArray[currentDay * 2][indexPath.row]
        } else if indexPath.section == 1 {
            returnItem = doubleArray[currentDay * 2 + 1][indexPath.row]
        }
        return returnItem
    }
    
    func activityArrayForIndexPath(_ indexPath: IndexPath) -> [ActivityItem] {
        var returnArray:[ActivityItem] = []
        if indexPath.section == 0 {
            returnArray = doubleArray[currentDay * 2]
        } else if indexPath.section == 1 {
            returnArray = doubleArray[currentDay * 2 + 1]
        }
        return returnArray
    }
    func getItemsToDisplay() {
        let theSchedules = ScheduleBlock.getSchedules()
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
    
    func updateActivityParticipants() {
        let theSchedules = ScheduleBlock.getSchedules()
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
        ScheduleBlock.saveSchedules(scheduleArray: theSchedules)
            
        
    }
    func registerParticipant() {
        for item in doubleArray[currentDay * 2] {
            if item.chosen == true {
                item.participants.append(participant)
            }
        }
        for item in doubleArray[currentDay * 2 + 1] {
            if item.chosen == true {
                item.participants.append(participant)
            }
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        if currentDay != 0 {
            currentDay = currentDay - 1
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        self.registerParticipant()
        self.updateActivityParticipants()
        if currentDay != 9 {
            currentDay = currentDay + 1
            self.collectionView.reloadData()
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
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 0 {
            return doubleArray[currentDay * 2].count
        } else {
            return doubleArray[currentDay * 2 + 1].count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActivityCell
        cell.backgroundColor = UIColor.gray
        
        let cellActivityItem = activityItemForIndexPath(indexPath)
        if cellActivityItem.activityLimit == cellActivityItem.participants.count {
            cell.label.text! = "ACTIVITY FULL"
        } else {
            cell.label.text! = cellActivityItem.activityName
        }
        // Configure the cell
    
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
                headerView.signUpHeaderLabel.text = weekTimes[currentDay * 2]
            } else {
                headerView.signUpHeaderLabel.text = weekTimes[currentDay * 2 + 1]
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
        print("Item selected")
        let selectedArray = activityArrayForIndexPath(indexPath)
        let chosenActivity = activityItemForIndexPath(indexPath)
        for item in selectedArray {
            if item.activityName == chosenActivity.activityName {
                item.chosen = true
            } else {
                item.chosen = false  // so only the currently selected activity is true
            }
        }
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
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
