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
                let lessonCell : LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
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
                    
                    case .Replaced:
                        let newSubConstraint: NSLayoutConstraint = NSLayoutConstraint(item: lessonCell.subjectLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: lessonCell, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -15)
                        let newTeConstraint: NSLayoutConstraint = NSLayoutConstraint(item: lessonCell.teacherLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: lessonCell, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -15)
                        let newRoomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: lessonCell.roomLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: lessonCell, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -15)
                        // Declaring subjectLabel appearance
                        lessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.subjectLabel.textColor = UIColor.blueColor()
                        lessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        lessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.teacherLabel.textColor = UIColor.blueColor()
                        lessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        lessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.roomLabel.textColor = UIColor.blueColor()
                        lessonCell.roomLabel.text = alesson.room
                        // Moving the existing Labels up
                        lessonCell.addConstraint(newSubConstraint)
                        lessonCell.addConstraint(newTeConstraint)
                        lessonCell.addConstraint(newRoomConstraint)
                    
                    case .Empty:
                        // Declaring empty Lesson
                        lessonCell.subjectLabel.text = ""
                        lessonCell.teacherLabel.text = ""
                        lessonCell.roomLabel.text = ""
                }
                if indexPath.section % 2 != 0 {
                    lessonCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    lessonCell.backgroundColor = UIColor.whiteColor()
                }
                
                return lessonCell
            }
        }
    }
}

