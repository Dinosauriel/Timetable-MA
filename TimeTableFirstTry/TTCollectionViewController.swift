//
//  CollectionViewController.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 25/10/2015.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class TTCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //IDENTIFIERS
    let timetitleCellIdentifier = "TimetitleCellIdentifier"
    let dayCellIdentifier = "DayCellIdentifier"
    let timeCellIdentifier = "TimeCellIdentifier"
    let lessonCellIdentifier = "LessonCellIdentifier"
    let replacedlessonCellIdentifier = "ReplacedLessonCellIdentifier"
    
    //CLASSES
    let timegetter = TimetableTime()
    let declarelesson = DeclareLesson()
    let layout = TTCollectionViewLayout()
    let day = Day()

    //INTEGERS
    let numberOfSections = 13
    let numberOfRows = 6
    
    //CGPoints
    var scrollStartContentOffset: CGPoint!
    
    //COLORS
    let dividingLineColor = UIColor(hue: 0.8639, saturation: 0, brightness: 0.83, alpha: 1.0) //GRAY
    let cellBackgroundColor = UIColor.whiteColor()
    let replacedLessonTextColor = UIColor.blueColor()
    let cancelledLessonTextColor = UIColor.redColor()
    let defaultTextColor = UIColor.blackColor()
    let specialLessonBackgroundColor = UIColor(hue: 0.125, saturation: 1, brightness: 0.97, alpha: 1.0) //YELLOW
    
    //TIMES
    let rotationScrollDelayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
    
    //OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topStatusbarConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // REGISTERING NIBS
        self.collectionView.registerNib(UINib(nibName: "TimetitleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: timetitleCellIdentifier)
        self.collectionView.registerNib(UINib(nibName: "DayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
        self.collectionView.registerNib(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: timeCellIdentifier)
        self.collectionView.registerNib(UINib(nibName: "LessonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: lessonCellIdentifier)
        self.collectionView.registerNib(UINib(nibName: "ReplacedLessonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: replacedlessonCellIdentifier)
    }
    
    //REFRESH BUTTON
    @IBAction func refreshButton(sender: AnyObject) {
        //let api = GetAPIData()
        //api.requestAuthToken()
        print("REFRESH!!")
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVCID")
        self.showViewController(loginVC!, sender: self)
    }

    // MARK: STATUS BAR HANDLING
    func removeStatusBar() {
        topStatusbarConstraint.constant = 0
    }
    
    func addStatusBar() {
        topStatusbarConstraint.constant = 20
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation == UIInterfaceOrientation.Portrait || toInterfaceOrientation == UIInterfaceOrientation.PortraitUpsideDown {
            
            addStatusBar()
            
            dispatch_after(rotationScrollDelayTime, dispatch_get_main_queue()) {
                self.scrollToOptimalSection(self.collectionView)
            }
            
        } else {
            removeStatusBar()
        }
    }
    
    // MARK: PAGING
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollStartContentOffset = collectionView.contentOffset
        scrollStartContentOffset.x += layout.getTimeColumnWidth()
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        print("Scroll Will Begin Decelarating")
        if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
            print("Device is Portrait")
            scrollToOptimalSection(scrollView)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            print("Immediate stop!")
            if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
                print("Device is Portrait")
                scrollToOptimalSection(scrollView)
            }
        }
    }
    
    func scrollToOptimalSection(scrollView: UIScrollView) {
        print("ScrollingFuncExecuted")
        if scrollView == self.collectionView {
            print("scrollView == collectionView")
            let targetScrollingPos = UICollectionViewScrollPosition.Right
            var currentCellOffset: CGPoint = self.collectionView.contentOffset
            currentCellOffset.x += layout.getTimeColumnWidth()
            
            let rightTargetFactor: CGFloat = 0.75
            let leftTargetFactor: CGFloat = 1 - rightTargetFactor
            if currentCellOffset.x > scrollStartContentOffset.x {
                currentCellOffset.x += ((self.collectionView.frame.size.width - layout.getTimeColumnWidth()) * rightTargetFactor)
            } else {
                currentCellOffset.x += ((self.collectionView.frame.size.width - layout.getTimeColumnWidth()) * leftTargetFactor)
            }
            
            let targetCellIndexPath = collectionView.indexPathForItemAtPoint(currentCellOffset)
            if targetCellIndexPath != nil {
                collectionView.scrollToItemAtIndexPath(targetCellIndexPath!, atScrollPosition: targetScrollingPos, animated:  true)
                print("Scrolling to optimal Section")
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                    let timetitleCell : TimetitleCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(timetitleCellIdentifier, forIndexPath: indexPath) as! TimetitleCollectionViewCell
                    timetitleCell.backgroundColor = cellBackgroundColor
                    timetitleCell.timetitleLabel.font = UIFont.systemFontOfSize(13)
                    timetitleCell.timetitleLabel.textColor = defaultTextColor
                    timetitleCell.timetitleLabel.text = NSLocalizedString("time", comment: "TransForTime")
                
                    if indexPath.section != numberOfSections - 1 {
                        timetitleCell.dividingView.backgroundColor = dividingLineColor
                    }
                
                    return timetitleCell
                
            } else {
                let dayCell : DayCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dayCellIdentifier, forIndexPath: indexPath) as! DayCollectionViewCell
                let dayArray = day.generateDayArray()
                dayCell.dayLabel.font = UIFont.systemFontOfSize(13)
                dayCell.dayLabel.textColor = defaultTextColor
                dayCell.dayLabel.text = dayArray[indexPath.row - 1] as? String
                
                /*if indexPath.section % 2 != 0 {
                    dayCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    dayCell.backgroundColor = cellBackgroundColor
                }*/
                dayCell.backgroundColor = cellBackgroundColor
                
                if indexPath.section != numberOfSections - 1 {
                    dayCell.dividingView.backgroundColor = dividingLineColor
                }
                
                return dayCell
                
            }
        } else {
            if indexPath.row == 0 {
                let timeCell: TimeCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(timeCellIdentifier, forIndexPath: indexPath) as! TimeCollectionViewCell
                timeCell.starttimeLabel.font = UIFont.systemFontOfSize(13)
                timeCell.endtimeLabel.font = UIFont.systemFontOfSize(13)
                timeCell.starttimeLabel.textColor = defaultTextColor
                timeCell.endtimeLabel.textColor = defaultTextColor
                timeCell.starttimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section, when: "start")
                timeCell.endtimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section, when: "end")
                /*if indexPath.section % 2 != 0 {
                    timeCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    timeCell.backgroundColor = cellBackgroundColor
                }*/
                timeCell.backgroundColor = cellBackgroundColor
                
                if indexPath.section != numberOfSections - 1 {
                    timeCell.dividingView.backgroundColor = dividingLineColor
                }
                
                return timeCell
            } else {
                
                let celltoreturn: UICollectionViewCell
                
                let alesson = declarelesson.getNewLessonForUI(indexPath.row, pos: indexPath.section)
                
                switch alesson.status {
                    case .Default:
                        let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        lessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.subjectLabel.textColor = defaultTextColor
                        lessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        lessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.teacherLabel.textColor = defaultTextColor
                        lessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        lessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.roomLabel.textColor = defaultTextColor
                        lessonCell.roomLabel.text = alesson.room
                        
                        
                        if indexPath.section != numberOfSections - 1 {
                            lessonCell.dividingView.backgroundColor = dividingLineColor
                        }
                    
                        celltoreturn = lessonCell
                    
                    case .Cancelled:
                        let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        lessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.subjectLabel.textColor = cancelledLessonTextColor
                        lessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        lessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.teacherLabel.textColor = cancelledLessonTextColor
                        lessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        lessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.roomLabel.textColor = cancelledLessonTextColor
                        lessonCell.roomLabel.text = alesson.room
                        //Crossing out Lesson
                        lessonCell.crossOutView.backgroundColor = cancelledLessonTextColor
                        
                        
                        if indexPath.section != numberOfSections - 1 {
                            lessonCell.dividingView.backgroundColor = dividingLineColor
                        }
                    
                        celltoreturn = lessonCell
                    
                    case .Replaced:
                        let replacedlessonCell: ReplacedLessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(replacedlessonCellIdentifier, forIndexPath: indexPath) as! ReplacedLessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        replacedlessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subjectLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        replacedlessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.teacherLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        replacedlessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.roomLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.roomLabel.text = alesson.room
                        // Declaring subsubjectLabel appearance
                        replacedlessonCell.subsubjectLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subsubjectLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subsubjectLabel.text = alesson.subsubject
                        // Declaring subteacherLabel appearance
                        replacedlessonCell.subteacherLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subteacherLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subteacherLabel.text = alesson.subteacher
                        // Declaring subroomLabel appearance
                        replacedlessonCell.subroomLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subroomLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subroomLabel.text = alesson.subroom
                        
                        
                        if indexPath.section != numberOfSections - 1 {
                            replacedlessonCell.dividingView.backgroundColor = dividingLineColor
                        }
                    
                        celltoreturn = replacedlessonCell
                    
                    case .Empty:
                        let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring empty Lesson
                        lessonCell.subjectLabel.text = ""
                        lessonCell.teacherLabel.text = ""
                        lessonCell.roomLabel.text = ""
                        
                        
                        if indexPath.section != numberOfSections - 1 {
                            lessonCell.dividingView.backgroundColor = dividingLineColor
                        }
                        
                        celltoreturn = lessonCell
                    
                    case .Special:
                        let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        //let previousSection = (indexPath.section - 1)
                        //print("previousSection\(previousSection)")
                        //let previousIndexPath = NSIndexPath(forRow: indexPath.row, inSection: previousSection)
                        //var previousCell = LessonCollectionViewCell()
                        //if previousSection > 1 {
                        //    previousCell = collectionView.cellForItemAtIndexPath(previousIndexPath) as! LessonCollectionViewCell
                        //}
                        lessonCell.teacherLabel.text = ""
                        lessonCell.roomLabel.text = ""
                        lessonCell.subjectLabel.textColor = cellBackgroundColor
                        lessonCell.backgroundColor = specialLessonBackgroundColor
                        //if previousCell.backgroundColor == specialLessonBackgroundColor && previousCell.subjectLabel.text == alesson.subject {
                        //    lessonCell.subjectLabel.text = ""
                        //} else {
                        lessonCell.subjectLabel.text = alesson.subject
                        //}
                        
                        if indexPath.section != numberOfSections - 1 {
                            lessonCell.dividingView.backgroundColor = dividingLineColor
                        }
                        
                        celltoreturn = lessonCell
                }
                
                if celltoreturn.backgroundColor != specialLessonBackgroundColor {
                    celltoreturn.backgroundColor = cellBackgroundColor
                    /*if indexPath.section % 2 != 0{
                        celltoreturn.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                    } else {
                        celltoreturn.backgroundColor = cellBackgroundColor
                    }*/
                }

                
                //celltoreturn.layer.borderColor = replacedLessonTextColor.CGColor
                //celltoreturn.layer.borderWidth = 1.0
                return celltoreturn
            }
        }
    }
}

