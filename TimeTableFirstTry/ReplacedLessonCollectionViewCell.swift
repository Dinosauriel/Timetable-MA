//
//  ReplacedLessonCollectionViewCell.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 06.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var vertDividingView: UIView!
}
