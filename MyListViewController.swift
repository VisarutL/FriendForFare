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
    let sectionTitles = ["Owner", "Joined"]
    var tripmyList = [NSDictionary]()
    var tripmyjoinList = [NSDictionary]()
    
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
        selectData()
        selectmyjoinData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
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
            let tripme = tripmyList[indexPath.row]
            cell.pickUpLabel.text = "PICK-UP : \(tripme["pick_journey"] as! String)"
            cell.dropOffLabel.text = "DROP-OFF : \(tripme["drop_journey"] as! String)"
            cell.amountLabel.text = "\(tripme["count_journey"] as! String)/4"
            cell.dateTmeLabel.text = "\(tripme["datatime_journey"] as! String)"
        case 1:
            let tripjoin = tripmyjoinList[indexPath.row]
            cell.pickUpLabel.text = "PICK-UP : \(tripjoin["pick_journey"] as! String)"
            cell.dropOffLabel.text = "DROP-OFF : \(tripjoin["drop_journey"] as! String)"
            cell.amountLabel.text = "\(tripjoin["count_journey"] as! String)/4"
            cell.dateTmeLabel.text = "\(tripjoin["datatime_journey"] as! String)"
        default:
            break
        }
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let tripmy = tripmyList.count
            return tripmy
        case 1:
            let tripjoined = tripmyjoinList.count
            return tripjoined
        default:
            break
        }
        return numberOfRow[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "ListTapBarDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailJourneyViewController") as! DetailJourneyViewController
        vc.myText = "Journey"
        switch indexPath.section {
        case 0:
            vc.tripme = tripmyList[indexPath.row] as! [String : Any]
            vc.joinButtonToggle = "myTrip"
        case 1:
            vc.tripjoin = tripmyjoinList[indexPath.row] as! [String : Any]
            vc.joinButtonToggle = "otherTrip"
        default:
            break
        }

        let nvc = NavController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
    }

}

extension MyListViewController {
    //    (completionHandler:@escaping (_ r:[Region]?
    
    func selectData() {
        Alamofire.request("http://worawaluns.in.th/friendforfare/get/index.php?function=journeymylistSelect").responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    for trip in JSON as! NSArray {
                        self.tripmyList.append(trip as! NSDictionary)
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

extension MyListViewController {
    //    (completionHandler:@escaping (_ r:[Region]?
    
    func selectmyjoinData() {
        Alamofire.request("http://worawaluns.in.th/friendforfare/get/index.php?function=journeymyjoinedSelect").responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    for tripjoin in JSON as! NSArray {
                        self.tripmyjoinList.append(tripjoin as! NSDictionary)
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

extension MyListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

