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
        selectData()
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
        cell.amountLabel.text = "\(trip["count_journey"] as! String)/4"
        cell.dateTmeLabel.text = "\(trip["datatime_journey"] as! String)"

        
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
    //    (completionHandler:@escaping (_ r:[Region]?
    
    func selectData() {
        Alamofire.request("http://localhost/friendforfare/get/index.php?function=historyjourneySelect").responseJSON { response in
            switch response.result {
            case .success:
                
                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    for trip in JSON as! NSArray {
                        self.tripList.append(trip as! NSDictionary)
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


extension HistoryListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

