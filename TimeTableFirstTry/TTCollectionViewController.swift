//
//  TTCollectionViewController.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 25.10.2015.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
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
    let calendar = Calendar.current
    
    //MARK: CLASSES
    let timegetter = TimetableTime()
    let declarelesson = DeclareLesson()
    let layout = TTCollectionViewLayout()
    let landscapelayout = TTLandscapeCollectionViewLayout()
    let day = Day()
    let sup = DeviceSupport()
    
    var userDefaults = UserDefaults.standard

    //MARK: INTEGERS
    let numberOfSections = 13
    let numberOfColumns = 16
    
    //MARK: CGPoints
    var scrollStartContentOffset: CGPoint = CGPoint(x: 0, y: 0)
    
    //MARK: COLORS
    let dividingLineColor = UIColor(hue: 0.8639, saturation: 0, brightness: 0.83, alpha: 1.0) //GRAY
    let white = UIColor.white
    let replacedLessonTextColor = UIColor.blue
    let cancelledLessonTextColor = UIColor.red
    let defaultTextColor = UIColor.black
    let specialLessonBackgroundColor = UIColor(hue: 0.4778, saturation: 0.73, brightness: 0.46, alpha: 1.0) //#18776c, DARKGREEN
    let specialDividingLineColor = UIColor(hue: 0.4833, saturation: 0.79, brightness: 0.7, alpha: 1.0) // #25b2a4, GDARGREEN-BLUE

    
    let yellowGreen = UIColor(hue: 0.1694, saturation: 0.74, brightness: 0.84, alpha: 1.0)              //GREEN-YELLOW
    let darkgreenTint = UIColor(hue: 0.4778, saturation: 0.73, brightness: 0.46, alpha: 1.0)            //#18776c, DARKGREEN
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
        NotificationCenter.default.addObserver(self, selector: #selector(TTCollectionViewController.checkToken), name: NSNotification.Name(rawValue: "newData"), object: nil)
        adaptLayout()
        super.viewDidLoad()
        assignCurrentLesson()
        self.collectionView.backgroundColor = dividingLineColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !userDefaults.bool(forKey: "loginCancelled") {
            checkToken()
        } else {
            userDefaults.set(false, forKey: "loginCancelled")
        }
    }
    
    /**
    Reloading Layout and showing Day
    */
    override func viewWillAppear(_ animated: Bool) {
        adaptLayout()
        scrollToCurrentSection(self.collectionView, animated: false)
    }

    /**
    Detecting orientation and setting Layout appropiatly
    */
    func adaptLayout() {
        if UIApplication.shared.statusBarOrientation == .portrait {
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
    @IBAction func backButton(_ sender: AnyObject) {
        assignCurrentLesson()
        scrollToCurrentSection(self.collectionView, animated: true)
    }

    
    //MARK: REFRESH BUTTON
    /**
    Loading Data and getting New Token if necessary
    */
    @IBAction func refreshButton(_ sender: AnyObject) {
        if !userDefaults.bool(forKey: "isSaving") {
            let apiHandler = APIHandler()
            apiHandler.getDataWithToken()
            print("REFRESH!!")
            print("RetrivedNewToken: " + String(userDefaults.bool(forKey: "RetrievedNewToken")))
            checkToken()
        }
    }
    
    /**
    checks if there is a new token needed and updates appropiatly
    */
    func checkToken() {
        self.collectionView.reloadData()
        if !userDefaults.bool(forKey: "RetrievedNewToken") {
            goToLogin()
        }
    }
        
    /**
    Shows the login View Controller
    */
    func goToLogin() {
        self.performSegue(withIdentifier: loginSegueIdentifier, sender: nil)
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
    func setLayoutToPortrait(_ animated: Bool) {
        self.collectionView.setCollectionViewLayout(layout, animated: animated)
    }
    
    /**
    Change the Layout of the collectionView to TTLandscapeCollectionViewLayout
    */
    func setLayoutToLandscape(_ animated: Bool) {
        self.collectionView.setCollectionViewLayout(landscapelayout, animated: animated)
    }
    
    /**
    Make needed changes for Rotation
    */
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if toInterfaceOrientation == .portrait {
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
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if fromInterfaceOrientation != .portrait {
            scrollToOptimalSection(self.collectionView, animated: true)     //Scroll to the section that is best
        }
        // Reload Day section so Dates are shorter if needed
        self.collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    
    // MARK: PAGING
    
    
    /**
    Setting scrollStartContentOffset for later use
    */
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            scrollStartContentOffset = collectionView.contentOffset
            scrollStartContentOffset.x += layout.getTimeColumnWidth()
        }
    }
    
    /**
    Check if orientation is portrait and scroll to optimal Section
    */
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown  {
            scrollToOptimalSection(scrollView, animated: true)
        }
    }
    
    /**
    Check if abrupt stop and if orientation is portrait and scroll to optimal section
    */
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown {
                scrollToOptimalSection(scrollView, animated: true)
            }
        }
    }
    
    /**
    Determining the best cell for current offset and scrolling to it
    */
    func scrollToOptimalSection(_ scrollView: UIScrollView, animated: Bool) {
        if scrollView == self.collectionView {
            let targetScrollingPos = UICollectionViewScrollPosition.right
            
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
            
            let currentIndexPath = collectionView.indexPathForItem(at: currentCellOffset)    //New IndexPath based on modified Offset
            if currentIndexPath != nil {
                let targetCellIndexPath = IndexPath(item: ((currentIndexPath as NSIndexPath?)?.row)!, section: ((currentIndexPath as NSIndexPath?)?.section)! + 1)
                collectionView.scrollToItem(at: targetCellIndexPath, at: targetScrollingPos, animated: animated) //Scrolling to determined IndexPath
            }
        }
    }
    
    /**
    Determining the current Day and scrolling to corresponding section
    */
    func scrollToCurrentSection(_ scrollView: UIScrollView, animated: Bool) {
        if scrollView == self.collectionView {
            let targetScrollingPos = UICollectionViewScrollPosition.right
            let targetItem = currentLesson[0] - 1   //Modifying returned Day so Monday(2) -> row 1
            
            let targetIndexPath = IndexPath(item: targetItem, section: 1) //Creating IndexPath based on recieved Day
            
            collectionView.scrollToItem(at: targetIndexPath, at: targetScrollingPos, animated: animated) //Scroll to IndexPath
        }
    }
    
    //Determining if self.currentLesoon is empty and filling it if needed.
    func assignCurrentLesson() {
        if self.currentLesson == [] {
            self.currentLesson = timegetter.getCurrentLessonCoordinates()
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    /**
    The CollectionView has numberOfSections sections
    */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    /**
    The CollectionView has numberOfColumns items in everySection
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        assignCurrentLesson()
        
        if (indexPath as NSIndexPath).section == 0 { //First section
            if (indexPath as NSIndexPath).row == 0 { //Top Left corner
                let dayCell: DayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as! DayCollectionViewCell

                dayCell.dayLabel.text = NSLocalizedString("time", comment: "TransForTime")
                
                dayCell.dividingView.backgroundColor = dividingLineColor
                
                dayCell.backgroundColor = yellowGreen
                dayCell.dayLabel.textColor = darkgreenTint
                
                return dayCell
                
            } else {    //Day section without first row
                let dayCell: DayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: dayCellIdentifier, for: indexPath) as! DayCollectionViewCell
                
                let dayArray: [String]
                if UIApplication.shared.statusBarOrientation == .portrait {
                    dayArray = day.generateDayArray(.long, forUI: true)
                } else {
                    if sup.getAbsoluteDisplayHeight() > 480 {
                        dayArray = day.generateDayArray(.short,forUI: true)
                    } else {
                        dayArray = day.generateDayArray(.veryshort, forUI: true)
                    }
                }
                dayCell.dayLabel.text = dayArray[(indexPath as NSIndexPath).row - 1]
                
                dayCell.dividingView.backgroundColor = dividingLineColor
                if (indexPath as NSIndexPath).item == (currentLesson[0] - 1) {
                    dayCell.dayLabel.font = UIFont.boldSystemFont(ofSize: 13)
                }
                
                dayCell.backgroundColor = yellowGreen
                dayCell.dayLabel.textColor = darkgreenTint
                
                return dayCell
                
            }
        } else { //Everything but the first section
            if (indexPath as NSIndexPath).row == 0 { //Time column without the first section
                
                let timeCell: TimeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: timeCellIdentifier, for: indexPath) as! TimeCollectionViewCell

                timeCell.starttimeLabel.text = timegetter.getLessonTimeAsString((indexPath as NSIndexPath).section - 1, when: .start, withSeconds:  false)
                timeCell.endtimeLabel.text = timegetter.getLessonTimeAsString((indexPath as NSIndexPath).section - 1, when: .end, withSeconds: false)
                
                timeCell.dividingView.backgroundColor = dividingLineColor
                
                return timeCell
                
            } else { //Main content room, wthout first section or row
                //Cell for the indexPath
                let celltoreturn: UICollectionViewCell
                
                //UILesson with all the necessairy information
                let alesson: UILesson = declarelesson.getNewLessonForUI((indexPath as NSIndexPath).section, item: (indexPath as NSIndexPath).item)
                
                //The appearance changes for the different states of the UILesson
                switch alesson.status {
                    case .default:
                        //Get default lesson
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: lessonCellIdentifier, for: indexPath) as! LessonCollectionViewCell
                        //Declaring label content
                        lessonCell.subjectLabel.text = alesson.subject
                        lessonCell.teacherLabel.text = alesson.teacher
                        lessonCell.roomLabel.text = alesson.room
                        //Declaring cell appearance
                        lessonCell.dividingView.backgroundColor = dividingLineColor
                        
                        celltoreturn = lessonCell as LessonCollectionViewCell
                    
                    case .cancelled:
                        //Get cancelled lesson
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: lessonCellIdentifier, for: indexPath) as! LessonCollectionViewCell
                        //Declaring label content
                        lessonCell.subjectLabel.text = alesson.subject
                        lessonCell.teacherLabel.text = alesson.teacher
                        lessonCell.roomLabel.text = alesson.room
                        //Declaring label appearance
                        lessonCell.teacherLabel.textColor = cancelledLessonTextColor
                        lessonCell.subjectLabel.textColor = cancelledLessonTextColor
                        lessonCell.roomLabel.textColor = cancelledLessonTextColor

                        //Declaring cell appearance
                        lessonCell.crossOutView.backgroundColor = cancelledLessonTextColor
                        lessonCell.dividingView.backgroundColor = dividingLineColor
                
                        celltoreturn = lessonCell
                    
                    case .replaced:
                        //Get replaced lesson
                        let replacedlessonCell: ReplacedLessonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: replacedlessonCellIdentifier, for: indexPath) as! ReplacedLessonCollectionViewCell
                        //Declaring label content
                        replacedlessonCell.subjectLabel.text = alesson.subject
                        replacedlessonCell.teacherLabel.text = alesson.teacher
                        replacedlessonCell.roomLabel.text = alesson.room
                        replacedlessonCell.subsubjectLabel.text = alesson.subsubject
                        replacedlessonCell.subroomLabel.text = alesson.subroom
                        replacedlessonCell.subteacherLabel.text = alesson.subteacher
                        // Declaring label appearance
                        replacedlessonCell.subjectLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.roomLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subsubjectLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subteacherLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.teacherLabel.textColor = replacedLessonTextColor
                        replacedlessonCell.subroomLabel.textColor = replacedLessonTextColor
                        
                        //Declaring cell appearance
                        replacedlessonCell.dividingView.backgroundColor = dividingLineColor
                    
                        celltoreturn = replacedlessonCell
                    
                    case .empty:
                        //Get empty lesson
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: lessonCellIdentifier, for: indexPath) as! LessonCollectionViewCell
                        // Declaring label content
                        lessonCell.subjectLabel.text = ""
                        lessonCell.teacherLabel.text = ""
                        lessonCell.roomLabel.text = ""
                        
                        //Declare cell appearance
                        lessonCell.dividingView.backgroundColor = dividingLineColor
                        
                        celltoreturn = lessonCell
                    
                    case .special:
                        //Get special Lesson
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: specialLessonCellIdentifier, for: indexPath) as! LessonCollectionViewCell
                        //Declare label content
                        lessonCell.subjectLabel.text = alesson.subject
                        lessonCell.teacherLabel.text = alesson.teacher
                        lessonCell.roomLabel.text = alesson.room
                        //Declare label appearance
                        lessonCell.subjectLabel.textColor = white
                        lessonCell.teacherLabel.textColor = white
                        lessonCell.roomLabel.textColor = white
                        //Declare cell appearance
                        lessonCell.backgroundColor = specialLessonBackgroundColor
                        lessonCell.dividingView.backgroundColor = specialDividingLineColor
                        
                        celltoreturn = lessonCell
                    
                    case .movedTo:
                        //Get moved lesson
                        let lessonCell: LessonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: lessonCellIdentifier, for: indexPath) as! LessonCollectionViewCell
                        //Declare label content
                        lessonCell.teacherLabel.text = alesson.teacher
                        lessonCell.subjectLabel.text = alesson.subject
                        lessonCell.roomLabel.text = alesson.room
                        //Declare label appearance
                        lessonCell.teacherLabel.textColor = replacedLessonTextColor
                        lessonCell.subjectLabel.textColor = replacedLessonTextColor
                        lessonCell.roomLabel.textColor = replacedLessonTextColor
                    
                        celltoreturn = lessonCell
                }
                
                //Mark the current Lesson
                if (indexPath as NSIndexPath).item == currentLesson[0] - 1 && (indexPath as NSIndexPath).section == currentLesson[1] + 1 {
                    celltoreturn.backgroundColor = currentLessonMarker
                }

                return celltoreturn
            }
        }
    }
}

