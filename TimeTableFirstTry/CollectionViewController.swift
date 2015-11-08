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
    
    let lessonsubjectycon = "yForSubjectCon"
    let lessonteacherycon = "yForTeacherCon"
    let lessonroomycon = "yForRoomCon"
    
    let timegetter = TimetableTime()
    let declarelesson = DeclareLesson()
    
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
                    dayCell.dayLabel.font = UIFont.systemFontOfSize(13)
                    dayCell.dayLabel.textColor = UIColor.blackColor()
                switch indexPath.row {
                    case 1:
                        dayCell.dayLabel.text = "Montag"
                    case 2:
                        dayCell.dayLabel.text = "Dienstag"
                    case 3:
                        dayCell.dayLabel.text = "Mittwoch"
                    case 4:
                        dayCell.dayLabel.text = "Donnerstag"
                    case 5:
                        dayCell.dayLabel.text = "Freitag"
                    default:
                        dayCell.dayLabel.text = "nil"
                }
                
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
                
                let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                
                let replacedlessonCell: ReplacedLessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(replacedlessonCellIdentifier, forIndexPath: indexPath) as! ReplacedLessonCollectionViewCell
                
                let alesson = declarelesson.getNewLesson(indexPath.row, pos: indexPath.section)
                print(alesson.status)
                switch alesson.status {
                    case .Default:
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
                        //Crossing out View
                        lessonCell.crossOutView.backgroundColor = UIColor.redColor()
                    
                        celltoreturn = lessonCell
                    
                    case .Replaced:
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
                        // Declaring empty Lesson
                        lessonCell.subjectLabel.text = ""
                        lessonCell.teacherLabel.text = ""
                        lessonCell.roomLabel.text = ""
                        
                        celltoreturn = lessonCell
                }
                if indexPath.section % 2 != 0 {
                    celltoreturn.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    celltoreturn.backgroundColor = UIColor.whiteColor()
                }
                
                return celltoreturn
            }
        }
    }
}

