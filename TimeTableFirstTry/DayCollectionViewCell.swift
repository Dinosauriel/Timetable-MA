//
//  DateCollectionViewCell.swift
//  CustomCollectionLayout
//
//  Created by Aurel Feer on 25/10/2015.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

/**
Cell that the labels to display the day
*/
class DayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dividingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dayLabel.font = UIFont.systemFontOfSize(13)
    }
    
}
