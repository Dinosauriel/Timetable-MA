//
//  SettingsTableViewController.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 14.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet var settingsTableView: UITableView!
    
    let settingsMainMenuCellIdentifier = "settingsMainMenuCellIdentifier"
    
    let settingsMainMenu = [
        NSLocalizedString("login", comment: "loginTrans"),
        NSLocalizedString("notifications", comment: "noteTrans"),
        NSLocalizedString("widget", comment: "widTrans")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("general", comment: "TransForSettingsTitle")
        } else {
            return NSLocalizedString("app", comment: "TransForSettingsTitle")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCellWithIdentifier(settingsMainMenuCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = settingsMainMenu[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        settingsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}