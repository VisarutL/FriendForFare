//
//  ProfileViewCell.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate:class {
    func profileViewDidLogout()
}

class ProfileViewCell:UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var rateImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var showLogout = false
    
    weak var delegate:ProfileViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setLogoutHidden()
        setProfileImage()
        setLogoutButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        setProfileImage()
        fullnameLabel.text = "full name."
        telLabel.text = "telephone."
        emailLabel.text = "mail."
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if showLogout {
            logoutButton.isUserInteractionEnabled = true
            logoutButton.isHidden = false
        }
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        delegate?.profileViewDidLogout()
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
    
    func setLogoutButton() {
        self.logoutButton.layer.cornerRadius = self.logoutButton.bounds.size.height / 2
        self.logoutButton.clipsToBounds = true
    }
    
    func setProfileImage() {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
            self.profileImage.clipsToBounds = true
        }
    }
    
    func setLogoutHidden() {
        logoutButton.isUserInteractionEnabled = false
        logoutButton.isHidden = true
    }
}
