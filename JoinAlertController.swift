//
//  JoinAlertController.swift
//  FriendForFare
//
//  Created by Visarut on 2/21/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit

class JoinAlertController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension JoinAlertController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        <#code#>
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap")
    }
}
