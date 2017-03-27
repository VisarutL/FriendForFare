//
//  ProfileFriendTabBarController.swift
//  FriendForFare
//
//  Created by Visarut on 12/22/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class ProfileFriendTabBarController:UIViewController{
    
    let reviewuserCelldentifier = "Cell"
    let reviewCell = "ReviewUserViewCell"
    let profileViewCelldentifier = "ProfileCell"
    let profileViewCell = "ProfileViewCell"
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var containerView: UIView!
    var userProfileView: ProfileView!
    
    var myText:String?
    var friend = [String: Any]()
    
    let userRate = 0
    let arrayRate = [0,1,2,3,4]
    
    var profilefriend = [NSDictionary]()
    var rateProfile = [NSDictionary]()
    var rateProfileGirl = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()
        tableSetting()
        selectData()
        avgrate()
        userProfileView = profileViewSetting()
        self.containerView.addSubview(self.userProfileView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.userProfileView.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: 260)
        self.userProfileView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.userProfileView.addBorderBottom(size: 1, color: UIColor.gray)
        self.userProfileView.backgroundColor = UIColor.tabColor
        self.containerView.layoutIfNeeded()
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
    
    @IBAction func closeButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileFriendTabBarController: UITableViewDelegate,UITableViewDataSource {
    
    func tableSetting() {
        
        let verticalOffset: CGFloat = 20
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        tableView.rowHeight = 115
        
        let dummyFooterView: UIView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
            view.backgroundColor = .white
            return view
        }()
        tableView.tableFooterView = dummyFooterView
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -dummyFooterView.frame.height + verticalOffset, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: tableView.sectionHeaderHeight, left: 0, bottom: verticalOffset, right: 0)
        
        tableView.register(UINib(nibName: profileViewCell, bundle: nil), forCellReuseIdentifier: profileViewCelldentifier)
        tableView.register(UINib(nibName: reviewCell, bundle: nil), forCellReuseIdentifier: reviewuserCelldentifier)
        
        automaticallyAdjustsScrollViewInsets = false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if profilefriend.count == 0 {
            return 1
        }
        return profilefriend.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if profilefriend.count == 0 {
            return 60
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if profilefriend.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell") ??
                UITableViewCell(style: .default, reuseIdentifier: "emptyCell")
            cell.textLabel?.text = "ยังไม่มีคนรีวิว"
            cell.textLabel?.textColor = UIColor.gray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textAlignment = .center
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reviewuserCelldentifier, for: indexPath) as! ReviewUserViewCell
        
        print("\(indexPath.row)")
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let item = self.profilefriend[indexPath.row]
        cell.comemtLabel.text = "\(item["comment_review"]!)"
        cell.timeLabel.text = "\(item["datetime_review"]!)"
        cell.journeyReviewLabel.text = "\(item["drop_journey"]!)"
        
        let rate = item["rate_review"] as! String
        cell.setRateImage(rate: Int(rate)!)
        
        guard let imageName = item["pic_user"] as? String ,imageName != "" else {
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
    
    func setReview() {
        if rateProfile.count == 0 {
            userProfileView.setRateImage(rate: 0)
        } else {
            let rate = "\(rateProfile[0]["rate"]!)"
            let rateprofile = Int(rate)
            if rateprofile == nil {
            } else {
                userProfileView.setRateImage(rate: rateprofile!)
            }
            if rateProfileGirl.count == 0 {
                userProfileView.setRateImageGirl(rate: 0)
            } else {
                let rategirl = "\(rateProfileGirl[0]["rategirl"]!)"
                let rateprofileGirl = Int(rategirl)
                if rateprofileGirl == nil {
                    userProfileView.setRateImageGirl(rate: 0)
                } else {
                    userProfileView.setRateImageGirl(rate: rateprofileGirl!)
                }
            }
        }
    }
    
}

extension ProfileFriendTabBarController {
    
    func viewSetting() {
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .clear
        
        //        DispatchQueue.main.async {
        //            self.profileViewSetting()
        //        }
        
        
        
        
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAction))
        fadeView.addGestureRecognizer(tap)
    }
    
    
    func profileViewSetting() -> ProfileView {
        
        let userProfileView = Bundle.main.loadNibNamed("ProfileView",
                                                       owner: nil,
                                                       options: nil)?.first as! ProfileView
        
        if friend.count == 0 {
            userProfileView.fullnameLabel.text = "full name."
            userProfileView.telLabel.text = "telephone."
            userProfileView.emailLabel.text = "mail."
        } else {
            userProfileView.fullnameLabel.text = "\(friend["fname_user"] as! String) \(friend["lname_user"] as! String)"
            userProfileView.telLabel.text = "Tel : \(friend["tel_user"] as! String)"
            userProfileView.emailLabel.text = "Email : \(friend["email_user"] as! String)"
            
            
            guard let imageName = friend["pic_user"] as? String ,imageName != "" else {
                return userProfileView
            }
            
            let path = "\(URLbase.URLbase)friendforfare/images/"
            if let url = NSURL(string: "\(path)\(imageName)") {
                if let data = NSData(contentsOf: url as URL) {
                    DispatchQueue.main.async {
                        userProfileView.profileImage.image = UIImage(data: data as Data)
                    }
                    
                }
            }
        }
        
        userProfileView.setRateImage(rate: userRate)
        
        return userProfileView
        
    }
    
    func selectData() {
        let iduser = (friend["id_user"] as! String)
        let parameters: Parameters = [
            "function": "profilefriendSelect",
            "userid" : iduser
        ]
        let url = "\(URLbase.URLbase)friendforfare/get/index.php?function=profilefriendSelect"
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
                        self.avgrate()
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func avgrate() {
        let iduser = "\(friend["id_user"] as! String)"
        let parameters: Parameters = [
            "function": "avgrate",
            "iduser" : iduser
        ]
        let url = "\(URLbase.URLbase)friendforfare/get/index.php"
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
        let url = "\(URLbase.URLbase)friendforfare/get/index.php"
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
                        self.setReview()
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
