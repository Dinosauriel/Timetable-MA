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
    
    let myTime = TimetableTime()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView .registerNib(UINib(nibName: "TimetitleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: timetitleCellIdentifier)
        self.collectionView .registerNib(UINib(nibName: "DayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dayCellIdentifier)
        
        print(myTime.getLessonTime(5, when: "start"))
        print(myTime.getLessonTime(5, when: "end"))
        
        print(myTime.getLessonTimeAsString(5, when: "end"))
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
                let timetitleCell: TimetitleCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(timetitleCellIdentifier, forIndexPath: indexPath) as! TimetitleCollectionViewCell
                timetitleCell.timetitleLabel.font = UIFont.systemFontOfSize(13)
                timetitleCell.timetitleLabel.textColor = UIColor.blackColor()
                timetitleCell.timetitleLabel.text = String(indexPath.section)
                if indexPath.section % 2 != 0 {
                    timetitleCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    timetitleCell.backgroundColor = UIColor.whiteColor()
                }
                
                return timetitleCell
            } else {
                let dayCell : DayCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dayCellIdentifier, forIndexPath: indexPath) as! DayCollectionViewCell
                dayCell.dayLabel.font = UIFont.systemFontOfSize(13)
                dayCell.dayLabel.textColor = UIColor.blackColor()
                dayCell.dayLabel.text = "Content"
                if indexPath.section % 2 != 0 {
                    dayCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    dayCell.backgroundColor = UIColor.whiteColor()
                }
                
                return dayCell
            }
        }
    }
}

