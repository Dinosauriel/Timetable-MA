//
//  LessonCollectionViewCell.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 05.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class LessonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var crossOutView: UIView!
    @IBOutlet weak var dividingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = UIColor.whiteColor()
        
        self.crossOutView.backgroundColor = UIColor.clearColor()
        
        if self.subjectLabel.textColor != UIColor.blackColor() {
            
            self.subjectLabel.textColor = UIColor.blackColor()
            self.teacherLabel.textColor = UIColor.blackColor()
            self.roomLabel.textColor = UIColor.blackColor()
        }
    }
}
