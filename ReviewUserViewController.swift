//
//  ReviewUserViewController.swift
//  FriendForFare
//
//  Created by Visarut on 1/23/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class ReviewUserViewController:ViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var rateImage: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    var allTextField:[UITextField] {
        return [
            commentTextField
        ]
    }
    
    var myText:String?
    var review = [String: Any]()
    let userRate = 3
    let arrayRate = [0,1,2,3,4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = "http://worawaluns.in.th/friendforfare/images/"
        let url = NSURL(string:"\(path)\(review["pic_user"]!)")
        let data = NSData(contentsOf:url! as URL)
        if data == nil {
            profileImage.image = #imageLiteral(resourceName: "userprofile")
        } else {
            profileImage.image = UIImage(data:data as! Data)
        }
        fullnameLabel.text = "\(review["fname_user"] as! String) \(review["lname_user"] as! String)"
        usernameLabel.text = "\(review["username_user"] as! String)"
        setRateImage(rate: Int(userRate))
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func actionReview(_ sender: Any) {
        func checkTextField() -> Bool {
            for textField in allTextField {
                if textField.text?.characters.count == 0 { return false }
            }
            return true
        }
        
        if checkTextField() {
            simulateRegister()
            
        } else {
            let error = "alert please fill all information."
            print("error: \(error)")
        }
        
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setRateImage(rate:Int) {
        var imageName = String()
        switch rate {
        case 0:
            imageName = "rate-0"
        case 3:
            imageName = "rate-3"
        default:
            imageName = "rate-4-half"
        }
        rateImage.image = UIImage(named: imageName)
    }
}

extension ReviewUserViewController {
    
    func simulateRegister() {
        let rate = 4
        let comment = commentTextField.text
        let iduserreview = review["id_user"]
        let iduser = 1
        let journeyid = review["journey_id"]
        var parameter = Parameters()
        parameter.updateValue(rate, forKey: "rate_review")
        parameter.updateValue(comment!, forKey: "comment_review")
        parameter.updateValue(iduser, forKey: "reviewer_id")
        parameter.updateValue(iduserreview!, forKey: "user_id_review")
        parameter.updateValue(journeyid!, forKey: "journey_id")
        insertReviewData(parameter: parameter)
    }
    
    func insertReviewData(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "insertReviewData",
            "parameter": parameter
        ]
        
        let url = "http://worawaluns.in.th/friendforfare/post/index.php"
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
                    let iduserreview = JSON["iduesrreview"] as! String
                    self.updateStatus(statusreview: 1,iduser: iduserreview)
                    //status 202
                    print(JSON)
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
            })
        
    }
    
    func updateStatus(statusreview:Int, iduser:String)  {
        let parameters: Parameters = [
            "function": "updateStatus",
            "statusReview": statusreview,
            "iduserReview": iduser
        ]
        
        let url = "http://worawaluns.in.th/friendforfare/post/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                debugPrint(response)
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
                    self.dismiss(animated: true, completion: nil)
                    //status 202
                    print(JSON)
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
            })
        
    }
}