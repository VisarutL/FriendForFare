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
    
    var dateFormatter = DateFormatter()
    var fristTime = true
    
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
        tableView?.rowHeight = 80
        setPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleRefresh()
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
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
        } else {
        let friendrequest = friendrequestList[indexPath.row]
            cell.nameLabel.text = "\(friendrequest["fname_user"]!) \(friendrequest["lname_user"]!)"
            guard let imageName = friendrequest["pic_user"] as? String ,imageName != "" else {
                return cell
            }
            
            let path = "http://localhost/friendforfare/images/"
            if let url = NSURL(string: "\(path)\(imageName)") {
                if let data = NSData(contentsOf: url as URL) {
                    DispatchQueue.main.async {
                        cell.profileImage.image = UIImage(data: data as Data)
                    }
                    
                }
            }
        }
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendrequestList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileFriendTabBarController") as! ProfileFriendTabBarController
        vc.myText = "FriendRequest"
        vc.friend = friendrequestList[indexPath.row] as! [String : Any]
        let nvc = NavController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
    }
}

extension FriendRequestListViewController {
    
    func handleRefresh() {
        
        if fristTime {
            
            fristTime = false
            self.friendrequestList = [NSDictionary]()
            let userID = UserDefaults.standard.integer(forKey: "UserID")
            selectData(iduser: userID)
            
        }
        
    }
    
    func selectData(iduser:Int) {
        let parameters: Parameters = [
            "function": "friendrequestSelect",
            "iduser": iduser
        ]
        let url = "http://localhost/friendforfare/get/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
                switch response.result {
                case .success:
                
                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    for friendrequest in JSON as! NSArray {
                        self.friendrequestList.append(friendrequest as! NSDictionary)
                    }
                }
                let now = NSDate()
                let updateString = "Last Update at " + self.dateFormatter.string(from: now as Date)
                self.refreshControl?.attributedTitle = NSAttributedString(string: updateString)
                
                DispatchQueue.main.async {
                    self.fristTime = true
                    
                    if let refreshControl = self.refreshControl {
                        if refreshControl.isRefreshing {
                            refreshControl.endRefreshing()
                        }
                    }
                    
                    self.tableView?.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func setPullToRefresh() {
        self.tableView.delegate = self
        self.dateFormatter.dateStyle = DateFormatter.Style.short
        self.dateFormatter.timeStyle = DateFormatter.Style.long
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //        self.refreshControl?.backgroundColor = UIColor.tabbarColor
        //        self.refreshControl?.tintColor = UIColor.white
        
        let selector = #selector(self.handleRefresh)
        self.refreshControl?.addTarget(self,
                                       action: selector,
                                       for: UIControlEvents.valueChanged)
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
        let userID = user["id_user"] as? String ?? "1"
        
        let alertController = UIAlertController(title: "", message: "Are you sure to remove.", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let ok = UIAlertAction(title: "OK", style: .default,handler: {
            _ in
            self.updateFriendRequest(userID: userID,status:"2",index: index)
        })
        
        alertController.addAction(cancel)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
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
        let url = "http://localhost/friendforfare/update/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
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
//                    print(JSON)
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

