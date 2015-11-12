//
//  CollectionViewController.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 25/10/2015.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let timetitleCellIdentifier = "TimetitleCellIdentifier"
    let dayCellIdentifier = "DayCellIdentifier"
    let timeCellIdentifier = "TimeCellIdentifier"
    let lessonCellIdentifier = "LessonCellIdentifier"
    let replacedlessonCellIdentifier = "ReplacedLessonCellIdentifier"
    
    let timegetter = TimetableTime()
    let declarelesson = DeclareLesson()
    let layout = CustomCollectionViewLayout()
    let day = Day()
    let widget = WidgetLesson()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView .registerNib(UINib(nibName: "TimetitleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: timetitleCellIdentifier)
        self.collectionView .registerNib(UINib(nibName: "DayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
        self.collectionView .registerNib(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: timeCellIdentifier)
        self.collectionView .registerNib(UINib(nibName: "LessonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: lessonCellIdentifier)
        self.collectionView .registerNib(UINib(nibName: "ReplacedLessonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: replacedlessonCellIdentifier)
        
        print(timegetter.timeAsStringToNSDateComponents("15:55"))
        print(timegetter.timeAsStringToLessonposition("15:55"))
        print(timegetter.timeAsStringToWhen("15:55"))
        
        day.generateDayArray()
        print("getCurrentLessonPos: \(widget.getCurrentLessonPos())")
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    // MARK - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 13
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                    let timetitleCell : TimetitleCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(timetitleCellIdentifier, forIndexPath: indexPath) as! TimetitleCollectionViewCell
                    timetitleCell.backgroundColor = UIColor.whiteColor()
                    timetitleCell.timetitleLabel.font = UIFont.systemFontOfSize(13)
                    timetitleCell.timetitleLabel.textColor = UIColor.blackColor()
                    timetitleCell.timetitleLabel.text = "Zeit"
                
                    return timetitleCell
                
            } else {
                let dayCell : DayCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dayCellIdentifier, forIndexPath: indexPath) as! DayCollectionViewCell
                let dayArray = day.generateDayArray()
                dayCell.dayLabel.font = UIFont.systemFontOfSize(13)
                dayCell.dayLabel.textColor = UIColor.blackColor()
                dayCell.dayLabel.text = dayArray[indexPath.row - 1] as? String
                
                if indexPath.section % 2 != 0 {
                    dayCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    dayCell.backgroundColor = UIColor.whiteColor()
                }
                
                return dayCell
                
            }
        } else {
            if indexPath.row == 0 {
                let timeCell: TimeCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(timeCellIdentifier, forIndexPath: indexPath) as! TimeCollectionViewCell
                timeCell.starttimeLabel.font = UIFont.systemFontOfSize(13)
                timeCell.endtimeLabel.font = UIFont.systemFontOfSize(13)
                timeCell.starttimeLabel.textColor = UIColor.blackColor()
                timeCell.endtimeLabel.textColor = UIColor.blackColor()
                timeCell.starttimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section, when: "start")
                timeCell.endtimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section, when: "end")
                if indexPath.section % 2 != 0 {
                    timeCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    timeCell.backgroundColor = UIColor.whiteColor()
                }
                
                return timeCell
            } else {
                
                let celltoreturn: UICollectionViewCell
                
                let alesson = declarelesson.getNewLessonForUI(indexPath.row, pos: indexPath.section)
                
                let yellow = UIColor(hue: 0.125, saturation: 1, brightness: 0.97, alpha: 1.0)
                switch alesson.status {
                    case .Default:
                        let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        lessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.subjectLabel.textColor = UIColor.blackColor()
                        lessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        lessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.teacherLabel.textColor = UIColor.blackColor()
                        lessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        lessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.roomLabel.textColor = UIColor.blackColor()
                        lessonCell.roomLabel.text = alesson.room
                    
                        celltoreturn = lessonCell
                    
                    case .Cancelled:
                        let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        lessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.subjectLabel.textColor = UIColor.redColor()
                        lessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        lessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.teacherLabel.textColor = UIColor.redColor()
                        lessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        lessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.roomLabel.textColor = UIColor.redColor()
                        lessonCell.roomLabel.text = alesson.room
                        //Crossing out Lesson
                        lessonCell.crossOutView.backgroundColor = UIColor.redColor()
                    
                        celltoreturn = lessonCell
                    
                    case .Replaced:
                        let replacedlessonCell: ReplacedLessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(replacedlessonCellIdentifier, forIndexPath: indexPath) as! ReplacedLessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        replacedlessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subjectLabel.textColor = UIColor.blueColor()
                        replacedlessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        replacedlessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.teacherLabel.textColor = UIColor.blueColor()
                        replacedlessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        replacedlessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.roomLabel.textColor = UIColor.blueColor()
                        replacedlessonCell.roomLabel.text = alesson.room
                        // Declaring subsubjectLabel appearance
                        replacedlessonCell.subsubjectLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subsubjectLabel.textColor = UIColor.blueColor()
                        replacedlessonCell.subsubjectLabel.text = alesson.subsubject
                        // Declaring subteacherLabel appearance
                        replacedlessonCell.subteacherLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subteacherLabel.textColor = UIColor.blueColor()
                        replacedlessonCell.subteacherLabel.text = alesson.subteacher
                        // Declaring subroomLabel appearance
                        replacedlessonCell.subroomLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subroomLabel.textColor = UIColor.blueColor()
                        replacedlessonCell.subroomLabel.text = alesson.subroom
                    
                        celltoreturn = replacedlessonCell
                    
                    case .Empty:
                        let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring empty Lesson
                        lessonCell.subjectLabel.text = ""
                        lessonCell.teacherLabel.text = ""
                        lessonCell.roomLabel.text = ""
                        
                        celltoreturn = lessonCell
                    
                    case .Special:
                        let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        let previousSection = (indexPath.section - 1)
                        print("previousSection\(previousSection)")
                        let previousIndexPath = NSIndexPath(forRow: indexPath.row, inSection: previousSection)
                        var previousCell = LessonCollectionViewCell()
                        if previousSection > 1 {
                            previousCell = collectionView.cellForItemAtIndexPath(previousIndexPath) as! LessonCollectionViewCell
                        }
                        lessonCell.teacherLabel.text = ""
                        lessonCell.roomLabel.text = ""
                        lessonCell.subjectLabel.textColor = UIColor.whiteColor()
                        lessonCell.backgroundColor = yellow
                        if previousCell.backgroundColor == yellow && previousCell.subjectLabel.text == alesson.subject {
                            lessonCell.subjectLabel.text = ""
                        } else {
                            lessonCell.subjectLabel.text = alesson.subject
                        }
                        celltoreturn = lessonCell
                }
                
                if celltoreturn.backgroundColor != yellow {
                    if indexPath.section % 2 != 0{
                        celltoreturn.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                    } else {
                        celltoreturn.backgroundColor = UIColor.whiteColor()
                    }
                }
                return celltoreturn
            }
        }
    }
}

