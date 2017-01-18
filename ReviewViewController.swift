//
//  ReviewViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/12/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class ReviewViewController:UITableViewController {
    
    let reviewCelldentifier = "Cell"
    let reviewCell = "ReviewViewCell"
    var myText:String?
    var trip = [String: Any]()
    var reviewList = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let myText = myText {
            title = myText
            print(myText)
        }
        selectData()
        
        tableView.register(UINib(nibName: reviewCell, bundle: nil), forCellReuseIdentifier: reviewCelldentifier)
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
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
        
        let review = reviewList[indexPath.row]
        cell.usernameLabel.text = (review["fname_user"] as! String)
        let rate = trip["id_journey"] as! String
        cell.setRateImage(rate: Int(rate)!)
        
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ReviewViewController {
    
    func selectData() {
        let idtrip = (trip["id_journey"] as! String)
        let parameters: Parameters = [
            "function": "reviewJourneySelect",
            "journeyid" : idtrip
        ]
        let url = "http://worawaluns.in.th/friendforfare/get/index.php?function=reviewJourneySelect"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //                debugPrint(response)
                switch response.result {
                case .success:
                    
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        for item in JSON as! NSArray {
                            self.reviewList.append(item as! NSDictionary)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView!.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
    
}
