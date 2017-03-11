//
//  ProfileFriendTabBarController.swift
//  FriendForFare
//
//  Created by Visarut on 12/22/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class ProfileFriendTabBarController:UITableViewController{
    
    let reviewuserCelldentifier = "Cell"
    let reviewCell = "ReviewUserViewCell"
    let profileViewCelldentifier = "ProfileCell"
    let profileViewCell = "ProfileViewCell"
    
    var closeBarButton = UIBarButtonItem()
    var myText:String?
    var friend = [String: Any]()
    
    let userRate = 0
    let arrayRate = [0,1,2,3,4]
    
    var profilefriend = [NSDictionary]()
    var rateProfile = [NSDictionary]()
    var rateProfileGirl = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor.tabbarColor
        tableView.showsVerticalScrollIndicator = false
        
        selectData()
        let iduser = "\(friend["id_user"] as! String)"
        let userid = Int(iduser)
        avgrate(iduser: userid!)
        setCloseButton()
        tableView.register(UINib(nibName: reviewCell, bundle: nil), forCellReuseIdentifier: reviewuserCelldentifier)
        tableView.rowHeight = 115
        
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
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reviewuserCelldentifier, for: indexPath) as! ReviewUserViewCell
        
        print("\(indexPath.row)")
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let profilefriend = self.profilefriend[indexPath.row]
        cell.comemtLabel.text = "\(profilefriend["comment_review"]!)"
        cell.timeLabel.text = "\(profilefriend["datetime_review"]!)"
        let rate = profilefriend["rate_review"] as! String
        cell.setRateImage(rate: Int(rate)!)
        
        guard let imageName = profilefriend["pic_user"] as? String ,imageName != "" else {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profilefriend.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.register(UINib(nibName: profileViewCell, bundle: nil), forCellReuseIdentifier: profileViewCelldentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: profileViewCelldentifier) as! ProfileViewCell
        
        if friend.count == 0 {
            cell.fullnameLabel.text = "full name."
            cell.telLabel.text = "telephone."
            cell.emailLabel.text = "mail."
        } else {
            cell.fullnameLabel.text = "\(friend["fname_user"] as! String) \(friend["lname_user"] as! String)"
            cell.telLabel.text = "Tel : \(friend["tel_user"] as! String)"
            cell.emailLabel.text = "Email : \(friend["email_user"] as! String)"
            if rateProfile.count == 0 {
                cell.setRateImage(rate: 0)
            } else {
                let rate = "\(rateProfile[0]["rate"]!)"
                let rateprofile = Int(rate)
                if rateprofile == nil {
                } else {
                    cell.setRateImage(rate: rateprofile!)
                }
                if rateProfileGirl.count == 0 {
                    cell.setRateImageGirl(rate: 0)
                } else {
                    let rategirl = "\(rateProfileGirl[0]["rategirl"]!)"
                    let rateprofileGirl = Int(rategirl)
                    if rateprofileGirl == nil {
                        cell.setRateImageGirl(rate: 0)
                    } else {
                        cell.setRateImageGirl(rate: rateprofileGirl!)
                    }
                }
            }
            
            
            guard let imageName = friend["pic_user"] as? String ,imageName != "" else {
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
        }
        
        cell.setRateImage(rate: userRate)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 260
    }
    
    func setCloseButton() {
        closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeAction))
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileFriendTabBarController {
    //    (completionHandler:@escaping (_ r:[Region]?
    
    func selectData() {
        let iduser = (friend["id_user"] as! String)
        let parameters: Parameters = [
            "function": "profilefriendSelect",
            "userid" : iduser
        ]
        let url = "http://localhost/friendforfare/get/index.php?function=profilefriendSelect"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
                switch response.result {
                case .success:
                    
                    
                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
                        
                        for item in JSON as! NSArray {
                            self.profilefriend.append(item as! NSDictionary)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func avgrate(iduser:Int) {
        let parameters: Parameters = [
            "function": "avgrate",
            "iduser" : iduser
        ]
        let url = "http://localhost/friendforfare/get/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //                debugPrint(response)
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        //                        print("JSON: \(JSON)")
                        for item in JSON as! NSArray {
                            self.rateProfile.append(item as! NSDictionary)
                        }
                        let iduser = "\(self.friend["id_user"] as! String)"
                        let userid = Int(iduser)
                        self.avgrategirl(iduser: userid!)
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func avgrategirl(iduser:Int) {
        let parameters: Parameters = [
            "function": "avgrategirl",
            "iduser" : iduser
        ]
        let url = "http://localhost/friendforfare/get/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //                debugPrint(response)
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        //                        print("JSON: \(JSON)")
                        for item in JSON as! NSArray {
                            self.rateProfileGirl.append(item as! NSDictionary)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }

}
