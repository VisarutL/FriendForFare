//
//  AllListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class AllListViewController: UIViewController {
    
    let feedViewCelldentifier = "Cell"
    let feedViewCell = "FeedViewCell"
    var sectionTitles = ["Nearby", "Friend"]
    
    var searchBar:UISearchBar?
    var tableView:UITableView?
    var refreshControl = UIRefreshControl()
    var dateFormatter = DateFormatter()
    
    var tripList = [NSDictionary]()
    var tripfriendList = [NSDictionary]()
    var filteredTripList = [NSDictionary]()
    var filteredfriendTripList = [NSDictionary]()
    
    let cpGroup = DispatchGroup()
    var itemInfo:IndicatorInfo?
    var fristTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchBar()
        initTableView()
        setPullToRefresh()
        refresh()
        
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
}

extension AllListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = Int()
        switch section {
        case 0:
            rows = filteredTripList.count
        case 1:
            rows = filteredfriendTripList.count
        default:
            break
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "ListTapBarDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "JourneyViewController") as! JourneyViewController
        vc.myText = "Journey"
        switch indexPath.section {
        case 0:
            vc.trip = filteredTripList[indexPath.row] as! [String : Any]
        case 1:
            vc.trip = filteredfriendTripList[indexPath.row] as! [String : Any]
        default:
            break
        }
        let nvc = NavController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
        
    }
}

extension AllListViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: feedViewCelldentifier, for: indexPath) as! FeedViewCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        var trip = NSDictionary()
        
        switch indexPath.section {
        case 0:
            trip = filteredTripList[indexPath.row]
        case 1:
            trip = filteredfriendTripList[indexPath.row]
        default:
            break
        }
        
        cell.pickUpLabel.text = "PICK-UP : \(trip["pick_journey"] as! String)"
        cell.dropOffLabel.text = "DROP-OFF : \(trip["drop_journey"] as! String)"
        cell.amountLabel.text = "0/\(trip["count_journey"] as! String)"
        cell.dateTmeLabel.text = "\(trip["time_journey"] as! String)"
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        headerView.backgroundColor = UIColor.tabbarColor
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = sectionTitles[section]
        headerView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 14)
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        return headerView
        
    }
}

extension AllListViewController {
    func initSearchBar() {
        searchBar = UISearchBar()
        searchBar!.delegate = self
        searchBar!.translatesAutoresizingMaskIntoConstraints = false
        searchBar!.sizeToFit()
        searchBar!.placeholder = "Search by trip"
        searchBar!.barTintColor = UIColor.tabbarColor
        searchBar!.tintColor = UIColor.black
        searchBar!.scopeButtonTitles = nil
//        searchBar!.scopeButtonTitles = ["All","Male","Female"]
        
        view.addSubview(searchBar!)
        let top = searchBar!.topAnchor.constraint(equalTo: view.topAnchor)
        let lead = searchBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        let trailing = searchBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
//        let height = searchBar!.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([top,lead, trailing])
    }
    
    func initTableView() {
        
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        view.addSubview(tableView)
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let lead = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        let trail = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        let top = tableView.topAnchor.constraint(equalTo: searchBar!.bottomAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([lead, trail,top,bottom])
        
        tableView.register(UINib(nibName: feedViewCell, bundle: nil), forCellReuseIdentifier: feedViewCelldentifier)
        
    }

}

extension AllListViewController:UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            filteredTripList = tripList
            filteredfriendTripList = tripfriendList
        } else {
            filteredTripList = tripList.filter({( list : NSDictionary) -> Bool in
                let name = list["drop_journey"] as! String
                let filterText = name.lowercased()
                return filterText.contains(searchText.lowercased())
            })
            filteredfriendTripList = tripfriendList.filter({( list : NSDictionary) -> Bool in
                let name = list["drop_journey"] as! String
                let filterText = name.lowercased()
                return filterText.contains(searchText.lowercased())
            })
        }
        self.tableView!.reloadData()
        
    }
}

extension AllListViewController {
//    (completionHandler:@escaping (_ r:[Region]?
    
    func refresh() {
        
        if fristTime {
            
            fristTime = false
            self.filteredTripList = [NSDictionary]()
            self.tripList = [NSDictionary]()
            self.filteredfriendTripList = [NSDictionary]()
            self.tripfriendList = [NSDictionary]()
            cpGroup.enter()
            selectData()
            cpGroup.enter()
            selectFriendData()
            cpGroup.notify(queue: DispatchQueue.main, execute: {
                self.fristTime = true
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.tableView?.reloadData()
            })
        }
        
    }
    
    func selectData() {
        let parameters: Parameters = [
            "function": "journeySelect"
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
                        self.filteredTripList = self.tripList
                    }
                    
                    let now = NSDate()
                    let updateString = "Last Update at " + self.dateFormatter.string(from: now as Date)
                    self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
                    
                }
                
                self.cpGroup.leave()
            case .failure(let error):
                print(error)
                self.cpGroup.leave()
            }
        })
    }
    
    func selectFriendData() {
        let parameters: Parameters = [
            "function": "journeyFriendSelect"
        ]
        let url = "http://worawaluns.in.th/friendforfare/get/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                debugPrint(response)
                switch response.result {
                case .success:                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    
                    for trip in JSON as! NSArray {
                        self.tripfriendList.append(trip as! NSDictionary)
                        self.filteredfriendTripList = self.tripfriendList
                    }
                    
                    let now = NSDate()
                    let updateString = "Last Update at " + self.dateFormatter.string(from: now as Date)
                    self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
                }
                self.cpGroup.leave()
            case .failure(let error):
                print(error)
                self.cpGroup.leave()
            }
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setPullToRefresh() {
        self.dateFormatter.dateStyle = DateFormatter.Style.short
        self.dateFormatter.timeStyle = DateFormatter.Style.long
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView?.insertSubview(refreshControl, at: 0)
    }
    
}
extension AllListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo!
    }
    
}

