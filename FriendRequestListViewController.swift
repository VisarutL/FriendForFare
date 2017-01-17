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
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
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
        if friendrequestList.count == 0 {
            cell.nameLabel.text = "name"
            cell.usernameLabel.text = "username"
        } else {
        let friendrequest = friendrequestList[indexPath.row]
            cell.nameLabel.text = "\(friendrequest["fname_user"]!) \(friendrequest["lname_user"]!)"
            cell.usernameLabel.text = "\(friendrequest["username_user"]!)"
        }
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension FriendRequestListViewController:FriendRequestViewCellDelegate {
    func friendRequestViewCellDidConfirm(index:NSIndexPath) {
        let user = friendrequestList[index.row]
        let userID = user["id_user"] as? String
        updateFriendRequest(userID: userID!,status:"1",index: index)
    }
    
    func friendRequestViewCellDidDelete(index:NSIndexPath) {
        let user = friendrequestList[index.row]
        let userID = user["id_user"] as? String
        updateFriendRequest(userID: userID!,status:"2",index: index)
    }
}

extension FriendRequestListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

extension FriendRequestListViewController {
    func updateFriendRequest(userID:String,status:String,index:NSIndexPath) {
        
        let parameters: Parameters = [
            "function": "updateFriendRequest",
            "userid" : userID,
            "status" : status
        ]
        let url = "http://worawaluns.in.th/friendforfare/update/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                debugPrint(response)
                switch response.result {
                case .success:
                    
                    guard let JSON = response.result.value as! [String : Any]? else {
                        print("error: cannnot cast result value to JSON or nil.")
                        return
                    }
                    
                    let status = JSON["status"] as! String
                    if  status == "404" {
                        print("error: \(JSON["message"] as! String)")
                        return
                    }
                    
                    //status 202
                    print(JSON)
                    let row = index.row
                    self.friendrequestList.remove(at: row)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        //alert
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }

}

