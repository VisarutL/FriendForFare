//
//  MyListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyListViewController: UITableViewController {
    
    let feedViewCelldentifier = "Cell"
    let feedViewCell = "FeedViewCell"
    let sectionTitles = ["Owner", "Joined"]
    let numberOfRow = [2,5]
    
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
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
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
            cell.pickUpLabel.text = "PICK-UP : \(indexPath.row), section : \(indexPath.section)"
            cell.dropOffLabel.text = "DROP-OFF : \(indexPath.row)"
            cell.amountLabel.text = "\(indexPath.row)/4"
            cell.dateTmeLabel.text = "\(indexPath.row)"
        case 1:
            cell.pickUpLabel.text = "PICK-UP : \(indexPath.row), section : \(indexPath.section)"
            cell.dropOffLabel.text = "DROP-OFF : \(indexPath.row)"
            cell.amountLabel.text = "\(indexPath.row)/4"
            cell.dateTmeLabel.text = "\(indexPath.row)"
        default:
            break
        }
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRow[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "ListTapBarDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailJourneyViewController") as! DetailJourneyViewController
        vc.myText = "Journey"
        let nvc = NavController(rootViewController: vc)
        
        self.present(nvc, animated: true, completion: nil)
    }

}



extension MyListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

