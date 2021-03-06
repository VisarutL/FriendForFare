//
//  ReviewViewCell.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class ReviewUserViewCell:UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var comemtLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateImage: UIImageView!
    @IBOutlet weak var journeyReviewLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setProfileImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "userprofile")
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
    
    func setRateImageGirl(rate:Int) {
        var imageName = String()
        switch rate {
        case 1:
            imageName = "rate-g-1"
        case 2:
            imageName = "rate-g-2"
        case 3:
            imageName = "rate-g-3"
        case 4:
            imageName = "rate-g-4"
        case 5:
            imageName = "rate-g-5"
        default:
            imageName = "rate-g-0"
        }
        rateImage.image = UIImage(named: imageName)
    }
    
    func setRateImage(rate:Int) {
        var imageName = String()
        switch rate {
        case 1:
            imageName = "rate-1"
        case 2:
            imageName = "rate-2"
        case 3:
            imageName = "rate-3"
        case 4:
            imageName = "rate-4"
        case 5:
            imageName = "rate-5"
        default:
            imageName = "rate-0"
        }
        rateImage.image = UIImage(named: imageName)
    }
}

