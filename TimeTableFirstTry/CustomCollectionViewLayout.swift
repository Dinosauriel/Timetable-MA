//
//  CustomCollectionViewLayout.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 25/10/2015.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    
    var itemAttributes: NSMutableArray!
    var itemsSize: NSMutableArray!
    var contentSize: CGSize!
    var numberOfColumns = 6
    
    let marginForTimeColumn: CGFloat = 15
    let heightForDayRow: CGFloat = 40
    
    
    override func prepareLayout() {
        
        if self.collectionView?.numberOfSections() == 0 {
            return
        }
        
        if (self.itemAttributes != nil && self.itemAttributes.count > 0) {
            
            for section in 0 ..< self.collectionView!.numberOfSections() {
                let numberOfItems : Int = self.collectionView!.numberOfItemsInSection(section)
                for index in 0 ..< numberOfItems {
                    if section != 0 && index != 0 {
                        continue
                    }
                    
                    let attributes : UICollectionViewLayoutAttributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: index, inSection: section))
                    if section == 0 {
                        var frame = attributes.frame
                        frame.origin.y = self.collectionView!.contentOffset.y
                        attributes.frame = frame
                    }
                    
                    if index == 0 {
                        var frame = attributes.frame
                        frame.origin.x = self.collectionView!.contentOffset.x
                        attributes.frame = frame
                    }
                }
            }
            return
        }
        
        if (self.itemsSize == nil || self.itemsSize.count != numberOfColumns) {
            self.calculateItemsSize()
        }
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        var contentHeight: CGFloat = 0
        
        for section in 0 ..< self.collectionView!.numberOfSections() {
            let sectionAttributes = NSMutableArray()
            var itemHeight: CGFloat
            if section == 0 {
                itemHeight = 30
            } else {
                itemHeight = 60
            }
            
            for index in 0 ..< numberOfColumns {
                let itemSize = self.itemsSize[index].CGSizeValue()
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemHeight))
                
                if section == 0 && index == 0 {
                    attributes.zIndex = 1024
                } else  if section == 0 || index == 0 {
                    attributes.zIndex = 1023
                }
                
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = self.collectionView!.contentOffset.y
                    attributes.frame = frame
                }
                if index == 0 {
                    var frame = attributes.frame
                    frame.origin.x = self.collectionView!.contentOffset.x
                    attributes.frame = frame
                }
                
                sectionAttributes.addObject(attributes)
                
                xOffset += itemSize.width
                column++
                
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemHeight
                }
            }
            if (self.itemAttributes == nil) {
                self.itemAttributes = NSMutableArray(capacity: self.collectionView!.numberOfSections())
            }
            self.itemAttributes.addObject(sectionAttributes)
        }
        
        let attributes: UICollectionViewLayoutAttributes = self.itemAttributes.lastObject?.lastObject as! UICollectionViewLayoutAttributes
        contentHeight = attributes.frame.origin.y + attributes.frame.size.height
        self.contentSize = CGSizeMake(contentWidth, contentHeight)
    }
    
    override func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        
        return self.itemAttributes[indexPath.section][indexPath.row] as! UICollectionViewLayoutAttributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        if self.itemAttributes != nil {
            for section in self.itemAttributes {
                
                let filteredArray = section.filteredArrayUsingPredicate(
                    
                    NSPredicate(block: { (evaluatedObject, bindings) -> Bool in
                        return CGRectIntersectsRect(rect, evaluatedObject.frame)
                    })
                    ) as! [UICollectionViewLayoutAttributes]
                
                attributes.appendContentsOf(filteredArray)
                
            }
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    // MARK: CALCULATING SIZE FOR CELLS CALCULATIONS
    func sizeForItemWithColumnIndex(sectionIndex: Int) -> CGSize {
        
        let timeColumnWidth = getTimeColumnWidth()
        
        if sectionIndex != 0 {
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let width: CGFloat = screenSize.width - timeColumnWidth
            
            return CGSizeMake(width, 60)
            
        } else {

            return CGSizeMake(timeColumnWidth, 60)
        }
    }
    
    func calculateItemsSize() {
        self.itemsSize = NSMutableArray(capacity: numberOfColumns)
        for section in 0 ..< numberOfColumns {
            
            self.itemsSize.addObject(NSValue(CGSize: self.sizeForItemWithColumnIndex(section)))
        }
    }
    
    func getTimeColumnWidth() -> CGFloat {
        
        let timeTitle = NSLocalizedString("time", comment: "TimeTransForSizeCalculation")
        let timeColumnSize: CGSize = (timeTitle as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
        let timeColumnWidth: CGFloat = timeColumnSize.width + marginForTimeColumn
        
        return timeColumnWidth
    }
}