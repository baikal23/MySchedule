//
//  WeekCollectionViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/28/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class WeekCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    @IBOutlet weak var weekHeaderView: WeekCollectionReusableView!
    var weeklySchedule:[ScheduleBlock] = []
    var doubleArray = [[ActivityItem]]()
    let reuseIdentifier = "WeekCollectionViewCell"
    var selectedArrayIndex:Int = 0
    var chosenActivity:ActivityItem!
    var currentWeek:Week!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       
        self.getItemsToDisplay()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
        self.getItemsToDisplay()
        self.collectionView.reloadData()
    }

    // convenience function to get activityItem from array
    func weeklyItemForIndexPath(_ indexPath: IndexPath) -> ActivityItem {
        return doubleArray[indexPath.section][indexPath.row]
    }
    // convenience function to get activityArray
    func weeklyActivityArrayForIndexPath(_ indexPath: IndexPath) -> [ActivityItem] {
        return doubleArray[indexPath.section]
    }
    
    func getItemsToDisplay() {
        self.doubleArray = []
        let theSchedules = self.currentWeek.scheduleArray
        if theSchedules.count > 0 {
            print("We have schedules")
            for item in theSchedules {
                for activity in item.activityArray {
                    activity.chosen = false  // no activities chosen yet by current user
                }
                doubleArray.append(item.activityArray)
            }
        }
        
    }

    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer) {
        if (sender.state == .ended) {
            print("Item selected to delete")
            let p:CGPoint = sender.location(in: collectionView)
            let indexPath = collectionView?.indexPathForItem(at: p)
            if (indexPath != nil) {
                selectedArrayIndex = indexPath!.section
                chosenActivity = weeklyItemForIndexPath(indexPath!)
                Week.removeActivityInScheduleBlockforWeek(block:selectedArrayIndex, activityToRemove:chosenActivity, currentWeek:currentWeek)
            }
            self.getItemsToDisplay()
            self.collectionView.reloadData()
        }
    }
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationVC = segue.destination as! EditActivityViewController
        destinationVC.selectedArrayIndex = self.selectedArrayIndex
        destinationVC.chosenActivity = self.chosenActivity
        destinationVC.currentWeek = self.currentWeek
     // Pass the selected object to the new view controller.
     }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return doubleArray[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WeekCollectionViewCell
        cell.backgroundColor = ColorScheme.cellColor
        
        let cellActivityItem = weeklyItemForIndexPath(indexPath)
        cell.activityNameLabel.text! = cellActivityItem.activityName
        cell.activityParticipantLabel.text! = cellActivityItem.participants.joined(separator: ", ")
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.handleSwipe(_:)))
        leftSwipeRecognizer.direction = .left
        leftSwipeRecognizer.delegate = self
        cell.addGestureRecognizer(leftSwipeRecognizer)
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
                    withReuseIdentifier: "WeekHeaderView",
                    for: indexPath) as? WeekCollectionReusableView
                else {
                    fatalError("Invalid view type")
            }
            
            headerView.weekHeaderLabel.text = weekTimes[indexPath.section]
            
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
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        print("Item selected in weekly schedule")
        selectedArrayIndex = indexPath.section
        chosenActivity = weeklyItemForIndexPath(indexPath)

        performSegue(withIdentifier: "editActivitySegue", sender: self)
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

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
