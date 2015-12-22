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
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    let settingsMainMenuCellIdentifier = "settingsMainMenuCellIdentifier"
    let userInfoCellIdentifier = "userInfoCell"
    
    let showLoginSegueIdentifier = "showLoginSegue"
    
    let settingsMainMenu = [
        NSLocalizedString("login", comment: "loginTrans"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        self.settingsTableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.performSegueWithIdentifier(showLoginSegueIdentifier, sender: self)
            }
        } else {
            
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("general", comment: "TransForSettingsTitle")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = settingsTableView.dequeueReusableCellWithIdentifier(settingsMainMenuCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = settingsMainMenu[indexPath.row]
            return cell
        } else {
            let cell = settingsTableView.dequeueReusableCellWithIdentifier(userInfoCellIdentifier) as! UserInfoCell
            cell.infoCell.text = NSLocalizedString("loginState", comment: "noob")
            cell.firstNameCell.text = userDefaults.valueForKey("userfirstname") as? String
            cell.lastNameCell.text = userDefaults.valueForKey("userlastname") as? String
            return cell
        }
    }
        
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            self.performSegueWithIdentifier(showLoginSegueIdentifier, sender: nil)
        }
        settingsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}