//
//  Constants.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/14/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import Foundation
import UIKit

let kMondayAM = "Monday AM"
let kMondayPM = "Monday PM"
let kTuesdayAM = "Tuesday AM"
let kTuesdayPM = "Tuesday PM"
let kWednesdayAM = "Wednesday AM"
let kWednesdayPM = "Wednesday PM"
let kThursdayAM = "Thursday AM"
let kThursdayPM = "Thursday PM"
let kFridayAM = "Friday AM"
let kFridayPM = "Friday PM"
let weekTimes = [kMondayAM, kMondayPM, kTuesdayAM, kTuesdayPM, kWednesdayAM, kWednesdayPM, kThursdayAM, kThursdayPM, kFridayAM, kFridayPM]
let reorderedTimes = [kMondayAM, kTuesdayAM, kWednesdayAM, kThursdayAM, kFridayAM, kMondayPM, kTuesdayPM, kWednesdayPM, kThursdayPM, kFridayPM ]
let pdfPageWidth = CGFloat(850)
let pdfPageHeight = CGFloat(1100)
let pdfTitleBoxHeight = CGFloat(200)
let pdfHeadingBoxHeight = CGFloat(50)
let pdfTextLineBoxHeight = CGFloat(50)
let pdfLineBoxHeight = CGFloat(4)
let pdfLineColor = UIColor.blue
let pdfActivityFont = CGFloat(24.0)
let pdfTitleFont = CGFloat(48.0)
let pdfPadding = CGFloat(30.0)
let pdfHeadingFont = CGFloat(36.0)
let pdfBottomMargin = CGFloat(100)
let pdfTopMargin = CGFloat(100)
let pdfPageSize = CGSize(width: pdfPageWidth, height: pdfPageHeight)
let pdfMargin = Double(100.0)
let pdfFont = UIFont.systemFont(ofSize: 24.0)

public struct ColorScheme {
    
    static let buttonColor = UIColor(red:0.38, green:0.65, blue:0.77, alpha:1.0) // for buttons on question pages
    static let labelBackgroundColor = UIColor(red:0.38, green:0.65, blue:0.77, alpha:0.2)
    static let buttonSelectedColor = UIColor(red:0.00, green:0.27, blue:0.35, alpha:1.0)
    static let buttonViewFrameColor = UIColor.clear // on question pages
    static let standardTextColor = UIColor(red:0.00, green:0.27, blue:0.35, alpha:1.0)
    static let standardButtonTextColor = UIColor.white
    static let pageNavButtonColor = UIColor(red:0.38, green:0.65, blue:0.77, alpha:1.0)
    static let validDataColor = UIColor(red:0.2, green:0.76, blue:0.35, alpha:1.0)
    //static let pageBackgroundColor = UIColor(red:0.00, green:0.60, blue:0.70, alpha:1.0)
    static let pageBackgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
    static let lightTextColor = UIColor(red:0.38, green:0.65, blue:0.77, alpha:1.0)
    static let ourGrayColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
    static let ourDarkGrayColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0)
}

public struct Fonts {
    static let PrimaryFontName: String = "HelveticaNeue"
    static let PrimaryFontNameLight: String = "HelveticaNeue-Light"
    static let buttonFont:UIFont = UIFont(name:"HelveticaNeue", size: 30)!
}
