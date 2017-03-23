//
//  RoundedButton.swift
//  FriendForFare
//
//  Created by TAFCloud on 3/22/17.
//  Copyright © 2017 Newfml. All rights reserved.
//

import UIKit
class ExitButton:UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            switch isHighlighted {
            case true:
                backgroundColor = .clear
                alpha = 0.5
            case false:
                backgroundColor = .clear
                alpha = 1.0
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        layer.cornerRadius = self.bounds.size.height / 2
        layer.masksToBounds = true
    }
    
    
    

    
    
}
