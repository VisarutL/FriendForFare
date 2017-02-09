//
//  SectionHeaderView.swift
//  FriendForFare
//
//  Created by Visarut on 2/9/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.tabbarColor
    }
    
    
}
