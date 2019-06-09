//
//  AppDelegate.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//  May 13 - initial commit
// May 14 - working on making activities and scheduleBlocks
// working on archiving schedules - basic mechanism works, but need more testing
// can make and retrieve schedules - only blocks with activities are created
// working on SignUp page - can display and select cells - need to generalize logic
// will display one day at a time (2 sections)  need Next and Back butons in header view
// Next and back buttons work for SignUp - but do we want Back button?? would have to de-register users
// admin will have ten sections that scroll
// also need to register users - done for fake user SK
// can now add participants - and see weekly schedule
// admin can add or remove participant in activity - results saved
// show activities as full as needed and make them unselectable
// both selected cells show as highlighted
// added green checkmarks
// added CalendarDays and view only Mondays
// changed Back button to Done for SignUp page and made unwind segue
//  working on conversion to Week based app - need to retrieve specific week and also do sign up stuff
// can retrieve desired week and sign up - admin can edit user list and results are saved
//  NEXT - futz with week displayed for user - 

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

