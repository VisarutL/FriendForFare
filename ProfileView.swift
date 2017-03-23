//
//  ProfileView.swift
//  FriendForFare
//
//  Created by TAFCloud on 3/21/17.
//  Copyright © 2017 Newfml. All rights reserved.
//


import UIKit

protocol ProfileViewDelegate:class {
    func profileViewDidLogout()
}

class ProfileView:UIView {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var rateImage: UIImageView!
    @IBOutlet weak var rateImageGirl: UIImageView!
    
    var showLogout = false
    
    weak var delegate:ProfileViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fullnameLabel.text = "full name."
        telLabel.text = "telephone."
        emailLabel.text = "mail."
        profileImage.image = UIImage(named: "userprofile")
        setProfileImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        delegate?.profileViewDidLogout()
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
        rateImageGirl.image = UIImage(named: imageName)
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
    
    
    func setProfileImage() {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
            self.profileImage.clipsToBounds = true
        }
    }
}

