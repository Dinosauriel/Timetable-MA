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
        NSLocalizedString("firstclass", comment: "transForClassSelection"),
        NSLocalizedString("secondclass", comment: "transForClassSelection"),
        NSLocalizedString("thirdclass", comment: "transForClassSelection"),
        NSLocalizedString("fourthclass", comment: "transForClassSelection")
        ]
    
    let cellIdentifier = "ClassCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = classTableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        
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

}