//
//  AllListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    var hiddingSection = [false,false]
    
    let cpGroup = DispatchGroup()
    var itemInfo:IndicatorInfo?
    var fristTime = true
    
    var currentLocation:CLLocation!
    
    weak var delegate:ListTapBarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchBar()
        initTableView()
        setPullToRefresh()
        tableView?.rowHeight = 90
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        
//        var connected = true
//        repeat {
//            self.currentLocation = LocationService.sharedInstance.currentLocation
//            let latitude = currentLocation?.coordinate.latitude
//            let longitude = currentLocation?.coordinate.longitude
//            print("latitude:\(latitude), longitude:\(longitude)")
//            guard latitude != nil else {  continue }
//            if latitude! > 0 || longitude! > 0  {
//                connected = false
//                self.refresh(lat:latitude!,long:longitude!)
//            }
//        } while connected
        
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
            rows = hiddingSection[section] ? 0 : filteredTripList.count
        case 1:
            rows = hiddingSection[section] ? 0 : filteredfriendTripList.count
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
            vc.delegate = self
        case 1:
            vc.trip = filteredfriendTripList[indexPath.row] as! [String : Any]
            vc.delegate = self
        default:
            break
        }
        let nvc = NavController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
        
    }
}
extension AllListViewController:JourneyDelegate {
    func journeyDidJoin() {
        dismiss(animated: true, completion: nil)
        delegate?.didMoveController(index: 1)
        refresh()
        
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
        
        let countpeople = Int(trip["count_journey"] as! String)
        let count = countpeople! + 1
        
        cell.pickUpLabel.text = "\(trip["pick_journey"] as! String)"
        cell.dropOffLabel.text = "\(trip["drop_journey"] as! String)"
        cell.amountLabel.text = "\(trip["countuser"] as! String)/\(count)"
        
        
        let dateTime  = "\(trip["date_journey"] as! String) \(trip["time_journey"] as! String)"
        
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
        

        
        guard let imageName = trip["pic_user"] as? String ,imageName != "" else {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("SectionHeaderView",
                                                            owner: nil,
                                                            options: nil)?.first as! SectionHeaderView
        headerView.titleLabel.text = sectionTitles[section]
        headerView.isOptionButtonEnable = hiddingSection[section]
        headerView.optionButton.tag = section
        headerView.optionButton.addTarget(self, action: #selector(collapseAction), for: .touchUpInside)
        return headerView
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
}

extension AllListViewController {
    func initSearchBar() {
        searchBar = UISearchBar()
        searchBar!.delegate = self
        searchBar!.translatesAutoresizingMaskIntoConstraints = false
        searchBar!.sizeToFit()
        searchBar!.placeholder = "Search by trip"
        searchBar!.barTintColor = UIColor.searchbarColor
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
        tableView.rowHeight = 90.0
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
            let userID = UserDefaults.standard.integer(forKey: "UserID")
            self.currentLocation = LocationService.sharedInstance.currentLocation
            let latitude = currentLocation?.coordinate.latitude
            let longitude = currentLocation?.coordinate.longitude
            print("latitude: \(latitude!), longitude: \(longitude!)")
            selectData(iduser: userID,latt: latitude!, longg: longitude!)
            cpGroup.enter()
            selectFriendData(iduser: userID)
            cpGroup.notify(queue: DispatchQueue.main, execute: {
                self.fristTime = true
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.tableView?.reloadData()
            })
        }
        
    }
    
    func selectData(iduser:Int,latt:Double,longg:Double) {
        let parameters: Parameters = [
            "function": "journeySelect",
            "iduser" : iduser,
            "latitude": latt,
            "longitude": longg
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
    
    func selectFriendData(iduser:Int) {
        let parameters: Parameters = [
            "function": "journeyFriendSelect",
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
                self.alert( message: "selectFriendData:\(error.localizedDescription)")
                self.cpGroup.leave()
            }
        })
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


