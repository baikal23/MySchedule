//
//  ScheduleBlockCell.swift
//  MySchedule
//
//  Created by Susan Kohler on 6/10/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class ScheduleBlockCell: UICollectionViewCell {

    var baseColor:UIColor = UIColor.gray
    
    @IBOutlet weak var label: UILabel!
    
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
