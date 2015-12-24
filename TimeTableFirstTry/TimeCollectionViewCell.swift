//
//  TimeCollectionViewCell.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 04.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

/**
Cell that the labels to display the time
*/
class TimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var starttimeLabel: UILabel!
    @IBOutlet weak var endtimeLabel: UILabel!
    
    @IBOutlet weak var dividingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
