//
//  CustomCollectionViewLayout.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 25/10/2015.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class TTCollectionViewLayout: UICollectionViewLayout {
    
    
    var itemAttributes: NSMutableArray!
    // Array of index Widths assigned by calculateItemWidths
    var itemsWidth: NSMutableArray!
    // ContentSize for entire Table
    var contentSize: CGSize!
    var numberOfColumns = 6
    
    let marginForTimeColumn: CGFloat = 15
    let heightForDayRow: CGFloat = 40
    
    override func prepareLayout() {
        
        if self.collectionView?.numberOfSections() == 0 {
            return
        }
        
        /*if (self.itemAttributes != nil && self.itemAttributes.count > 0) {
            
            for section in 0 ..< self.collectionView!.numberOfSections() {
                let numberOfItems: Int = self.collectionView!.numberOfItemsInSection(section)
                for index in 0 ..< numberOfItems {
                    if section != 0 && index != 0 {
                        continue
                    }
                    
                    let attributes: UICollectionViewLayoutAttributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: index, inSection: section))
                    if section == 0 {
                        //var frame = attributes.frame
                        //frame.origin.y = self.collectionView!.contentOffset.y
                        //attributes.frame = frame
                        
                        attributes.frame.origin.y = self.collectionView!.contentOffset.y
                    }
                    
                    if index == 0 {
                        //var frame = attributes.frame
                        //frame.origin.x = self.collectionView!.contentOffset.x
                        //attributes.frame = frame
                        
                        attributes.frame.origin.x = self.collectionView!.contentOffset.x
                    }
                }
            }
            return
        }*/
        
        if (self.itemsWidth == nil || self.itemsWidth.count != numberOfColumns) {
            self.calculateItemsSize()
        }
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        
        //Width of Entire Table
        var contentWidth: CGFloat = 0
        //Height of Entire Table
        var contentHeight: CGFloat = 0
        
        for section in 0 ..< self.collectionView!.numberOfSections() {
            
            // Attributes of a single section
            let sectionAttributes = NSMutableArray()
            
            // Height of a single Section
            var itemHeight: CGFloat
            
            if section == 0 {
                itemHeight = 30
            } else {
                itemHeight = 60
            }
            
            
            for index in 0 ..< numberOfColumns {
                //Width of a single Column
                let itemWidth = self.itemsWidth[index] as! CGFloat
                
                // IndexPath created for every index and Section
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                
                // Attributes of a single Cell with the current section and index
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                // Assigning provisional Position and Size of each cell as attribute.frame
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemWidth, itemHeight))
                
                // Determining zIndexes (higher means more in front)
                if section == 0 && index == 0 {
                    attributes.zIndex = 3
                } else  if section == 0 || index == 0 {
                    attributes.zIndex = 2
                }
                
                if section == 0 {
                    //var frame = attributes.frame
                    //frame.origin.y = self.collectionView!.contentOffset.y
                    //attributes.frame = frame
                    
                    attributes.frame.origin.y = self.collectionView!.contentOffset.y
                }
                if index == 0 {
                    //var frame = attributes.frame
                    //frame.origin.x = self.collectionView!.contentOffset.x
                    //attributes.frame = frame
                    
                    attributes.frame.origin.x = self.collectionView!.contentOffset.x
                }
                
                sectionAttributes.addObject(attributes)
                
                xOffset += itemWidth
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
        
        let lastAttribute: UICollectionViewLayoutAttributes = self.itemAttributes.lastObject?.lastObject as! UICollectionViewLayoutAttributes
        contentHeight = lastAttribute.frame.origin.y + lastAttribute.frame.size.height
        self.contentSize = CGSizeMake(contentWidth, contentHeight)
    }
    
    /**
    Returning Size for the entire CollectionView
    */
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
                    
                    NSPredicate(block: {
                        (evaluatedObject, bindings) -> Bool in
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
    
    // MARK: CALCULATING SIZE FOR CELLS
    
    /**
    Calculates a optimal width for a section relative to the display size
    */
    func widthForItemWithColumnIndex(sectionIndex: Int) -> CGFloat {
        
        let timeColumnWidth: CGFloat = getTimeColumnWidth()
        
        if sectionIndex != 0 {
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let width: CGFloat = (screenSize.width - timeColumnWidth)
            
            return width
            
        } else {

            return timeColumnWidth
        }
    }
    
    /**
    Appends for each Column a fitting Value to self.itemsWidth
    */
    func calculateItemsSize() {
        self.itemsWidth = NSMutableArray(capacity: numberOfColumns)
        for var section = 0; section < numberOfColumns; ++section {
            
            self.itemsWidth.addObject(self.widthForItemWithColumnIndex(section))
        }
    }
    
    /**
    Calculates the Width of the time section by adding a Margin to the "Time" String
    */
    func getTimeColumnWidth() -> CGFloat {
        
        let timeTitle = NSLocalizedString("time", comment: "TimeTransForSizeCalculation")
        let timeColumnSize: CGSize = (timeTitle as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
        let timeColumnWidth: CGFloat = timeColumnSize.width + marginForTimeColumn
        
        return timeColumnWidth
    }
}