//
//  ClassTableViewController.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 02.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation
import UIKit

class ClassTableViewController: UITableViewController {
    @IBOutlet var classTableView: UITableView!
    
    var classMenu = [
        "1. Klasse",
        "2. Klasse",
        "3. Klasse",
        "4. Klasse"
        ]
    
    let cellIdentifier = "ClassCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = classTableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        
        //createClassArray()
        cell.textLabel?.text = self.classMenu[indexPath.row]
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("class", comment: "TransForClassSelHeader")
    }
    
    /**
    Returns Array with appropriate Names for Class Menu
    */
//    func createClassArray() {
//        for var i = 1; i <= 4; ++i {
//            var classString = String(i)
//            classString.appendContentsOf(". ")
//            classString.appendContentsOf(NSLocalizedString("class", comment: "TransForClassSel"))
//            
//            self.classMenu.addObject(classString)
//        }
//    }
}