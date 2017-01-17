//
//  ProfileViewCell.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class ProfileViewCell:UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var rateImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setProfileImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setProfileImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setProfileImage()
        
    }
    
    
    func setRateImage(rate:Int) {
        var imageName = String()
        switch rate {
        case 0:
            imageName = "rate-0"
        case 3:
            imageName = "rate-3"
        default:
            imageName = "rate-4-half"
        }
        rateImage.image = UIImage(named: imageName)
    }
    func setProfileImage() {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
            self.profileImage.layer.borderWidth = 2
            self.profileImage.layer.borderColor = UIColor.white.cgColor
            self.profileImage.clipsToBounds = true
        }
        
//        self.profileImage.backgroundColor = UIColor.lightGray
        //        self.profileImage.image = UIImage(named: "ic_defalut_user_160_white")
    }
}
