//
//  CheckListViewCell.swift
//  FriendForFare
//
//  Created by Visarut on 3/15/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit

class CheckListViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setProfileImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setProfileImage() {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
            self.profileImage.clipsToBounds = true
        }
    }
    
}
