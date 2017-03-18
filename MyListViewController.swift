//
//  MyListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire


class MyListViewController: UITableViewController {
    
    let feedViewCelldentifier = "Cell"
    let feedViewCell = "FeedViewCell"
    let sectionTitles = ["Waited", "Owner", "Joined"]
    var tripmyList = [NSDictionary]()
    var tripmyjoinList = [NSDictionary]()
    var tripmywaitList = [NSDictionary]()
    
    var dateFormatter = DateFormatter()
    var fristTime = true
    
    var hiddingSection = [false,false,false]
    let numberOfRow = [2,2]
    
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
        
        tableView.register(UINib(nibName: feedViewCell, bundle: nil), forCellReuseIdentifier: feedViewCelldentifier)
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
    
    func collapseAction(_ sender:Any) {
        let button = sender as! UIButton
        button.isEnabled = false
        hiddingSection[button.tag] = !hiddingSection[button.tag]
        let section = NSIndexSet(index: button.tag) as IndexSet
        DispatchQueue.main.async {
            button.isEnabled = true
            self.tableView?.reloadSections(section, with: .automatic)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("SectionHeaderView",
                                                  owner: nil,
                                                  options: nil)?.first as! SectionHeaderView
        headerView.titleLabel.text = sectionTitles[section]
        headerView.isOptionButtonEnable = hiddingSection[section]
        headerView.optionButton.tag = section
        headerView.optionButton.addTarget(self, action: #selector(collapseAction), for: .touchUpInside)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedViewCelldentifier, for: indexPath) as! FeedViewCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        switch indexPath.section {
        case 0:
            let tripwait = tripmywaitList[indexPath.row]
            cell.pickUpLabel.text = "PICK-UP : \(tripwait["pick_journey"] as! String)"
            cell.dropOffLabel.text = "DROP-OFF : \(tripwait["drop_journey"] as! String)"
            cell.amountLabel.text = "0/\(tripwait["count_journey"] as! String)"
            let dateTime  = "\(tripwait["date_journey"] as! String) \(tripwait["time_journey"] as! String)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            if let date = dateFormatter.date(from: dateTime) {
                dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                let timeStamp = dateFormatter.string(from: date)
                cell.dateTmeLabel.text = timeStamp
            } else {
                cell.dateTmeLabel.text = "..."
            }
            
            guard let imageName = tripwait["pic_user"] as? String ,imageName != "" else {
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
        case 1:
            let tripme = tripmyList[indexPath.row]
            cell.pickUpLabel.text = "PICK-UP : \(tripme["pick_journey"] as! String)"
            cell.dropOffLabel.text = "DROP-OFF : \(tripme["drop_journey"] as! String)"
            cell.amountLabel.text = "\(tripme["countuser"] as! String)/\(tripme["count_journey"] as! String)"
            let dateTime  = "\(tripme["date_journey"] as! String) \(tripme["time_journey"] as! String)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            if let date = dateFormatter.date(from: dateTime) {
                dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                let timeStamp = dateFormatter.string(from: date)
                cell.dateTmeLabel.text = timeStamp
            } else {
                cell.dateTmeLabel.text = "..."
            }
            
            guard let imageName = tripme["pic_user"] as? String ,imageName != "" else {
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
        case 2:
            let tripjoin = tripmyjoinList[indexPath.row]
            cell.pickUpLabel.text = "PICK-UP : \(tripjoin["pick_journey"] as! String)"
            cell.dropOffLabel.text = "DROP-OFF : \(tripjoin["drop_journey"] as! String)"
            cell.amountLabel.text = "\(tripjoin["countuser"] as! String)/\(tripjoin["count_journey"] as! String)"
            cell.dateTmeLabel.text = "\(tripjoin["date_journey"] as! String) \(tripjoin["time_journey"] as! String)"
            
            guard let imageName = tripjoin["pic_user"] as? String ,imageName != "" else {
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
        default:
            break
        }
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = Int()
        switch section {
        case 0:
            rows = hiddingSection[section] ? 0 : tripmywaitList.count
        case 1:
            rows = hiddingSection[section] ? 0 : tripmyList.count
        case 2:
            rows = hiddingSection[section] ? 0 : tripmyjoinList.count
        default:
            break
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "ListTapBarDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailJourneyViewController") as! DetailJourneyViewController
        vc.myText = "Journey"
        switch indexPath.section {
        case 0:
            vc.tripDetail = tripmywaitList[indexPath.row] as! [String : Any]
            vc.joinButtonToggle = "otherTrip"
            vc.delegate = self
        case 1:
            vc.tripDetail = tripmyList[indexPath.row] as! [String : Any]
            vc.joinButtonToggle = "myTrip"
            vc.delegate = self
        case 2:
            vc.tripDetail = tripmyjoinList[indexPath.row] as! [String : Any]
            vc.joinButtonToggle = "otherTrip"
            vc.delegate = self
        default:
            break
        }

        let nvc = NavController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
    }

}

extension MyListViewController: DetailJourneyDelegate{
    func detailJourneyDidFinish() {
        dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.handleRefresh()
        }
        
    }
}

extension MyListViewController {
    
    func handleRefresh() {
        
        if fristTime {
            
            fristTime = false
            self.tripmyList = [NSDictionary]()
            self.tripmyjoinList = [NSDictionary]()
            self.tripmywaitList = [NSDictionary]()
            let userID = UserDefaults.standard.integer(forKey: "UserID")
            selectmywaitData(iduser: userID)
            selectData(iduser: userID)
            selectmyjoinData(iduser: userID)
            
        }
        
    }
    
    func selectData(iduser:Int) {
        let parameters: Parameters = [
            "function": "journeymylistSelect",
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
                    for trip in JSON as! NSArray {
                        self.tripmyList.append(trip as! NSDictionary)
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
    
    func selectmyjoinData(iduser:Int) {
        let parameters: Parameters = [
            "function": "journeymyjoinedSelect",
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
                    for tripjoin in JSON as! NSArray {
                        self.tripmyjoinList.append(tripjoin as! NSDictionary)
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
    
    func selectmywaitData(iduser:Int) {
        let parameters: Parameters = [
            "function": "journeymywaitedSelect",
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
                        for tripjoin in JSON as! NSArray {
                            self.tripmywaitList.append(tripjoin as! NSDictionary)
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

extension MyListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

