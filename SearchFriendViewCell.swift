//
//  SearchFriendViewCell.swift
//  FriendForFare
//
//  Created by Visarut on 1/25/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit

protocol SearchFriendViewCellDelegate:class {
    func searchFriendViewCellDidAdd(index:NSIndexPath)
}
class SearchFriendViewCell:UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    var indexPath = NSIndexPath()
    weak var delegate:SearchFriendViewCellDelegate?
    
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
    
    @IBAction func addFriendAction(_ sender: Any) {
        delegate?.searchFriendViewCellDidAdd(index:indexPath)
    }
    
//    @IBAction func confirmAction(_ sender: Any) {
//        delegate?.searchFriendViewCellDidConfirm(index: indexPath)
//    }
//    
//    @IBAction func deleteAction(_ sender: Any) {
//        delegate?.searchFriendViewCellDidDelete(index: indexPath)
//    }
}

extension SearchFriendViewCell {
    
    func setProfileImage() {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
            self.profileImage.clipsToBounds = true
        }
    }
}
