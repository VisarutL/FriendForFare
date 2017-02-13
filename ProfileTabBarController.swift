//
//  ProfileTabBarController.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class ProfileTabBarController:UITableViewController{
    
    let reviewuserCelldentifier = "Cell"
    let reviewCell = "ReviewUserViewCell"
    let profileViewCelldentifier = "ProfileCell"
    let profileViewCell = "ProfileViewCell"
    
    let userRate = 2
    let arrayRate = [0,1,2,3,4]
    
    var profile = [NSDictionary]()
    var reviewprofile = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor.tabbarColor
        tableView.showsVerticalScrollIndicator = false
        
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        selectData(iduser: userID)
        tableView.register(UINib(nibName: reviewCell, bundle: nil), forCellReuseIdentifier: reviewuserCelldentifier)
        
        
        
    }
    
    deinit {
        print("deinit: ProfileTabBarController")
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return Alamofire.SessionManager(configuration: configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navVC = segue.destination as? UINavigationController
        let vc = navVC?.viewControllers.first as! EditProfileViewController
        vc.delegate = self
        vc.fname = (profile[0]["fname_user"] as! String)
        vc.lname = (profile[0]["lname_user"] as! String)
        vc.tel = (profile[0]["tel_user"] as! String)
        vc.email = (profile[0]["email_user"] as! String)
        vc.picuser = (profile[0]["pic_user"] as! String)
        vc.userid = (profile[0]["id_user"] as! String)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reviewuserCelldentifier, for: indexPath) as! ReviewUserViewCell
        
        print("\(indexPath.row)")
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        
        let reviewprofile = self.reviewprofile[indexPath.row]
        if reviewprofile.count == 0 {
            
        } else {
            cell.comemtLabel.text = "\(reviewprofile["comment_review"]!)"
            cell.timeLabel.text = "\(reviewprofile["datetime_review"]!)"
            let rate = reviewprofile["rate_review"] as! String
            cell.setRateImage(rate: Int(rate)!)
            let path = "http://localhost/friendforfare/images/"
            let url = NSURL(string:"\(path)\(reviewprofile["pic_user"]!)")
            let data = NSData(contentsOf:url! as URL)
            if data == nil {
                cell.profileImage.image = #imageLiteral(resourceName: "userprofile")
            } else {
                cell.profileImage.image = UIImage(data:data as! Data)
            }

        }
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.register(UINib(nibName: profileViewCell, bundle: nil), forCellReuseIdentifier: profileViewCelldentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: profileViewCelldentifier) as! ProfileViewCell
        
        if profile.count == 0 {
            cell.fullnameLabel.text = "full name."
            cell.telLabel.text = "telephone."
            cell.emailLabel.text = "mail."
            cell.profileImage.image = UIImage(named: "userprofile")
        } else {
            cell.fullnameLabel.text = "\(profile[0]["fname_user"]!) \(profile[0]["lname_user"]!)"
            cell.telLabel.text = "\(profile[0]["tel_user"]!)"
            cell.emailLabel.text = "\(profile[0]["email_user"]!)"
            
            let path = "http://localhost/friendforfare/images/"
            let url = NSURL(string:"\(path)\(profile[0]["pic_user"]!)")
            let data = NSData(contentsOf:url! as URL)
            if data == nil {
                cell.profileImage.image = #imageLiteral(resourceName: "userprofile")
            } else {
                cell.profileImage.image = UIImage(data:data as! Data)
            }
        }
        cell.showLogout = true
        cell.delegate = self
        cell.setRateImage(rate: userRate)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 260
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row < 0 {
//            let cell = tableView.cellForRow(at: indexPath) as! ProfileViewCell
//            cell.setProfileImage()
//        }
        
    }
    
    
    @IBAction func logoutAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive, handler: {
            _ in
            UserDefaults.standard.set(0, forKey: "UserID")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = vc
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
    
        alert.popoverPresentationController?.sourceView = self.view
        let cgRectMake = CGRect(x: self.view.bounds.size.width / 2.0, y:self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        alert.popoverPresentationController?.sourceRect = cgRectMake
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
}

extension ProfileTabBarController:EditProfileViewDelegate {
    func editProfileViewDidFinish() {
        profile = [NSDictionary]()
        reviewprofile = [NSDictionary]()
        
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        selectData(iduser: userID)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ProfileTabBarController:ProfileViewDelegate {
    func profileViewDidLogout(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
        present(vc, animated: true, completion: nil)
    }
}

extension ProfileTabBarController {

    
    func selectData(iduser:Int) {
        let parameters: Parameters = [
            "function": "profileSelect",
            "iduser": iduser
        ]
        let url = "http://localhost/friendforfare/get/index.php?function=profileSelect"
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
                            self.profile.append(item as! NSDictionary)
                            
                        }
                        let userID = UserDefaults.standard.integer(forKey: "UserID")
                        self.reviewData(id:userID)
                        
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }



    func reviewData(id:Int) {
        let parameters: Parameters = [
            "function": "reviewprofileSelect",
            "userid" : id
        ]
        let url = "http://localhost/friendforfare/get/index.php?function=reviewprofileSelect"
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
                            self.reviewprofile.append(item as! NSDictionary)
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
