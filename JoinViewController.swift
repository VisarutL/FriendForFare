//
//  JoinViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/24/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class JoinViewController:UIViewController {
    
//    let reviewuserCelldentifier = "Cell"
//    let reviewCell = "ReviewUserViewCell"
//    let profileViewCelldentifier = "ProfileCell"
//    let profileViewCell = "ProfileViewCell"
    
    let userRate = 2
    let arrayRate = [0,1,2,3,4]
    
    var profile = [NSDictionary]()
    var reviewprofile = [NSDictionary]()
    var rateProfile = [NSDictionary]()
    
    
    @IBOutlet weak var imageUserProfile: UIImageView!
    @IBOutlet weak var rateUser: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    
    var myText:String?
    var join = [String: Any]()
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let iduser = Int(join["id_user"] as! String)!
//        self.selectData(iduser: iduser)
        let path = "http://localhost/friendforfare/images/"
        let url = NSURL(string:"\(path)\(join["pic_user"]!)")
        let data = NSData(contentsOf:url! as URL)
        if data == nil {
            imageUserProfile.image = UIImage(named: "userprofile")
        } else {
            imageUserProfile.image = UIImage(data:data as! Data)
        }
        fullnameLabel.text = "\(join["fname_user"]!) \(join["lname_user"]!)"
        telLabel.text = "Tel : \(join["tel_user"]!)"
        
        
//        tableView.register(UINib(nibName: reviewCell, bundle: nil), forCellReuseIdentifier: reviewuserCelldentifier)
//        tableView.rowHeight = 100
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        return Alamofire.SessionManager(configuration: configuration)
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 140
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: reviewuserCelldentifier, for: indexPath) as! ReviewUserViewCell
//        
//        print("\(indexPath.row)")
//        cell.preservesSuperviewLayoutMargins = false
//        cell.separatorInset = UIEdgeInsets.zero
//        cell.layoutMargins = UIEdgeInsets.zero
//        
//        
//        let reviewprofile = self.reviewprofile[indexPath.row]
//        if reviewprofile.count == 0 {
//            
//        } else {
//            cell.comemtLabel.text = "\(reviewprofile["comment_review"]!)"
//            cell.timeLabel.text = "\(reviewprofile["datetime_review"]!)"
//            let rate = reviewprofile["rate_review"] as! String
//            cell.setRateImage(rate: Int(rate)!)
//            let path = "http://localhost/friendforfare/images/"
//            let url = NSURL(string:"\(path)\(reviewprofile["pic_user"]!)")
//            let data = NSData(contentsOf:url! as URL)
//            if let data = data as? Data {
//                cell.profileImage.image = UIImage(data:data )
//            }
//            
//        }
//        
//        return cell
//        
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return profile.count
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        tableView.register(UINib(nibName: profileViewCell, bundle: nil), forCellReuseIdentifier: profileViewCelldentifier)
//        let cell = tableView.dequeueReusableCell(withIdentifier: profileViewCelldentifier) as! ProfileViewCell
//        
//        if profile.count == 0 {
//            cell.fullnameLabel.text = "full name."
//            cell.telLabel.text = "telephone."
//            cell.profileImage.image = UIImage(named: "userprofile")
//            cell.setRateImage(rate: 0)
//        } else {
//            cell.fullnameLabel.text = "\(profile[0]["fname_user"]!) \(profile[0]["lname_user"]!)"
//            cell.telLabel.text = "\(profile[0]["tel_user"]!)"
//            let rate = "\(rateProfile[0]["rate"]!)"
//            let rateprofile = Int(rate)
//            cell.setRateImage(rate: rateprofile!)
//            
//            let path = "http://localhost/friendforfare/images/"
//            let url = NSURL(string:"\(path)\(profile[0]["pic_user"]!)")
//            let data = NSData(contentsOf:url! as URL)
//            if data == nil {
//                cell.profileImage.image = #imageLiteral(resourceName: "userprofile")
//            } else {
//                cell.profileImage.image = UIImage(data:data as! Data)
//            }
//        }
//        cell.showLogout = false
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 260
//    }
//    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        //        if indexPath.row < 0 {
//        //            let cell = tableView.cellForRow(at: indexPath) as! ProfileViewCell
//        //            cell.setProfileImage()
//        //        }
//        
//    }

    
    @IBAction func acceptAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension JoinViewController {
//    func selectData(iduser:Int) {
//        let parameters: Parameters = [
//            "function": "profileSelect",
//            "iduser": iduser
//        ]
//        let url = "http://localhost/friendforfare/get/index.php?function=profileSelect"
//        let manager = initManager()
//        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
//            .responseJSON(completionHandler: { response in
//                manager.session.invalidateAndCancel()
//                //                debugPrint(response)
//                switch response.result {
//                case .success:
//                    
//                    
//                    if let JSON = response.result.value {
//                        //                        print("JSON: \(JSON)")
//                        for item in JSON as! NSArray {
//                            self.profile.append(item as! NSDictionary)
//                            
//                        }
//                        let userID = UserDefaults.standard.integer(forKey: "UserID")
//                        self.reviewData(id:userID)
//                        
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            })
//    }
//    
//    func reviewData(id:Int) {
//        let parameters: Parameters = [
//            "function": "reviewprofileSelect",
//            "userid" : id
//        ]
//        let url = "http://localhost/friendforfare/get/index.php?function=reviewprofileSelect"
//        let manager = initManager()
//        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
//            .responseJSON(completionHandler: { response in
//                manager.session.invalidateAndCancel()
//                //                debugPrint(response)
//                switch response.result {
//                case .success:
//                    if let JSON = response.result.value {
//                        //                        print("JSON: \(JSON)")
//                        for item in JSON as! NSArray {
//                            self.reviewprofile.append(item as! NSDictionary)
//                        }
//                        let userID = UserDefaults.standard.integer(forKey: "UserID")
//                        self.avgrate(iduser: userID)
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            })
//    }
//    
//    func avgrate(iduser:Int) {
//        let parameters: Parameters = [
//            "function": "avgrate",
//            "iduser" : iduser
//        ]
//        let url = "http://localhost/friendforfare/get/index.php"
//        let manager = initManager()
//        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
//            .responseJSON(completionHandler: { response in
//                manager.session.invalidateAndCancel()
//                //                debugPrint(response)
//                switch response.result {
//                case .success:
//                    if let JSON = response.result.value {
//                        //                        print("JSON: \(JSON)")
//                        for item in JSON as! NSArray {
//                            self.rateProfile.append(item as! NSDictionary)
//                        }
////                        DispatchQueue.main.async {
////                            self.tableView.reloadData()
////                        }
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            })
//    }

}
