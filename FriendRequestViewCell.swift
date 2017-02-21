//
//  FriendRequestViewCell.swift
//  FriendForFare
//
//  Created by Visarut on 12/18/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

protocol FriendRequestViewCellDelegate:class {
    func friendRequestViewCellDidConfirm(index:NSIndexPath)
    func friendRequestViewCellDidDelete(index:NSIndexPath)
}
class FriendRequestViewCell:UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    
    
    var indexPath = NSIndexPath()
    
    weak var delegate:FriendRequestViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setProfileImage()
        removeButtonSetting()
        profileImage.image = UIImage(named: "userprofile")
    }
    @IBAction func confirmAction(_ sender: Any) {
        delegate?.friendRequestViewCellDidConfirm(index: indexPath)
    }
    @IBAction func deleteAction(_ sender: Any) {
        delegate?.friendRequestViewCellDidDelete(index: indexPath)
    }
}

extension FriendRequestViewCell {
    
    
    func setProfileImage() {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
            self.profileImage.clipsToBounds = true
        }
    }
    
    func removeButtonSetting() {
        self.removeButton.layer.borderWidth = 1
        self.removeButton.layer.borderColor = UIColor.darkGray.cgColor
    }
}

