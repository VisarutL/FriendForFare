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
    
    var searchBar:UISearchBar?
    var tableView:UITableView?
    
    var tripList = [NSDictionary]()
    var filteredTripList = [NSDictionary]()
    
    var itemInfo:IndicatorInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchBar()
        initTableView()
        selectData()
        
    }
    
    
    
    
    
    
    
}

extension AllListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTripList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "ListTapBarDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "JourneyViewController") as! JourneyViewController
        vc.myText = "Journey"
        vc.trip = tripList[indexPath.row] as! [String : Any]
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
        
        let trip = filteredTripList[indexPath.row]
        cell.pickUpLabel.text = "PICK-UP : \(trip["pick_journey"] as! String)"
        cell.dropOffLabel.text = "DROP-OFF : \(trip["drop_journey"] as! String)"
        cell.amountLabel.text = "\(trip["count_journey"] as! String)/4"
        cell.dateTmeLabel.text = "\(trip["datatime_journey"] as! String)"
        
        return cell
        
        
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
        } else {
            filteredTripList = tripList.filter({( list : NSDictionary) -> Bool in
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
    
    func selectData() {
        Alamofire.request("http://localhost/friendforfare/get/index.php?function=journeySelect").responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
                    for trip in JSON as! NSArray {
                        self.tripList.append(trip as! NSDictionary)
                        self.filteredTripList = self.tripList
                    }
                    DispatchQueue.main.async {
                        self.tableView!.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AllListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo!
    }
    
}

