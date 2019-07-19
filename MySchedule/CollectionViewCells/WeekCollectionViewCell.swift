//
//  WeekCollectionViewCell.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/28/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class WeekCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityParticipantLabel: UILabel!
    
     var baseColor:UIColor = ColorScheme.cellColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.selected = false
    }
    
    override var isSelected : Bool {
        didSet {
            self.backgroundColor = isSelected ? UIColor.yellow : baseColor
        }
    }
}
