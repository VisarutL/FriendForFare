//
//  FriendViewCell.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

protocol FriendViewCellDelegate:class {
    func friendViewCellDidConfirm(index:NSIndexPath)
    func friendViewCellDidDelete(index:NSIndexPath)
}
class FriendViewCell:UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    var indexPath = NSIndexPath()
    
    weak var delegate:FriendViewCellDelegate?
    
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

    @IBAction func confirmAction(_ sender: Any) {
        delegate?.friendViewCellDidConfirm(index: indexPath)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        delegate?.friendViewCellDidDelete(index: indexPath)
    }
}

extension FriendViewCell {
    
    
    func setProfileImage() {
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.layer.borderWidth = 2
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.backgroundColor = UIColor.backgroundImage
        //        self.profileImage.image = UIImage(named: "ic_defalut_user_160_white")
    }
}
