//
//  TimeCollectionViewCell.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 04.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var starttimeLabel: UILabel!
    @IBOutlet weak var endtimeLabel: UILabel!
    
    @IBOutlet weak var dividingView: UIView!
    @IBOutlet weak var vertDividingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
