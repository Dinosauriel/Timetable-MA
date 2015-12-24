//
//  TimeCollectionViewCell.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 04.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
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
