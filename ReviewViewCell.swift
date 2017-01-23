//
//  ReviewViewCell.swift
//  FriendForFare
//
//  Created by Visarut on 12/12/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class ReviewViewCell:UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setProfileImage()
        
    }
    
    func setProfileImage() {
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.layer.borderWidth = 2
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.backgroundColor = UIColor.backgroundImage
        //        self.profileImage.image = UIImage(named: "ic_defalut_user_160_white")
    }
    
//    func setRateImage(rate:Int) {
//        var imageName = String()
//        switch rate {
//        case 0:
//            imageName = "rate-0"
//        case 3:
//            imageName = "rate-3"
//        default:
//            imageName = "rate-4-half"
//        }
//        setRateImage.image = UIImage(named: imageName)
//    }
}

