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
    var dateFormatter = DateFormatter()
    var fristTime = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setPullToRefresh()
        handleRefresh()
        if let myText = myText {
            title = myText
            print(myText)
        }
        
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
        let path = "http://worawaluns.in.th/friendforfare/images/"
        let url = NSURL(string:"\(path)\(review["pic_user"]!)")
        let data = NSData(contentsOf:url! as URL)
        if data == nil {
            cell.profileImage.image = #imageLiteral(resourceName: "userprofile")
        } else {
            cell.profileImage.image = UIImage(data:data as! Data)
        }
        cell.fullnameLabel.text = "\(review["fname_user"]!) \(review["lname_user"]!)"
        cell.usernameLabel.text = "\(review["username_user"]!)"
        
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReviewUserViewController") as! ReviewUserViewController
        vc.myText = "ReviewUser"
        vc.review = reviewList[indexPath.row] as! [String : Any]
        let nvc = NavController(rootViewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(nvc, animated: true, completion: nil)
        
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ReviewViewController {
    
    func handleRefresh() {
        
        if fristTime {
            
            fristTime = false
            self.reviewList = [NSDictionary]()
            selectData()
            
        }
        
    }
    
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
                        
                    }
                    let now = NSDate()
                    let updateString = "Last Update at " + self.dateFormatter.string(from: now as Date)
                    self.refreshControl?.attributedTitle = NSAttributedString(string: updateString)
                    
                    DispatchQueue.main.async {
                        self.fristTime = true
                        
                        if let refreshControl = self.refreshControl {
                            if refreshControl.isRefreshing {
                                refreshControl.endRefreshing()
                            }
                        }
                        
                        self.tableView?.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func setPullToRefresh() {
        self.tableView.delegate = self
        self.dateFormatter.dateStyle = DateFormatter.Style.short
        self.dateFormatter.timeStyle = DateFormatter.Style.long
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //        self.refreshControl?.backgroundColor = UIColor.tabbarColor
        //        self.refreshControl?.tintColor = UIColor.white
        
        let selector = #selector(self.handleRefresh)
        self.refreshControl?.addTarget(self,
                                       action: selector,
                                       for: UIControlEvents.valueChanged)
    }

    
}
