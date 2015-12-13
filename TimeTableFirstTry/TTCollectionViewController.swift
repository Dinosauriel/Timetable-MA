//
//  CollectionViewController.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 25/10/2015.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class TTCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: IDENTIFIERS
    let timetitleCellIdentifier = "TimetitleCellIdentifier"
    let dayCellIdentifier = "DayCellIdentifier"
    let timeCellIdentifier = "TimeCellIdentifier"
    let lessonCellIdentifier = "LessonCellIdentifier"
    let replacedlessonCellIdentifier = "ReplacedLessonCellIdentifier"
    
    let loginSegueIdentifier = "showLogin"
    
    //MARK: TIME
    let calendar = NSCalendar.currentCalendar()
    
    //MARK: CLASSES
    let timegetter = TimetableTime()
    let declarelesson = DeclareLesson()
    let layout = TTCollectionViewLayout()
    let landscapelayout = TTLandscapeCollectionViewLayout()
    let day = Day()
    var UserDefaults = NSUserDefaults.standardUserDefaults()

    //MARK: INTEGERS
    let numberOfSections = 13
    let numberOfRows = 6
    
    //MARK: CGPoints
    var scrollStartContentOffset: CGPoint = CGPoint(x: 0, y: 0)
    
    //MARK: COLORS
    let dividingLineColor = UIColor(hue: 0.8639, saturation: 0, brightness: 0.83, alpha: 1.0) //GRAY
    let cellBackgroundColor = UIColor.whiteColor()
    let replacedLessonTextColor = UIColor.blueColor()
    let cancelledLessonTextColor = UIColor.redColor()
    let defaultTextColor = UIColor.blackColor()
    let specialLessonBackgroundColor = UIColor(hue: 0.8639, saturation: 0, brightness: 0.83, alpha: 1.0) //GRAY
    
    //MARK: TIMES
    //let rotationScrollDelayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
    
    //MARK: OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topStatusbarConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationBarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollToCurrentSection(collectionView)
        
        if !UserDefaults.boolForKey("HasLaunchedOnce") {
            UserDefaults.setBool(true, forKey: "HasLaunchedOnce")
        }

    }

    override func viewWillAppear(animated: Bool) {
        if UIApplication.sharedApplication().statusBarOrientation == .Portrait {
            addStatusBar()
            setLayoutToPortrait(false)
        } else {
            removeStatusBar()
            setLayoutToLandscape(false)
        }
    }
    
    //MARK: REFRESH BUTTON
    @IBAction func refreshButton(sender: AnyObject) {
        let apiHandler = APIHandler()
        apiHandler.getDataWithToken()
        print("REFRESH!!")
        self.performSegueWithIdentifier(loginSegueIdentifier, sender: nil)
    }


    // MARK: BAR HANDLING
    func removeStatusBar() {
        topStatusbarConstraint.constant = 0
        navigationBarHeightConstraint.constant = 44
    }
    
    
    func addStatusBar() {
        topStatusbarConstraint.constant = 0
        navigationBarHeightConstraint.constant = 64
    }
    
    func setLayoutToPortrait(animated: Bool) {
        self.collectionView.setCollectionViewLayout(layout, animated: animated)
    }
    
    func setLayoutToLandscape(animated: Bool) {
        self.collectionView.setCollectionViewLayout(landscapelayout, animated: animated)
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation == .Portrait {
            addStatusBar()
            setLayoutToPortrait(false)
            
        } else {
            
            removeStatusBar()
            setLayoutToLandscape(false)
        }
        
    }
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if fromInterfaceOrientation != .Portrait {
            scrollToOptimalSection(self.collectionView, animated: true)
        }
    }
    
    
    // MARK: PAGING
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollStartContentOffset = collectionView.contentOffset
        scrollStartContentOffset.x += layout.getTimeColumnWidth()
    }
    
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if UIApplication.sharedApplication().statusBarOrientation == .Portrait || UIApplication.sharedApplication().statusBarOrientation == .PortraitUpsideDown  {
            scrollToOptimalSection(scrollView, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if UIApplication.sharedApplication().statusBarOrientation == .Portrait || UIApplication.sharedApplication().statusBarOrientation == .PortraitUpsideDown {
                scrollToOptimalSection(scrollView, animated: true)
            }
        }
    }
    
    func scrollToOptimalSection(scrollView: UIScrollView, animated: Bool) {
        if scrollView == self.collectionView {
            let targetScrollingPos = UICollectionViewScrollPosition.Right
            var currentCellOffset: CGPoint = self.collectionView.contentOffset
            currentCellOffset.x += layout.getTimeColumnWidth()
            let columnWidth = self.collectionView.bounds.width - layout.getTimeColumnWidth()
            
            let rightTargetFactor: CGFloat = 0.7
            let leftTargetFactor: CGFloat = 1 - rightTargetFactor
            
            if (currentCellOffset.x - scrollStartContentOffset.x) < 0 {
                currentCellOffset.x += (columnWidth * leftTargetFactor)
            } else {
                currentCellOffset.x += (columnWidth * rightTargetFactor)
            }
            
            let targetCellIndexPath = collectionView.indexPathForItemAtPoint(currentCellOffset)
            if targetCellIndexPath != nil {
                collectionView.scrollToItemAtIndexPath(targetCellIndexPath!, atScrollPosition: targetScrollingPos, animated: animated)
            }
        }
    }
    
    func scrollToCurrentSection(scrollView: UIScrollView) {
        print("Scrolling to Day...")
        if scrollView == self.collectionView {
            let date = NSDate()
            let targetScrollingPos = UICollectionViewScrollPosition.Right
            let currentWeekDayCal = calendar.components(.Weekday, fromDate: date)
            let currentWeekDay = currentWeekDayCal.weekday
            
            var targetItem: Int
            
            switch currentWeekDay {
                case 3:
                    targetItem = 2
                case 4:
                    targetItem = 3
                case 5:
                    targetItem = 4
                case 6:
                    targetItem = 5
                default:
                    targetItem = 1
            }
            print(targetItem)
            
            let targetIndexPath = NSIndexPath(forItem: targetItem, inSection: 1)
            
            collectionView.scrollToItemAtIndexPath(targetIndexPath, atScrollPosition: targetScrollingPos, animated: false)
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
                let timetitleCell: TimetitleCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(timetitleCellIdentifier, forIndexPath: indexPath) as! TimetitleCollectionViewCell
                //timetitleCell.backgroundColor = cellBackgroundColor
                //timetitleCell.timetitleLabel.font = UIFont.systemFontOfSize(13)
                //timetitleCell.timetitleLabel.textColor = defaultTextColor
                timetitleCell.timetitleLabel.text = NSLocalizedString("time", comment: "TransForTime")
                
                if indexPath.section != (numberOfSections - 1) {
                    timetitleCell.dividingView.backgroundColor = dividingLineColor
                }
                //timetitleCell.vertDividingView.backgroundColor = dividingLineColor
                
                return timetitleCell
                
            } else {
                let dayCell : DayCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dayCellIdentifier, forIndexPath: indexPath) as! DayCollectionViewCell
                let dayArray = day.generateDayArray()
                //dayCell.dayLabel.font = UIFont.systemFontOfSize(13)
                //dayCell.dayLabel.textColor = defaultTextColor
                dayCell.dayLabel.text = dayArray[indexPath.row - 1] as? String
                
                //dayCell.backgroundColor = cellBackgroundColor
                
                if indexPath.section != (numberOfSections - 1) {
                    dayCell.dividingView.backgroundColor = dividingLineColor
                }
                //dayCell.vertDividingView.backgroundColor = dividingLineColor
                
                return dayCell
                
            }
        } else {
            if indexPath.row == 0 {
                let timeCell: TimeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(timeCellIdentifier, forIndexPath: indexPath) as! TimeCollectionViewCell
                //timeCell.starttimeLabel.font = UIFont.systemFontOfSize(13)
                //timeCell.endtimeLabel.font = UIFont.systemFontOfSize(13)
                //timeCell.starttimeLabel.textColor = defaultTextColor
                //timeCell.endtimeLabel.textColor = defaultTextColor
                timeCell.starttimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section, when: "start")
                timeCell.endtimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section, when: "end")
                
                //timeCell.backgroundColor = cellBackgroundColor
                
                if indexPath.section != (numberOfSections - 1) {
                    timeCell.dividingView.backgroundColor = dividingLineColor
                }
                //timeCell.vertDividingView.backgroundColor = dividingLineColor
                
                return timeCell
            } else {
                
                let celltoreturn: UICollectionViewCell
                
                let alesson = declarelesson.getNewLessonForUI(indexPath.row, pos: indexPath.section)
                
                switch alesson.status {
                    case .Default:
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        //lessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                        //lessonCell.subjectLabel.textColor = defaultTextColor
                        lessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        //lessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                        //lessonCell.teacherLabel.textColor = defaultTextColor
                        lessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        //lessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                        //lessonCell.roomLabel.textColor = defaultTextColor
                        lessonCell.roomLabel.text = alesson.room
                        
                        
                        if indexPath.section != (numberOfSections - 1) {
                            lessonCell.dividingView.backgroundColor = dividingLineColor
                        }
                        //lessonCell.vertDividingView.backgroundColor = dividingLineColor
                        
                        celltoreturn = lessonCell as LessonCollectionViewCell
                    
                    case .Cancelled:
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        //lessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.subjectLabel.textColor = cancelledLessonTextColor
                        lessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        //lessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.teacherLabel.textColor = cancelledLessonTextColor
                        lessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        //lessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                        lessonCell.roomLabel.textColor = cancelledLessonTextColor
                        lessonCell.roomLabel.text = alesson.room
                        //Crossing out Lesson
                        lessonCell.crossOutView.backgroundColor = cancelledLessonTextColor
                        
                        
                        if indexPath.section != (numberOfSections - 1) {
                            lessonCell.dividingView.backgroundColor = dividingLineColor
                        }
                        //lessonCell.vertDividingView.backgroundColor = dividingLineColor

                    
                        celltoreturn = lessonCell
                    
                    case .Replaced:
                        let replacedlessonCell: ReplacedLessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(replacedlessonCellIdentifier, forIndexPath: indexPath) as! ReplacedLessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        //replacedlessonCell.subjectLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subjectLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        //replacedlessonCell.teacherLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.teacherLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        //replacedlessonCell.roomLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.roomLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.roomLabel.text = alesson.room
                        // Declaring subsubjectLabel appearance
                        //replacedlessonCell.subsubjectLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subsubjectLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subsubjectLabel.text = alesson.subsubject
                        // Declaring subteacherLabel appearance
                        //replacedlessonCell.subteacherLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subteacherLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subteacherLabel.text = alesson.subteacher
                        // Declaring subroomLabel appearance
                        //replacedlessonCell.subroomLabel.font = UIFont.systemFontOfSize(13)
                        replacedlessonCell.subroomLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subroomLabel.text = alesson.subroom
                        
                        
                        if indexPath.section != (numberOfSections - 1) {
                            replacedlessonCell.dividingView.backgroundColor = dividingLineColor
                        }
                        //replacedlessonCell.vertDividingView.backgroundColor = dividingLineColor
                    
                        celltoreturn = replacedlessonCell
                    
                    case .Empty:
                        let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring empty Lesson
                        lessonCell.subjectLabel.text = ""
                        lessonCell.teacherLabel.text = ""
                        lessonCell.roomLabel.text = ""
                        
                        if indexPath.section != (numberOfSections - 1) {
                            lessonCell.dividingView.backgroundColor = dividingLineColor
                        }
                        //lessonCell.vertDividingView.backgroundColor = dividingLineColor
                        
                        celltoreturn = lessonCell
                    
                    case .Special:
                        let lessonCell: LessonCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        
                        lessonCell.teacherLabel.text = ""
                        lessonCell.roomLabel.text = ""
                        lessonCell.subjectLabel.textColor = cellBackgroundColor
                        lessonCell.backgroundColor = specialLessonBackgroundColor

                        lessonCell.subjectLabel.text = alesson.subject
                        
                        if indexPath.section != (numberOfSections - 1) {
                            lessonCell.dividingView.backgroundColor = dividingLineColor
                        }
                        
                        celltoreturn = lessonCell
                }
                
                return celltoreturn
            }
        }
    }
}

