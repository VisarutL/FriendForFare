//
//  HistoryListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HistoryListViewController: UITableViewController {
    
    let feedViewCelldentifier = "Cell"
    let feedViewCell = "FeedViewCell"
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: feedViewCelldentifier, for: indexPath) as! FeedViewCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.pickUpLabel.text = "PICK-UP : \(indexPath.row)"
        cell.dropOffLabel.text = "DROP-OFF : \(indexPath.row)"
        cell.amountLabel.text = "\(indexPath.row)/4"
        cell.dateTmeLabel.text = "\(indexPath.row)"
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("row \(indexPath.row)")
    }
}



extension HistoryListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

