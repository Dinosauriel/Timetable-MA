//
//  LessonCollectionViewCell.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 05.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import UIKit

/**
Cell that contains the labels to display a normal lesson
*/
class LessonCollectionViewCell: UICollectionViewCell {
    let dividingLineColor = UIColor(hue: 0.8639, saturation: 0, brightness: 0.83, alpha: 1.0) //GRAY
    
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
        
        self.dividingView.backgroundColor = dividingLineColor
    }
}