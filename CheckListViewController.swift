//
//  CheckListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 3/15/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit

class CheckListViewController:UIViewController {

    var userjoinedList = [[String: Any]]()
    var tripDetail = [String: Any]()
    
    let checkListCell = "CheckListViewCell"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetting()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "MapDistance":
                let vc = segue.destination as! MapViewController
                vc.tripDetail = tripDetail
            default:
                break
            }
        }
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        performSegue(withIdentifier: "MapDistance", sender: nil)
    }

}

extension CheckListViewController:UITableViewDataSource,UITableViewDelegate {
    func tableViewSetting() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60.0
        tableView.register(UINib(nibName: checkListCell, bundle: nil), forCellReuseIdentifier: checkListCell)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: checkListCell, for: indexPath) as! CheckListViewCell

        let user = userjoinedList[indexPath.row]
        let userPic = user["pic_user"] as? String
        let check = Int(user["status_go"] as! String)
        let frist = user["fname_user"] as! String
        let last = user["lname_user"] as! String
        let username = user["username_user"] as! String
        
        let image = check == 1 ? UIImage(named: "btn-star-enable") : UIImage(named: "btn-star-disable")
        cell.tag = indexPath.row
        cell.tickButton.setImage(image, for: .normal)
        cell.tickButton.addTarget(self, action: #selector(toggleSelcted), for: .touchUpInside)
        
        cell.fullnameLabel.text = "\(frist) \(last)"
        cell.usernameLabel.text = username
        
        guard let imageName = userPic ,imageName != "" else {
            return cell
        }
        
        let path = "http://localhost/friendforfare/images/"
        if let url = NSURL(string: "\(path)\(imageName)") {
            if let data = NSData(contentsOf: url as URL) {
                DispatchQueue.main.async {
                    cell.profileImage.image = UIImage(data: data as Data)
                }
                
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userjoinedList.count
    }
    
    func toggleSelcted(button: UIButton) {
        let index = button.tag
        let user = userjoinedList[index]
        let userStatus = Int(user["status_go"] as! String)
        userjoinedList[index]["status_go"] = userStatus == 0 ? "1" : "0"
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! CheckListViewCell
        let image = userStatus == 1 ? UIImage(named: "btn-star-enable") : UIImage(named: "btn-star-disable")
        cell.tickButton.setImage(image, for: .normal)
    }
    
}
