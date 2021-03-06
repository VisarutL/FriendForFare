//
//  FriendListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class FriendListViewController:UITableViewController {
    
    let friendViewCelldentifier = "Cell"
    let friendViewCell = "FriendViewCell"
    var friendList = [NSDictionary]()
    
    var dateFormatter = DateFormatter()
    var fristTime = true
    
    var itemInfo = IndicatorInfo(title: "New")
    
    var deleteID:Int?
    
    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: friendViewCell, bundle: nil), forCellReuseIdentifier: friendViewCelldentifier)
        tableView?.rowHeight = 90
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
        if friendList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell") ??
                UITableViewCell(style: .default, reuseIdentifier: "emptyCell")
            cell.textLabel?.text = "ยังไม่มีเพื่อน"
            cell.textLabel?.textColor = UIColor.gray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none;
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: friendViewCelldentifier, for: indexPath) as! FriendViewCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let friend = friendList[indexPath.row]
        cell.nameLabel.text = "\(friend["fname_user"]!) \(friend["lname_user"]!)"
        cell.usernameLabel.text = "\(friend["username_user"]!)"
        cell.countjoinLabel.text = "Count: \(friend["counttrip"]!)"
        
        guard let imageName = friend["pic_user"] as? String ,imageName != "" else {
            return cell
        }
        
        let path = "\(URLbase.URLbase)friendforfare/images/"
        if let url = NSURL(string: "\(path)\(imageName)") {
            if let data = NSData(contentsOf: url as URL) {
                DispatchQueue.main.async {
                    cell.profileImage.image = UIImage(data: data as Data)
                }
                
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friendList.count == 0 {
            return 1
        }
        return friendList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if friendList.isEmpty == true {
            
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileFriendTabBarController") as! ProfileFriendTabBarController
            vc.myText = "Friend"
            vc.friend = friendList[indexPath.row] as! [String : Any]
            
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .overFullScreen
            nvc.modalTransitionStyle = .crossDissolve
            present(nvc, animated: true, completion: nil)
        }
    }
    
    
}


extension FriendListViewController {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //        let cell = tableView.cellForRow(at: indexPath)
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let friend = friendList[indexPath.row]
            let username = friend["username_user"] as! String
            self.deleteID = indexPath.row
            confirmDelete(name: username)
        }
    }
    
    func confirmDelete(name: String) {
        let alert = UIAlertController(title: "Delete Friend", message: "Are you sure to reject request \(name)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDelete)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDelete)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        let cgRectMake = CGRect(x: self.view.bounds.size.width / 2.0, y:self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        alert.popoverPresentationController?.sourceRect = cgRectMake
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDelete(alertAction: UIAlertAction!) -> Void {
        deleteFriend()
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        self.deleteID = nil
    }
    
    func deleteFriend() {
        guard let deleteID = deleteID else { return }
        let friend = friendList[deleteID]
        let id = friend["id_user"] as! String
        let parameters: Parameters = [
            "function": "deleteFriend",
            "userid" : id
        ]
        let url = "\(URLbase.URLbase)friendforfare/delete/index.php?function=deleteFriend"
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
                    print(JSON)
                    self.friendList.remove(at: deleteID)
                    self.deleteID = nil
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

extension FriendListViewController {
    
    func handleRefresh() {
        
        if fristTime {
            
            fristTime = false
            self.friendList = [NSDictionary]()
            let userID = UserDefaults.standard.integer(forKey: "UserID")
            selectData(iduser: userID)
            
        }
        
    }
    
    //    func loadData() {
    //        selectData()
    //
    //    }
    
    func selectData(iduser:Int) {
        let parameters: Parameters = [
            "function": "friendSelect",
            "iduser": iduser
        ]
        let url = "\(URLbase.URLbase)friendforfare/get/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //                debugPrint(response)
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        //                    print("JSON: \(JSON)")
                        for friend in JSON as! NSArray {
                            self.friendList.append(friend as! NSDictionary)
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

extension FriendListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

