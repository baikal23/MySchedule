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

    fileprivate var itemsToDisplay = [ActivityItem]()
    let reuseIdentifier = "ActivityCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print("In viewDidLoad for SignUp View")
         self.getItemsToDisplay()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.register(ActivityCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       
        // Do any additional setup after loading the view.
    }
    // convenience function to get activityItem from array
    func activityItemForIndexPath(_ indexPath: IndexPath) -> ActivityItem {
        return itemsToDisplay[indexPath.row]
    }
    
    func getItemsToDisplay() {
        let theSchedules = ScheduleBlock.getSchedules()
        if theSchedules.count > 0 {
            print("We have schedules")
            for item in theSchedules {
                if item.scheduleTime == kMondayAM {
                    itemsToDisplay = item.activityArray
                }
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemsToDisplay.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActivityCell
        cell.backgroundColor = UIColor.gray
        
        let cellActivityItem = activityItemForIndexPath(indexPath)
        cell.label.text! = cellActivityItem.activityName
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    // MARK: UICollectionViewDelegate
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        print("Item selected")
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
