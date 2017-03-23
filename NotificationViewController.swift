//
//  NotificationViewController.swift
//  FriendForFare
//
//  Created by Visarut on 2/27/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class NotificationViewController: UITableViewController {
    
    let notificationCelldentifier = "Cell"
    let notificationCell = "NotificationViewCell"
    var fristTime = true
    var joinList = [NSDictionary]()
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPullToRefresh()
        handleRefresh()
        tableView.register(UINib(nibName: notificationCell, bundle: nil), forCellReuseIdentifier: notificationCelldentifier)
        tableView?.rowHeight = 80
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: notificationCelldentifier, for: indexPath) as! NotificationViewCell
        
        print("\(indexPath.row)")
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let join = joinList[indexPath.row]
        guard let imageName = join["pic_user"] as? String ,imageName != "" else {
            return cell
        }
        
        let path = "http://192.168.2.101/friendforfare/images/"
        if let url = NSURL(string: "\(path)\(imageName)") {
            if let data = NSData(contentsOf: url as URL) {
                DispatchQueue.main.async {
                    cell.profileImage.image = UIImage(data: data as Data)
                }
                
            }
        }
        cell.fullnameLabel.text = "\(join["fname_user"] as! String) \(join["lname_user"] as! String)"
        cell.journeyLabel.text = "\(join["drop_journey"] as! String)"
        cell.timeLabel.text = "\(join["datetime_joinjourney"] as! String)"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joinList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "ListTapBarDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "JoinViewController") as! JoinViewController
        vc.myText = "joinUser"
        vc.join = joinList[indexPath.row] as! [String : Any]
        let nvc = NavController(rootViewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
}

extension NotificationViewController {
    func handleRefresh() {
        
        if fristTime {
            
            fristTime = false
            self.joinList = [NSDictionary]()
            let userID = UserDefaults.standard.integer(forKey: "UserID")
            selectData(id:userID)
            
        }
        
    }
    
    func selectData(id:Int) {
        let parameters: Parameters = [
            "function": "notificationJoin",
            "iduser" : id
        ]
        let url = "http://192.168.2.101/friendforfare/get/index.php?function=notificationJoin"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
                        for item in JSON as! NSArray {
                            self.joinList.append(item as! NSDictionary)
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
