//
//  ActivityCell.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/18/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var checkView: UIImageView!
    var baseColor:UIColor = UIColor.gray
    
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

