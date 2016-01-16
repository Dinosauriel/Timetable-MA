//
//  TodayViewController.swift
//  nextlesson
//
//  Created by Aurel Feer on 13.01.16.
//  Copyright © 2016 Aurel Feer. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let timetitleCellIdentifier = "TimetitleCellIdentifier"
    let timeCellIdentifier = "TimeCellIdentifier"
    let lessonCellIdentifier = "LessonCellIdentifier"
    let replacedlessonCellIdentifier = "ReplacedLessonCellIdentifier"
    let specialLessonCellIdentifier = "specialLessonCellIdentifier"
    
    let numberOfLessonsInDay = 12
    
    let userDefaults = NSUserDefaults(suiteName: "group.lee.labf.timetable")
    
    let timegetter = TimetableTime()
    let layout = TodayLayout()
    let day = Day()
    let dataReciever = DataReciever()
    let not = NSNotificationCenter.defaultCenter()
    
    let specialLessonBackgroundColor = UIColor(hue: 0.4778, saturation: 0.73, brightness: 0.46, alpha: 1.0) //#18776c, DARKGREEN
    let specialDividingLineColor = UIColor(hue: 0.4833, saturation: 0.79, brightness: 0.7, alpha: 1.0) // #25b2a4, GDARGREEN-BLUE
    let replacedTextColor = UIColor(hue: 206/360, saturation: 94/100, brightness: 98/100, alpha: 1.0) /* #0d94fc, Blue */

    let numberOfSections = 3
    let numberOfColumns = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        not.addObserver(self, selector: "displayNewData", name: "DataSuccessfullyRetrieved", object: nil)
        not.addObserver(self, selector: "displayErrorNotification", name: "CouldntRetrieveData", object: nil)
        
        refreshCurrentTime()
        super.viewDidLoad()
        
        print("Today Loaded")
        print("token in userDefaults: \(userDefaults!.stringForKey("token"))")
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.preferredContentSize = CGSizeMake(0, 210)
    }
    
    //MARK: NOTIFICATION FUNCTIONS
    func displayNewData() {
        print("new Data recieved")
    }
    
    func displayErrorNotification() {
        print("There was an Error Recieving the Data.. please relog in the App")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        dataReciever.getEntireTable()
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        print("Widget Update Request")
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    func refreshCurrentTime() {
        let currentLessonCoords: [Int] = timegetter.getCurrentLessonCoordinates()
        userDefaults?.setInteger(currentLessonCoords[1], forKey: "currentLessonSinceLastWidgetRequest")
    }
    
    func shouldUpdateTimetable() -> Bool {
        let currentLessonCoords = timegetter.getCurrentLessonCoordinates()[1]
        let oldLessonCoords = userDefaults?.integerForKey("currentLessonSinceLastWidgetRequest")
        
        return currentLessonCoords != oldLessonCoords
    }
    
    // MARK - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfColumns
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let timeCell: TimeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(timeCellIdentifier, forIndexPath: indexPath) as! TimeCollectionViewCell
            
            let currentLesson: Int = timegetter.getCurrentLessonCoordinates()[1]
            print("currentLesson \(currentLesson)")

            timeCell.starttimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section + currentLesson, when: .Start, withSeconds: false)
            timeCell.endtimeLabel.text = timegetter.getLessonTimeAsString((indexPath.section + currentLesson), when: .End, withSeconds:  false)
            
            if indexPath.section != (numberOfSections - 1) {
                timeCell.dividingView.backgroundColor = UIColor.whiteColor()
            } else {
                timeCell.dividingView.backgroundColor = UIColor.clearColor()
            }
            
            return timeCell
        } else {
            
            let celltoreturn: UICollectionViewCell
            
            let alesson = UILesson(subject: "Ro", teacher: "Bo", room: "Craft", status: .Special, subsubject: "", subteacher: "", subroom: "")
            
            switch alesson.status {
            case .Default:
                let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                // Declaring subjectLabel appearance
                lessonCell.subjectLabel.text = alesson.subject
                // Declaring teacherLabel appearance
                lessonCell.teacherLabel.text = alesson.teacher
                // Declaring roomLabel appearance
                lessonCell.roomLabel.text = alesson.room
                
                if indexPath.section != (numberOfSections - 1) {
                    lessonCell.dividingView.backgroundColor = UIColor.whiteColor()
                } else {
                    lessonCell.dividingView.backgroundColor = UIColor.clearColor()
                }
                
                celltoreturn = lessonCell
                
            case .Cancelled:
                let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                // Declaring subjectLabel appearance
                lessonCell.subjectLabel.textColor = UIColor.redColor()
                lessonCell.subjectLabel.text = alesson.subject
                // Declaring teacherLabel appearance
                lessonCell.teacherLabel.textColor = UIColor.redColor()
                lessonCell.teacherLabel.text = alesson.teacher
                // Declaring roomLabel appearance
                lessonCell.roomLabel.textColor = UIColor.redColor()
                lessonCell.roomLabel.text = alesson.room
                //Crossing out Lesson
                lessonCell.crossOutView.backgroundColor = UIColor.redColor()
                
                if indexPath.section != (numberOfSections - 1) {
                    lessonCell.dividingView.backgroundColor = UIColor.whiteColor()
                } else {
                    lessonCell.dividingView.backgroundColor = UIColor.clearColor()
                }
                
                celltoreturn = lessonCell
                
            case .Replaced:
                let replacedlessonCell: ReplacedLessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(replacedlessonCellIdentifier, forIndexPath: indexPath) as! ReplacedLessonCollectionViewCell
                // Declaring subjectLabel appearance
                replacedlessonCell.subjectLabel.textColor = replacedTextColor
                replacedlessonCell.subjectLabel.text = alesson.subject
                // Declaring teacherLabel appearance
                replacedlessonCell.teacherLabel.textColor = replacedTextColor
                replacedlessonCell.teacherLabel.text = alesson.teacher
                // Declaring roomLabel appearance
                replacedlessonCell.roomLabel.textColor = replacedTextColor
                replacedlessonCell.roomLabel.text = alesson.room
                // Declaring subsubjectLabel appearance
                replacedlessonCell.subsubjectLabel.textColor = replacedTextColor
                replacedlessonCell.subsubjectLabel.text = alesson.subsubject
                // Declaring subteacherLabel appearance
                replacedlessonCell.subteacherLabel.textColor = replacedTextColor
                replacedlessonCell.subteacherLabel.text = alesson.subteacher
                // Declaring subroomLabel appearance
                replacedlessonCell.subroomLabel.textColor = replacedTextColor
                replacedlessonCell.subroomLabel.text = alesson.subroom
                
                if indexPath.section != (numberOfSections - 1) {
                    replacedlessonCell.dividingView.backgroundColor = UIColor.whiteColor()
                } else {
                    replacedlessonCell.dividingView.backgroundColor = UIColor.clearColor()
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
                } else {
                    lessonCell.dividingView.backgroundColor = UIColor.clearColor()
                }
                
                celltoreturn = lessonCell
                
            case .Special:
                //Get special Lesson
                let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(specialLessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                //Declare label content
                lessonCell.subjectLabel.text = alesson.subject
                lessonCell.teacherLabel.text = alesson.teacher
                lessonCell.roomLabel.text = alesson.room
                //Declare label appearance
                lessonCell.subjectLabel.textColor = UIColor.whiteColor()
                lessonCell.teacherLabel.textColor = UIColor.whiteColor()
                lessonCell.roomLabel.textColor = UIColor.whiteColor()
                //Declare cell appearance
                lessonCell.backgroundColor = specialLessonBackgroundColor
                lessonCell.dividingView.backgroundColor = specialDividingLineColor
                
                if indexPath.section != (numberOfSections - 1) {
                    lessonCell.dividingView.backgroundColor = UIColor.whiteColor()
                } else {
                    lessonCell.dividingView.backgroundColor = UIColor.clearColor()
                }
                
                celltoreturn = lessonCell
                
            case .MovedTo:
                //Get moved lesson
                let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                //Declare label content
                lessonCell.teacherLabel.text = alesson.teacher
                lessonCell.subjectLabel.text = alesson.subject
                lessonCell.roomLabel.text = alesson.room
                //Declare label appearance
                lessonCell.teacherLabel.textColor = replacedTextColor
                lessonCell.subjectLabel.textColor = replacedTextColor
                lessonCell.roomLabel.textColor = replacedTextColor
                
                if indexPath.section != (numberOfSections - 1) {
                    lessonCell.dividingView.backgroundColor = UIColor.whiteColor()
                } else {
                    lessonCell.dividingView.backgroundColor = UIColor.clearColor()
                }
                
                celltoreturn = lessonCell
            }

            return celltoreturn
        }
    }
}