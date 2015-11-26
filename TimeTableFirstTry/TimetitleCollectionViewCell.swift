//
//  ContentCollectionViewCell.swift
//  CustomCollectionLayout
//
//  Created by Aurel Feer on 25/10/2015.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class TimetitleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timetitleLabel: UILabel!
    
    @IBOutlet weak var dividingView: UIView!
    @IBOutlet weak var vertDividingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
