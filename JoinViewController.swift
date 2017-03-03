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
    
    let reviewuserCelldentifier = "Cell"
    let reviewCell = "ReviewUserViewCell"
    
    let userRate = 2
    let arrayRate = [0,1,2,3,4]
    
    var profile = [NSDictionary]()
    var reviewprofile = [NSDictionary]()
    var rateProfile = [NSDictionary]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
        
        let iduser = Int(join["id_user"] as! String)!
        selectData(iduser: iduser)
        initTableView()
        setProfileImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func dataProfile() {
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
        let rate = "\(rateProfile[0]["rate"]!)"
        let rateprofile = Int(rate)
        if rateprofile == nil {
            setRateImageProfile(rate:0)
        } else {
            setRateImageProfile(rate:rateprofile!)
        }
    }
    
    func setProfileImage() {
        DispatchQueue.main.async {
            self.imageUserProfile.layer.cornerRadius = self.imageUserProfile.bounds.size.height / 2
            self.imageUserProfile.clipsToBounds = true
        }
    }
    
    func setRateImageProfile(rate:Int) {
        var imageName = String()
        switch rate {
        case 1:
            imageName = "rate-1"
        case 2:
            imageName = "rate-2"
        case 3:
            imageName = "rate-3"
        case 4:
            imageName = "rate-4"
        case 5:
            imageName = "rate-5"
        default:
            imageName = "rate-0"
        }
        rateUser.image = UIImage(named: imageName)
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        return Alamofire.SessionManager(configuration: configuration)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        let iduser = Int(join["id_user"] as! String)!
        joinAccept(id:iduser)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelAction(_ sender: Any) {
        let iduser = Int(join["id_user"] as! String)!
        joinCancel(id:iduser)
        self.dismiss(animated: true, completion: nil)
    }
}
extension JoinViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewprofile.count
    }

}

extension JoinViewController:UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: reviewuserCelldentifier, for: indexPath) as! ReviewUserViewCell

        print("\(indexPath.row)")
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        if reviewprofile.count == 0 {
            
        } else {
            
            let reviewprofile = self.reviewprofile[indexPath.row]
            let rate = reviewprofile["rate_review"] as! String
            let comment = reviewprofile["comment_review"] as! String
            let time = reviewprofile["datetime_review"] as! String
            
            cell.comemtLabel.text = "\(comment)"
            cell.timeLabel.text = "\(time)"
            cell.setRateImage(rate: Int(rate)!)
            
            let path = "http://localhost/friendforfare/images/"
            let url = NSURL(string:"\(path)\(reviewprofile["pic_user"]!)")
            let data = NSData(contentsOf:url! as URL)
            if let data = data as? Data {
                cell.profileImage.image = UIImage(data:data )
            }
            
        }
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        if indexPath.row < 0 {
        //            let cell = tableView.cellForRow(at: indexPath) as! ProfileViewCell
        //            cell.setProfileImage()
        //        }
        
    }
}

extension JoinViewController {
    func initTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.layer.borderWidth = 1.5
//        tableView.layer.borderColor = UIColor.black.cgColor
//        tableView.layer.cornerRadius = 12
//        tableView.layer.masksToBounds = true
        tableView.rowHeight = 90.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: reviewCell, bundle: nil), forCellReuseIdentifier: reviewuserCelldentifier)
        
    }
    
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
                        self.reviewData(id:iduser)
                        
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
                        let iduser = Int(self.join["id_user"] as! String)!
                        self.avgrate(iduser: iduser)
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
                        self.dataProfile()
                        DispatchQueue.main.async {
                            self.tableView?.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func joinAccept(id:Int) {
        let userid = id
        var parameter = Parameters()
        parameter.updateValue(userid, forKey: "user_id")
        insertidUser(parameter: parameter)
    }
    
    func insertidUser(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "joinAccept",
            "parameter": parameter
        ]
        let url = "http://localhost/friendforfare/post/index.php?function=joinAccept"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
                switch response.result {
                case .success:
                    guard let JSON = response.result.value as! [String : Any]? else {
                        print("error: cannnot cast result value to JSON or nil.")
                        return
                    }
                    
                    let status = JSON["status"] as! String
                    if  status == "404" {
                        print("error: \(JSON["message"] as! String)")
                        return
                    }
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
            })
    }
    
    func joinCancel(id:Int) {
        let userid = id
        var parameter = Parameters()
        parameter.updateValue(userid, forKey: "user_id")
        insertUserid(parameter: parameter)
    }
    
    func insertUserid(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "joinCancel",
            "parameter": parameter
        ]
        let url = "http://localhost/friendforfare/post/index.php?function=joinCancel"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //                debugPrint(response)
                switch response.result {
                case .success:
                    guard let JSON = response.result.value as! [String : Any]? else {
                        print("error: cannnot cast result value to JSON or nil.")
                        return
                    }
                    
                    let status = JSON["status"] as! String
                    if  status == "404" {
                        print("error: \(JSON["message"] as! String)")
                        return
                    }
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
            })
    }
}
