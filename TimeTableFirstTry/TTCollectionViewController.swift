//
//  CollectionViewController.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 25/10/2015.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class TTCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: VARIABLES
    //MARK: IDENTIFIERS
    let timetitleCellIdentifier = "TimetitleCellIdentifier"
    let dayCellIdentifier = "DayCellIdentifier"
    let timeCellIdentifier = "TimeCellIdentifier"
    let lessonCellIdentifier = "LessonCellIdentifier"
    let replacedlessonCellIdentifier = "ReplacedLessonCellIdentifier"
    let specialLessonCellIdentifier = "specialLessonCellIdentifier"
    
    let loginSegueIdentifier = "showLogin"
    
    //MARK: TIME
    let calendar = NSCalendar.currentCalendar()
    
    //MARK: CLASSES
    let timegetter = TimetableTime()
    let declarelesson = DeclareLesson()
    let layout = TTCollectionViewLayout()
    let landscapelayout = TTLandscapeCollectionViewLayout()
    let day = Day()
    let sup = DeviceSupport()
    
    var userDefaults = NSUserDefaults.standardUserDefaults()

    //MARK: INTEGERS
    let numberOfSections = 13
    let numberOfColumns = 16
    
    //MARK: CGPoints
    var scrollStartContentOffset: CGPoint = CGPoint(x: 0, y: 0)
    
    //MARK: COLORS
    let dividingLineColor = UIColor(hue: 0.8639, saturation: 0, brightness: 0.83, alpha: 1.0) //GRAY
    let cellBackgroundColor = UIColor.whiteColor()
    let replacedLessonTextColor = UIColor.blueColor()
    let cancelledLessonTextColor = UIColor.redColor()
    let defaultTextColor = UIColor.blackColor()
    let specialLessonBackgroundColor = UIColor(hue: 0.1167, saturation: 0.83, brightness: 0.94, alpha: 1.0) //YELLOW
    let specialDividingLineColor = UIColor(hue: 0.0833, saturation: 0.83, brightness: 0.93, alpha: 1.0) // #ef8c28, ORANGE-YELLOW
    
    let yellowGreen = UIColor(hue: 0.1694, saturation: 0.74, brightness: 0.84, alpha: 1.0)              //GREEN-YELLOW
    let darkgreenTint = UIColor(hue: 0.4778, saturation: 0.73, brightness: 0.46, alpha: 1.0)            //DARKGREEN
    let currentLessonMarker = UIColor(hue: 0.1694, saturation: 0.5, brightness: 0.84, alpha: 1.0)
    
    //MARK: OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationBarHeightConstraint: NSLayoutConstraint!
    
    //MARK: ARRAYS
    var currentLesson: [Int] = []
    
    //---------------------------------------------------------------
    //MARK: CODE
    
    
    /**
    Preparing collectionView
    */
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkToken", name: "newData", object: nil)
        adaptLayout()
        super.viewDidLoad()
        assignCurrentLesson()
        self.collectionView.backgroundColor = dividingLineColor
    }
    
    /**
    Reloading Layout and showing Day
    */
    override func viewWillAppear(animated: Bool) {
        checkToken()
        adaptLayout()
        scrollToCurrentSection(self.collectionView, animated: false)
    }

    /**
    Detecting orientation and setting Layout appropiatly
    */
    func adaptLayout() {
        if UIApplication.sharedApplication().statusBarOrientation == .Portrait {
            addStatusBar()
            setLayoutToPortrait(false)
        } else {
            removeStatusBar()
            setLayoutToLandscape(false)
        }
    }
    
    //MARK: BACK BUTTON
    /**
    Goes back to today
    */
    @IBAction func backButton(sender: AnyObject) {
        assignCurrentLesson()
        scrollToCurrentSection(self.collectionView, animated: true)
    }

    
    //MARK: REFRESH BUTTON
    /**
    Loading Data and getting New Token if necessary
    */
    @IBAction func refreshButton(sender: AnyObject) {
        if !userDefaults.boolForKey("isSaving") {
            let apiHandler = APIHandler()
            apiHandler.getDataWithToken()
            print("REFRESH!!")
            print("RetrivedNewToken: " + String(userDefaults.boolForKey("RetrievedNewToken")))
            checkToken()
        }
    }
    
    /**
    checks if there is a new token needed and updates appropiatly
    */
    func checkToken() {
        self.collectionView.reloadData()
        if !userDefaults.boolForKey("RetrievedNewToken") {
            goToLogin()
        }
    }
    
    /**
    Shows the login View Controller
    */
    func goToLogin() {
        self.performSegueWithIdentifier(loginSegueIdentifier, sender: nil)
    }
    

    // MARK: BAR HANDLING
    
    
    /**
    Adapt needed constraints to hide the status Bar
    */
    func removeStatusBar() {
        if sup.getAbsoluteDisplayWidth() > 375 {
            navigationBarHeightConstraint.constant = 44
        } else {
            navigationBarHeightConstraint.constant = 34
        }
    }
    
    /**
    Adapt needed constraints to show the status Bar
    */
    func addStatusBar() {
        navigationBarHeightConstraint.constant = 64
    }
    
    /**
    Change the Layout of the collectionView to TTCollectionViewLayout
    */
    func setLayoutToPortrait(animated: Bool) {
        self.collectionView.setCollectionViewLayout(layout, animated: animated)
    }
    
    /**
    Change the Layout of the collectionView to TTLandscapeCollectionViewLayout
    */
    func setLayoutToLandscape(animated: Bool) {
        self.collectionView.setCollectionViewLayout(landscapelayout, animated: animated)
    }
    
    /**
    Make needed changes for Rotation
    */
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation == .Portrait {
            addStatusBar()
            setLayoutToPortrait(true)
        } else {
            removeStatusBar()
            setLayoutToLandscape(true)
        }
    }
    
    /**
    Scroll to current section if portrait
    */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if fromInterfaceOrientation != .Portrait {
            scrollToOptimalSection(self.collectionView, animated: true)     //Scroll to the section that is best
        }
        // Reload Day section so Dates are shorter if needed
        self.collectionView.reloadSections(NSIndexSet(index: 0))
    }
    
    
    // MARK: PAGING
    
    
    /**
    Setting scrollStartContentOffset for later use
    */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView == collectionView {
            scrollStartContentOffset = collectionView.contentOffset
            scrollStartContentOffset.x += layout.getTimeColumnWidth()
        }
    }
    
    /**
    Check if orientation is portrait and scroll to optimal Section
    */
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if UIApplication.sharedApplication().statusBarOrientation == .Portrait || UIApplication.sharedApplication().statusBarOrientation == .PortraitUpsideDown  {
            scrollToOptimalSection(scrollView, animated: true)
        }
    }
    
    /**
    Check if abrupt stop and if orientation is portrait and scroll to optimal section
    */
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if UIApplication.sharedApplication().statusBarOrientation == .Portrait || UIApplication.sharedApplication().statusBarOrientation == .PortraitUpsideDown {
                scrollToOptimalSection(scrollView, animated: true)
            }
        }
    }
    
    /**
    Determining the best cell for current offset and scrolling to it
    */
    func scrollToOptimalSection(scrollView: UIScrollView, animated: Bool) {
        if scrollView == self.collectionView {
            let targetScrollingPos = UICollectionViewScrollPosition.Right
            
            var currentCellOffset: CGPoint = self.collectionView.contentOffset  //Determining current Offset
            currentCellOffset.x += layout.getTimeColumnWidth()                  //Adapting it to get the true Offset
            
            let columnWidth = self.collectionView.bounds.width - layout.getTimeColumnWidth()   //Calculate Width of column
            
            let rightTargetFactor: CGFloat = 0.8                    //Determine sensitivity
            let leftTargetFactor: CGFloat = 1 - rightTargetFactor
            
            if (currentCellOffset.x - scrollStartContentOffset.x) < 0 { //Determine scroll Direction (to Left)
                currentCellOffset.x += (columnWidth * leftTargetFactor)
            } else {                                                    //Determine scroll Direction (to Left)
                currentCellOffset.x += (columnWidth * rightTargetFactor)
            }
            
            let currentIndexPath = collectionView.indexPathForItemAtPoint(currentCellOffset)    //New IndexPath based on modified Offset
            if currentIndexPath != nil {
                let targetCellIndexPath = NSIndexPath(forItem: (currentIndexPath?.row)!, inSection: (currentIndexPath?.section)! + 1)
                collectionView.scrollToItemAtIndexPath(targetCellIndexPath, atScrollPosition: targetScrollingPos, animated: animated) //Scrolling to determined IndexPath
            }
        }
    }
    
    /**
    Determining the current Day and scrolling to corresponding section
    */
    func scrollToCurrentSection(scrollView: UIScrollView, animated: Bool) {
        if scrollView == self.collectionView {
            let targetScrollingPos = UICollectionViewScrollPosition.Right
            let targetItem = currentLesson[0] - 1   //Modifiing returned Day so Monday(2) -> row 1
            
            let targetIndexPath = NSIndexPath(forItem: targetItem, inSection: 1) //Creating IndexPath based on recieved Day
            
            collectionView.scrollToItemAtIndexPath(targetIndexPath, atScrollPosition: targetScrollingPos, animated: animated) //Scroll to IndexPath
        }
    }
    
    //Determining if self.currentLesoon is empty and filling it if needed.
    func assignCurrentLesson() {
        if self.currentLesson == [] {
            self.currentLesson = timegetter.getCurrentLessonCoordinates()
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfColumns
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        assignCurrentLesson()
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let dayCell: DayCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(dayCellIdentifier, forIndexPath: indexPath) as! DayCollectionViewCell

                dayCell.dayLabel.text = NSLocalizedString("time", comment: "TransForTime")
                
                dayCell.dividingView.backgroundColor = dividingLineColor
                
                dayCell.backgroundColor = yellowGreen
                dayCell.dayLabel.textColor = darkgreenTint
                
                return dayCell
                
            } else {
                let dayCell: DayCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(dayCellIdentifier, forIndexPath: indexPath) as! DayCollectionViewCell
                
                let dayArray: [String]
                if UIApplication.sharedApplication().statusBarOrientation == .Portrait {
                    dayArray = day.generateDayArray(.long, forUI: true)
                } else {
                    if sup.getAbsoluteDisplayHeight() > 480 {
                        dayArray = day.generateDayArray(.short,forUI: true)
                    } else {
                        dayArray = day.generateDayArray(.veryshort, forUI: true)
                    }
                }
                dayCell.dayLabel.text = dayArray[indexPath.row - 1]
                
                dayCell.dividingView.backgroundColor = dividingLineColor
                if indexPath.item == (currentLesson[0] - 1) {
                    dayCell.dayLabel.font = UIFont.boldSystemFontOfSize(13)
                }
                
                dayCell.backgroundColor = yellowGreen
                dayCell.dayLabel.textColor = darkgreenTint
                
                return dayCell
                
            }
        } else {
            if indexPath.row == 0 {
                let timeCell: TimeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(timeCellIdentifier, forIndexPath: indexPath) as! TimeCollectionViewCell

                timeCell.starttimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section - 1, when: .Start, withSeconds:  false)
                timeCell.endtimeLabel.text = timegetter.getLessonTimeAsString(indexPath.section - 1, when: .End, withSeconds: false)
                
                timeCell.dividingView.backgroundColor = dividingLineColor
                
                return timeCell
            } else {
                
                let celltoreturn: UICollectionViewCell
                
                
                let alesson = declarelesson.getNewLessonForUI(indexPath.section, item: indexPath.item)
                
                switch alesson.status {
                    case .Default:
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        lessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        lessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        lessonCell.roomLabel.text = alesson.room
                        
                        lessonCell.dividingView.backgroundColor = dividingLineColor
                        
                        if indexPath.item == 3 {
                            lessonCell.backgroundView?.backgroundColor = yellowGreen
                        }
                        
                        celltoreturn = lessonCell as LessonCollectionViewCell
                    
                    case .Cancelled:
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        lessonCell.subjectLabel.textColor = cancelledLessonTextColor
                        lessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        lessonCell.teacherLabel.textColor = cancelledLessonTextColor
                        lessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        lessonCell.roomLabel.textColor = cancelledLessonTextColor
                        lessonCell.roomLabel.text = alesson.room
                        //Crossing out Lesson
                        lessonCell.crossOutView.backgroundColor = cancelledLessonTextColor
                        
                        lessonCell.dividingView.backgroundColor = dividingLineColor
                
                        celltoreturn = lessonCell
                    
                    case .Replaced:
                        let replacedlessonCell: ReplacedLessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(replacedlessonCellIdentifier, forIndexPath: indexPath) as! ReplacedLessonCollectionViewCell
                        // Declaring subjectLabel appearance
                        replacedlessonCell.subjectLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subjectLabel.text = alesson.subject
                        // Declaring teacherLabel appearance
                        replacedlessonCell.teacherLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.teacherLabel.text = alesson.teacher
                        // Declaring roomLabel appearance
                        replacedlessonCell.roomLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.roomLabel.text = alesson.room
                        // Declaring subsubjectLabel appearance
                        replacedlessonCell.subsubjectLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subsubjectLabel.text = alesson.subsubject
                        // Declaring subteacherLabel appearance
                        replacedlessonCell.subteacherLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subteacherLabel.text = alesson.subteacher
                        // Declaring subroomLabel appearance
                        replacedlessonCell.subroomLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subroomLabel.text = alesson.subroom
                        
                        replacedlessonCell.dividingView.backgroundColor = dividingLineColor
                    
                        celltoreturn = replacedlessonCell
                    
                    case .Empty:
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        // Declaring empty Lesson
                        lessonCell.subjectLabel.text = ""
                        lessonCell.teacherLabel.text = ""
                        lessonCell.roomLabel.text = ""
                        
                        lessonCell.dividingView.backgroundColor = dividingLineColor
                        
                        celltoreturn = lessonCell
                    
                    case .Special:
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(specialLessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                        

                        lessonCell.subjectLabel.textColor = cellBackgroundColor
                        lessonCell.backgroundColor = specialLessonBackgroundColor

                        lessonCell.subjectLabel.text = alesson.subject
                        lessonCell.teacherLabel.text = alesson.teacher
                        lessonCell.roomLabel.text = alesson.room
                        
                        lessonCell.dividingView.backgroundColor = specialDividingLineColor
                        
                        celltoreturn = lessonCell
                    
                    case .MovedTo:
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(lessonCellIdentifier, forIndexPath: indexPath) as! LessonCollectionViewCell
                    
                        lessonCell.teacherLabel.text = alesson.teacher
                        lessonCell.subjectLabel.text = alesson.subject
                        lessonCell.roomLabel.text = alesson.room
                    
                        lessonCell.teacherLabel.textColor = replacedLessonTextColor
                        lessonCell.subjectLabel.textColor = replacedLessonTextColor
                        lessonCell.roomLabel.textColor = replacedLessonTextColor
                    
                        celltoreturn = lessonCell
                }
                
                if indexPath.item == currentLesson[0] - 1 && indexPath.section == currentLesson[1] + 1 {
                    celltoreturn.backgroundColor = currentLessonMarker
                }

                
                return celltoreturn
            }
        }
    }
}

