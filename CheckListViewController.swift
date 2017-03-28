//
//  CheckListViewController.swift
//  FriendForFare
//
//  Created by Visarut on 3/15/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
        let idtrip = Int(tripDetail["id_journey"] as! String)
        checkList(trip:idtrip!)
        performSegue(withIdentifier: "MapDistance", sender: nil)
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        return Alamofire.SessionManager(configuration: configuration)
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
        
        let image = check == 1 ? UIImage(named: "Check1") : UIImage(named: "Checkk1")
        cell.tickButton.tag = indexPath.row
        cell.tickButton.setImage(image, for: .normal)
        cell.tickButton.addTarget(self, action: #selector(toggleSelcted), for: .touchUpInside)
        cell.fullnameLabel.text = "\(frist) \(last)"
        cell.usernameLabel.text = username
        
        guard let imageName = userPic ,imageName != "" else {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userjoinedList.count
    }
    
    func toggleSelcted(button: UIButton) {
        let index = button.tag
        let user = JSON(userjoinedList[index])
        let new = user["status_go"].intValue == 0 ? 1 : 0
        userjoinedList[index]["status_go"] = new
        
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! CheckListViewCell
        let image = new == 1 ? UIImage(named: "Check1") : UIImage(named: "Checkk1")
        cell.tickButton.setImage(image, for: .normal)
        
        print("\(user["user_id_joined"].stringValue) : \(user["status_go"].stringValue)")
    }
    
}

extension CheckListViewController {
    
    func checkList(trip:Int) {
        let checklistJSON = JSON(userjoinedList)
        let checklistJSONString = checklistJSON.rawString(String.Encoding.utf8)!
        print("checklistJSONString: \(checklistJSONString)")
        let tripid = trip
        let parameters: Parameters = [
            "function": "checkList",
            "idjourney": tripid,
            "checklist": checklistJSONString
        ]
        let url = "\(URLbase.URLbase)friendforfare/post/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                debugPrint(response)
                switch response.result {
                case .success:
                    print("Success")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
}
