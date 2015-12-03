//
//  SubClassTableViewController.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 02.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation
import UIKit

class SubClassTableViewController: UITableViewController {
    @IBOutlet var subclassTableView: UITableView!
    
    var classMenu = [
        "1. Klasse",
        "2. Klasse",
        "3. Klasse",
        "4. Klasse"
    ]
    
    let segueIdentifier = "showMainMenu"
    let cellIdentifier = "subclassCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = subclassTableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        
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
    }}