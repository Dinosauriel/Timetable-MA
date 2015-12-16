//
//  CustomCollectionViewLayout.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 25/10/2015.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class TTCollectionViewLayout: UICollectionViewFlowLayout {
    
    //MARK: VARIOUS OBJECTS
    var itemAttributes: NSMutableArray!
    var itemsWidth: NSMutableArray!     // Array of index Widths assigned by calculateItemWidths
    var contentSize: CGSize!            // Size for entire Table
    
    //MARK: CGFloats
    var numberOfDaysOnScreen: CGFloat = 1
    let heightForDayRow: CGFloat = 40
    
    let marginForTimeColumn: CGFloat = 15
    let marginBetweenRows: CGFloat = 2
    let marginBetweenWeeks: CGFloat = 10

    //MARK: INTEGERS
    var numberOfColumns: Int = 6
    let numberOfDaysInWeek: Int = 5
    
    
    
    /**
    Assigning the proper Values to the Variables
    */
    override func prepareLayout() {
        
        // Cancel layout if there are no Sections in collectionView
        if self.collectionView?.numberOfSections() == 0 {
            return
        }
        
        // Check if itemAttributes exists
        if (self.itemAttributes != nil && self.itemAttributes.count > 0) {
            
            for section in 0 ..< self.collectionView!.numberOfSections() {
                let numberOfItems: Int = self.collectionView!.numberOfItemsInSection(section)
                for index in 0 ..< numberOfItems {
                    //Skip iteration if not in first row or column
                    if section != 0 && index != 0 {
                        continue
                    }
                    
                    //Get Attributes for current Cell
                    let attributes: UICollectionViewLayoutAttributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: index, inSection: section))
                    
                    //Position first row at the current yOffset of collectionView
                    if section == 0 {
                        attributes.frame.origin.y = self.collectionView!.contentOffset.y
                    }
                    
                    //Position first column at the current xOffset of collectionView
                    if index == 0 {
                        attributes.frame.origin.x = self.collectionView!.contentOffset.x
                    }
                }
            }
            return
        }
        
        // Refresh ItemsWidth if necessary
        if (self.itemsWidth == nil || self.itemsWidth.count != numberOfColumns) {
            self.calculateItemsWidth()
        }
        
        var column = 0              // temporary column for Attribute setup
        var xOffset: CGFloat = 0    // temporary x for Attribute setup
        var yOffset: CGFloat = 0    // temporary y for Attribute setup
        
        var contentWidth: CGFloat = 0          //Width of Entire Table only for this Function
        var contentHeight: CGFloat = 0         //Height of Entire Table only for this Function
        
        for section in 0 ..< self.collectionView!.numberOfSections() {
            
            let sectionAttributes = NSMutableArray()    // Attributes of a single section
            
            var itemHeight: CGFloat                     // Height of a single Section
            
            //First row is thinner
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
                
                //Assigning absolute y-Values to all items in section 0
                if section == 0 {
                    
                    attributes.frame.origin.y = self.collectionView!.contentOffset.y
                }
                
                //Assigning absolute x-Values to all items in index 0
                if index == 0 {
                    
                    attributes.frame.origin.x = self.collectionView!.contentOffset.x
                }
                
                //Adding the Calculated Attributes to the sectionAttributes Array
                sectionAttributes.addObject(attributes)
                
                // Updating xOffset for next row in this section
                xOffset += itemWidth
                
                // Add small margin between two days
                if column != 0 && column != (numberOfColumns - 1 ) {
                    xOffset += marginBetweenRows
                }
                
                // Add big margin between two weeks
                if column % numberOfDaysInWeek == 0 && column != (numberOfColumns - 1) && column != 0 {
                    
                    xOffset -= marginBetweenRows
                    xOffset += marginBetweenWeeks
                }
                
                // Updating column for next row in this section
                ++column
                
                if column == numberOfColumns {
                    // Adapting ContentWidth if necessairy
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    //Setting column and xOffset to 0 to prepare for the next section
                    column = 0
                    xOffset = 0
                    // Adapting yOffset for next section
                    yOffset += itemHeight
                }
            }
            
            //Initializing itemAttributes if necessairy
            if (self.itemAttributes == nil) {
                self.itemAttributes = NSMutableArray(capacity: self.collectionView!.numberOfSections())
            }
            
            // Append Attributes of entire Section to itemAttributes
            self.itemAttributes.addObject(sectionAttributes)
        }
        
        //Get the last Cell in the CollectionView in order to adapt the contentHeight
        let lastAttribute: UICollectionViewLayoutAttributes = self.itemAttributes.lastObject?.lastObject as! UICollectionViewLayoutAttributes
        contentHeight = lastAttribute.frame.origin.y + lastAttribute.frame.size.height
        
        //Aplying width and height to contentSize
        self.contentSize = CGSizeMake(contentWidth, contentHeight)
    }
    
    /**
    Returning Size for the entire CollectionView
    */
    override func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }
    
    /**
    Returning the Attributes that were created in prepareLayout()
    */
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        return self.itemAttributes[indexPath.section][indexPath.row] as! UICollectionViewLayoutAttributes
    }
    
    /**
    Filter self.itemAttributes for rect and return fitting attributes
    */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        if self.itemAttributes != nil {
            for section in self.itemAttributes {
                
                // Filters all the CGRects that intersect with the rect parameter of the function
                let filterPredicate = NSPredicate(block:
                    {
                        (evaluatedObject, bindings) -> Bool in
                        return CGRectIntersectsRect(rect, evaluatedObject.frame)
                    }
                )
                
                // Filtering self.itemAttributes with the predicate
                let attributesInSectionInRect = section.filteredArrayUsingPredicate(filterPredicate) as! [UICollectionViewLayoutAttributes]
                
                attributesInRect.appendContentsOf(attributesInSectionInRect)
                
            }
        }
        
        return attributesInRect
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    // MARK: CALCULATING SIZE FOR CELLS
    /**
    Calculates a optimal width for a section relative to the display size
    */
    func widthForItemWithColumn(column: Int) -> CGFloat {
        
        let timeColumnWidth: CGFloat = getTimeColumnWidth()
        if column != 0 {
            let width: CGFloat
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            if UIApplication.sharedApplication().statusBarOrientation == .Portrait {
                width = (screenSize.width - timeColumnWidth) / numberOfDaysOnScreen
            } else {
                width = (screenSize.height - timeColumnWidth) / numberOfDaysOnScreen
            }
            return width
            
        } else {

            return timeColumnWidth
        }
    }
    
    /**
    Appends a fitting Value to self.itemsWidth for each Column
    */
    func calculateItemsWidth() {
        self.itemsWidth = NSMutableArray(capacity: numberOfColumns)
        for section in 0 ..< numberOfColumns {
            
            self.itemsWidth.addObject(self.widthForItemWithColumn(section))
        }
    }
    
    /**
    Calculates the Width of the time column by adding a Margin to the "Time" String
    */
    func getTimeColumnWidth() -> CGFloat {
        
        let timeTitle = NSLocalizedString("time", comment: "TimeTransForSizeCalculation")
        let timeColumnSize: CGSize = (timeTitle as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
        let timeColumnWidth: CGFloat = timeColumnSize.width + marginForTimeColumn
        
        return timeColumnWidth
    }
}