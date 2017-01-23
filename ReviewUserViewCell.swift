//
//  ReviewViewCell.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class ReviewUserViewCell:UITableViewCell {
    
    
    @IBOutlet weak var genderImageview: UIImageView!
    @IBOutlet weak var comemtLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateImage: UIImageView!
    
    
    
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
        self.genderImageview.layer.cornerRadius = self.genderImageview.bounds.size.height / 2
        self.genderImageview.layer.borderWidth = 2
        self.genderImageview.layer.borderColor = UIColor.white.cgColor
        self.genderImageview.backgroundColor = UIColor.backgroundImage
        //        self.profileImage.image = UIImage(named: "ic_defalut_user_160_white")
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
}

