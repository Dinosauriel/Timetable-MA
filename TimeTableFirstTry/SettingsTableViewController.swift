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
    
    let showHiSegueIdentifier = "showHiSegue"
    let showClassSegueIdentifier = "showClassSelect"
    
    let settingsMainMenu = [
        NSLocalizedString("login", comment: "loginTrans"),
        NSLocalizedString("notifications", comment: "noteTrans"),
        NSLocalizedString("widget", comment: "widTrans")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.performSegueWithIdentifier(showHiSegueIdentifier, sender: self)
            }
        } else {
            if indexPath.row == 0 {
                self.performSegueWithIdentifier(showClassSegueIdentifier, sender: self)
            }
            
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
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
        
        if indexPath.section == 0 {
            cell.textLabel?.text = settingsMainMenu[indexPath.row]
        } else {
            cell.textLabel?.text = NSLocalizedString("class", comment: "TransForSettingsClass")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        settingsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}