//
//  SettingsTableViewController.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 14.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    //MARK: OUTLETS
    @IBOutlet var settingsTableView: UITableView!
    
    //MARK: CLASSES
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: STRINGS
    let settingsMainMenuCellIdentifier = "settingsMainMenuCellIdentifier"
    let userInfoCellIdentifier = "userInfoCell"
    let showLoginSegueIdentifier = "showLoginSegue"
    let showFirstLaunchSegueIdentifier = "showFLPVC"
    
    //MARK: ARRAYS
    let settingsMainMenu = [NSLocalizedString("login", comment: "loginTrans")]
    
    let numberOfColumnsInSection: [Int] = [2,1]
    let sectionTitles: [String] = [
        NSLocalizedString("general", comment: "TransForSettingsTitle"),
        NSLocalizedString("other", comment: "TransForSettingsTitle")
        ]
    
    /**
    View did load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
    Reloading date when view appears.
    */
    override func viewWillAppear(animated: Bool) {
        self.settingsTableView.reloadData()
    }
    
    /**
    Go to login if first row is pressed
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.performSegueWithIdentifier(showLoginSegueIdentifier, sender: self)
            }
        } else {
            if indexPath.row == 0 {
                self.performSegueWithIdentifier(showFirstLaunchSegueIdentifier, sender: self)
            }
        }
    }
    
    /**
    One section in tableView
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    /**
    Two rows in tableView
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfColumnsInSection[section]
    }
    
    /**
    60 points distance between sections
    */
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    /**
    Assign title to section one
    */
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    /**
    Assign the given cells to the indexPath
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //Normal Cell
                let cell = settingsTableView.dequeueReusableCellWithIdentifier(settingsMainMenuCellIdentifier, forIndexPath: indexPath) as UITableViewCell
                cell.textLabel?.text = settingsMainMenu[indexPath.row]
                return cell
            } else {
                //UserInfo Cell
                let cell = settingsTableView.dequeueReusableCellWithIdentifier(userInfoCellIdentifier) as! UserInfoCell
                cell.infoCell.text = NSLocalizedString("loginState", comment: "noob")
                cell.firstNameCell.text = userDefaults.valueForKey("userfirstname") as? String
                cell.lastNameCell.text = userDefaults.valueForKey("userlastname") as? String
                return cell
            }
        } else {
            let cell = settingsTableView.dequeueReusableCellWithIdentifier(settingsMainMenuCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = NSLocalizedString("showFL", comment: "TransForSettings")
            return cell
        }
    }
}