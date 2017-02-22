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
    
    var isOptionButtonEnable = Bool() {
        didSet {
            if isOptionButtonEnable {
                let image = UIImage(named: "Down1")
                optionButton.setImage(image, for: .normal)
            } else {
                let image = UIImage(named: "Up1")
                optionButton.setImage(image, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.tabbarColor
    }
    
    
    
}
