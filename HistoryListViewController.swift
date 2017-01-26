//
//  HistoryListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class HistoryListViewController: UITableViewController {
    
    let feedViewCelldentifier = "Cell"
    let feedViewCell = "FeedViewCell"
    var itemInfo = IndicatorInfo(title: "New")
    var tripList = [NSDictionary]()
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
        
        tableView.register(UINib(nibName: feedViewCell, bundle: nil), forCellReuseIdentifier: feedViewCelldentifier)
        setPullToRefresh()
        handleRefresh()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: feedViewCelldentifier, for: indexPath) as! FeedViewCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        
        let trip = tripList[indexPath.row]
        cell.pickUpLabel.text = "PICK-UP : \(trip["pick_journey"] as! String)"
        cell.dropOffLabel.text = "DROP-OFF : \(trip["drop_journey"] as! String)"
        cell.amountLabel.text = "0/\(trip["count_journey"] as! String)"
        cell.dateTmeLabel.text = "\(trip["date_journey"] as! String) \(trip["time_journey"] as! String)"
        
        let path = "http://worawaluns.in.th/friendforfare/images/"
        let url = NSURL(string:"\(path)\(trip["pic_user"]!)")
        let data = NSData(contentsOf:url! as URL)
        if data == nil {
            cell.profileImage.image = #imageLiteral(resourceName: "userprofile")
        } else {
            cell.profileImage.image = UIImage(data:data as! Data)
        }


        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        vc.myText = "Review"
        vc.trip = tripList[indexPath.row] as! [String : Any]
        let nvc = NavController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
        
    }
}

extension HistoryListViewController {
    
    func handleRefresh() {
        
        if fristTime {
            
            fristTime = false
            self.tripList = [NSDictionary]()
            selectData()
            
        }
        
    }
    
    func selectData() {
        let parameters: Parameters = [
            "function": "historyjourneySelect"
        ]
        let url = "http://worawaluns.in.th/friendforfare/get/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                debugPrint(response)
                switch response.result {
                case .success:

                
                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    for trip in JSON as! NSArray {
                        self.tripList.append(trip as! NSDictionary)
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



extension HistoryListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

