//
//  TodayViewController.swift
//  WidgetLesson
//
//  Created by Aurel Feer on 13.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDataSource, UICollectionViewDelegate {
    let timetitleCellIdentifier = "TimetitleCellIdentifier"
    let dayCellIdentifier = "DayCellIdentifier"
    let timeCellIdentifier = "TimeCellIdentifier"
    let lessonCellIdentifier = "LessonCellIdentifier"
    let replacedlessonCellIdentifier = "ReplacedLessonCellIdentifier"
    
    let timegetter = TimetableTime()
    let declarelesson = DeclareLesson()
    let layout = TodayLayout()
    let day = Day()
    
    let numberOfSections = 3
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Today Loaded")
        
        self.collectionView .registerNib(UINib(nibName: "TimetitleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: timetitleCellIdentifier)
        self.collectionView .registerNib(UINib(nibName: "DayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
        self.collectionView .registerNib(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: timeCellIdentifier)
        self.collectionView .registerNib(UINib(nibName: "LessonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: lessonCellIdentifier)
        self.collectionView .registerNib(UINib(nibName: "ReplacedLessonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: replacedlessonCellIdentifier)
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.preferredContentSize = CGSizeMake(0, 230)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    // MARK - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let timeCell: TimeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(timeCellIdentifier, forIndexPath: indexPath) as! TimeCollectionViewCell
            timeCell.starttimeLabel.font = UIFont.systemFontOfSize(13)
            timeCell.endtimeLabel.font = UIFont.systemFontOfSize(13)
            
            timeCell.starttimeLabel.textColor = UIColor.whiteColor()
            timeCell.endtimeLabel.textColor = UIColor.whiteColor()
            
            timeCell.starttimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section - 1 + getCurrentLessonPos(), when: "start")
            timeCell.endtimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section - 1 + getCurrentLessonPos(), when: "end")
            
            if indexPath.section != (numberOfSections - 1) {
                timeCell.dividingView.backgroundColor = UIColor.whiteColor()
            }
            
            /*if indexPath.section % 2 != 0 {
                timeCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
            } else {
                timeCell.backgroundColor = UIColor.whiteColor()
            }*/
            
            return timeCell
        } else {
            
            let celltoreturn: UICollectionViewCell
            
            let alesson = declarelesson.getNewLessonForUI(indexPath.row, pos: indexPath.section + getCurrentLessonPos())
            
            let yellow = UIColor(hue: 0.125, saturation: 1, brightness: 0.97, alpha: 1.0)
            switch alesson.status {
            case .Default:
                let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                // Declaring subjectLabel appearance
                lessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                lessonCell.subjectLabel.textColor = UIColor.whiteColor()
                lessonCell.subjectLabel.text = alesson.subject
                // Declaring teacherLabel appearance
                lessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                lessonCell.teacherLabel.textColor = UIColor.whiteColor()
                lessonCell.teacherLabel.text = alesson.teacher
                // Declaring roomLabel appearance
                lessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                lessonCell.roomLabel.textColor = UIColor.whiteColor()
                lessonCell.roomLabel.text = alesson.room
                
                if indexPath.section != (numberOfSections - 1) {
                    lessonCell.dividingView.backgroundColor = UIColor.whiteColor()
                }
                
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
                
                if indexPath.section != (numberOfSections - 1) {
                    lessonCell.dividingView.backgroundColor = UIColor.whiteColor()
                }
                
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
                
                if indexPath.section != (numberOfSections - 1) {
                    replacedlessonCell.dividingView.backgroundColor = UIColor.whiteColor()
                }
                
                celltoreturn = replacedlessonCell
                
            case .Empty:
                let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                // Declaring empty Lesson
                lessonCell.subjectLabel.text = ""
                lessonCell.teacherLabel.text = ""
                lessonCell.roomLabel.text = ""
                
                if indexPath.section != (numberOfSections - 1) {
                    lessonCell.dividingView.backgroundColor = UIColor.whiteColor()
                }
                
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
                
                if indexPath.section != (numberOfSections - 1) {
                    lessonCell.dividingView.backgroundColor = UIColor.whiteColor()
                }
                
                celltoreturn = lessonCell
            }
            
            /*if celltoreturn.backgroundColor != yellow {
                if indexPath.section % 2 != 0{
                    celltoreturn.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    celltoreturn.backgroundColor = UIColor.whiteColor()
                }
            }*/
            return celltoreturn
        }
    }
    
    func getCurrentLessonPos() -> Int {
        // Returns the Lessonposition that is currently active
        let currentTime = timegetter.getCurrentHourAndMinute()
        
        if timegetter.compareNSDateComponentsAtoB(currentTime , b: timegetter.getLessonTime(1, when: "end")) == .earlier {
            
            // If the Time earlier to the ending of the first Lesson, the first Lesson is returned
            return 1
        } else if timegetter.compareNSDateComponentsAtoB(currentTime, b: timegetter.getLessonTime(12, when: "end")) == .later || timegetter.compareNSDateComponentsAtoB(currentTime, b: timegetter.getLessonTime(12, when: "end")) == .equal {
            
            // If the Time is later or equal to the end of the last lesson, Lesson 13 is returned -> next Day should be shown
            return 13
        } else {
            return checkIfEarlier()
        }
    }
    
    func checkIfEarlier() -> Int {
        // Returns LessonPosition of any time in the Timetable
        let currentTime = timegetter.getCurrentHourAndMinute()
        var pos = 1
        
        for (var i = 1; i <= 12; i++) {
            if (timegetter.compareNSDateComponentsAtoB(currentTime, b: timegetter.getLessonTime(i - 1, when: "end")) == .later || timegetter.compareNSDateComponentsAtoB(currentTime, b: timegetter.getLessonTime(i - 1, when: "end")) == .equal) && timegetter.compareNSDateComponentsAtoB(currentTime, b: timegetter.getLessonTime(i, when: "end")) == .earlier {
                pos = i
            } else {
                continue
            }
        }
        return pos
    }
}
