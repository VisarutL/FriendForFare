//
//  FriendRequestListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FriendRequestListViewController:UITableViewController {
    
    let friendRequestViewCelldentifier = "Cell"
    let friendRequestViewCell = "FriendRequestViewCell"
    var itemInfo = IndicatorInfo(title: "New")
    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: friendRequestViewCell, bundle: nil), forCellReuseIdentifier: friendRequestViewCelldentifier)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: friendRequestViewCelldentifier, for: indexPath) as! FriendRequestViewCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.delegate = self
        cell.indexPath = indexPath as NSIndexPath
        cell.nameLabel.text = "FullName"
        cell.usernameLabel.text = "Username"
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("row \(indexPath.row)")
    }
}

extension FriendRequestListViewController:FriendRequestViewCellDelegate {
    func friendRequestViewCellDidConfirm(index:NSIndexPath) {
        let index = String(describing: index)
        print(index)
    }
    
    func friendRequestViewCellDidDelete(index:NSIndexPath) {
        let index = String(describing: index)
        print(index)
    }
}

extension FriendRequestListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

