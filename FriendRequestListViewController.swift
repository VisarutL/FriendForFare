//
//  FriendRequestListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class FriendRequestListViewController:UITableViewController {
    
    let friendRequestViewCelldentifier = "Cell"
    let friendRequestViewCell = "FriendRequestViewCell"
    var itemInfo = IndicatorInfo(title: "New")
    var friendrequestList = [NSDictionary]()
    
    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectData();
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
        
        let friendrequest = friendrequestList[indexPath.row]
        cell.nameLabel.text = "\(friendrequest["fname_user"]!) \(friendrequest["lname_user"]!)"
        cell.usernameLabel.text = "\(friendrequest["username_user"]!)"
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendrequestList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("row \(indexPath.row)")
    }
}

extension FriendRequestListViewController {
    //    (completionHandler:@escaping (_ r:[Region]?
    
    func selectData() {
        Alamofire.request("http://worawaluns.in.th/friendforfare/get/index.php?function=friendrequestSelect").responseJSON { response in
            switch response.result {
            case .success:
                
                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    for friendrequest in JSON as! NSArray {
                        self.friendrequestList.append(friendrequest as! NSDictionary)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
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

