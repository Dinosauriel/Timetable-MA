//
//  ReplacedLessonCollectionViewCell.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 06.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import UIKit

/**
Cell that contains the labels to display a replaced lesson
*/
class ReplacedLessonCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var subsubjectLabel: UILabel!
    @IBOutlet weak var subteacherLabel: UILabel!
    @IBOutlet weak var subroomLabel: UILabel!
    
    @IBOutlet weak var dividingView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
