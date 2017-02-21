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
        profileImage.image = UIImage(named: "userprofile")
        
    }
    
    func setProfileImage() {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
            self.profileImage.clipsToBounds = true
        }
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

