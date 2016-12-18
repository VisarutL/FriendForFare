//
//  ReviewViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/12/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class ReviewViewController:UITableViewController {
    
    let reviewCelldentifier = "Cell"
    let reviewCell = "ReviewViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: reviewCell, bundle: nil), forCellReuseIdentifier: reviewCelldentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reviewCelldentifier, for: indexPath) as! ReviewViewCell
        
        print("\(indexPath.row)")
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
