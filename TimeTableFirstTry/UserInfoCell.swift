//
//  UserInfoCell.swift
//  Timetable App
//
//  Created by Aurel Feer on 22.12.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import Foundation
import UIKit

/**
Cell that contains the three labels needed to display user information
*/
class UserInfoCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var infoCell: UILabel!
    @IBOutlet weak var firstNameCell: UILabel!
    @IBOutlet weak var lastNameCell: UILabel!
}
