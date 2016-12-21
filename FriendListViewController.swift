//
//  FriendListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class FriendListViewController:UITableViewController {
    
    let friendViewCelldentifier = "Cell"
    let friendViewCell = "FriendViewCell"
    var friendList = [NSDictionary]()
    
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
        tableView.register(UINib(nibName: friendViewCell, bundle: nil), forCellReuseIdentifier: friendViewCelldentifier)
        selectData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: friendViewCelldentifier, for: indexPath) as! FriendViewCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let friend = friendList[indexPath.row]
        cell.nameLabel.text = "\(friend["fname_user"]!) \(friend["lname_user"]!)"
        cell.usernameLabel.text = "\(friend["username_user"]!)"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print("row \(indexPath.row)")
    }
    

}


extension FriendListViewController {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //        let cell = tableView.cellForRow(at: indexPath)
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let planetToDelete = String(describing: indexPath.row)
            confirmDelete(item: planetToDelete)
        }
    }
    
    func confirmDelete(item: String) {
        let alert = UIAlertController(title: "Delete item", message: "Are you sure you want to permanently delete \(item)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        let cgRectMake = CGRect(x: self.view.bounds.size.width / 2.0, y:self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        alert.popoverPresentationController?.sourceRect = cgRectMake
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
            tableView.beginUpdates()
            
//            planets.removeAtIndex(indexPath.row)
//
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            
//            deletePlanetIndexPath = nil
//            
            tableView.endUpdates()
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
//        deletePlanetIndexPath = nil
    }
}

extension FriendListViewController {
    //    (completionHandler:@escaping (_ r:[Region]?
    
    func selectData() {
        Alamofire.request("http://localhost/friendforfare/get/index.php?function=friendSelect").responseJSON { response in
            switch response.result {
            case .success:
                
                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    for friend in JSON as! NSArray {
                        self.friendList.append(friend as! NSDictionary)
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

extension FriendListViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

