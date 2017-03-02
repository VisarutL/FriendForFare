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
        setProfileImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "userprofile")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
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
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
            self.profileImage.clipsToBounds = true
        }
    }
}
