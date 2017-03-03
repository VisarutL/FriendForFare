//
//  ReviewUserViewController.swift
//  FriendForFare
//
//  Created by Visarut on 1/23/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class ReviewUserViewController:UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var rateImage: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet var starButtons: [UIButton]!
    var allTextField:[UITextField] {
        return [commentTextField]
    }
    
    var myText:String?
    var journeyID = Int()
    var review = [String: Any]()
    var userRate = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileImage()
        setReviewUser()
        
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
    
    func setReviewUser() {
        let path = "http://localhost/friendforfare/images/"
        let url = NSURL(string:"\(path)\(review["pic_user"]!)")
        let data = NSData(contentsOf:url! as URL)
        if data == nil {
            profileImage.image = UIImage(named: "userprofile")
        } else {
            profileImage.image = UIImage(data:data as! Data)
        }
        fullnameLabel.text = "\(review["fname_user"] as! String) \(review["lname_user"] as! String)"
        usernameLabel.text = "\(review["username_user"] as! String)"
        starButtons.forEach({
            let state = $0.tag <= Int(userRate) ? true : false
            $0.isSelected = state
        })
    }

    @IBAction func starsTappedAction(_ sender: Any) {
        let button = sender as! UIButton
        userRate = button.tag
        starButtons.forEach({
            let state = $0.tag <= button.tag ? true : false
            $0.isSelected = state
        })
        
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
            return alert(message: "alert please fill all information.")
        }
        
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        let _  = self.navigationController?.popViewController(animated: true)
    }
    
    func setRateImage(rate:Int) {
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
        rateImage.image = UIImage(named: imageName)
    }
    
    
    func setProfileImage() {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
            self.profileImage.clipsToBounds = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ReviewUserViewController {
    
    func simulateRegister() {
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        let rate = 4
        let comment = commentTextField.text
        let iduserreview = review["id_user"]
        let iduser = userID
        let journeyid = journeyID
        var parameter = Parameters()
        parameter.updateValue(rate, forKey: "rate_review")
        parameter.updateValue(comment!, forKey: "comment_review")
        parameter.updateValue(iduser, forKey: "reviewer_id")
        parameter.updateValue(iduserreview!, forKey: "user_id_review")
        parameter.updateValue(journeyid, forKey: "journey_id")
        insertReviewData(parameter: parameter)
    }
    
    func insertReviewData(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "insertReviewData",
            "parameter": parameter
        ]
        
        let url = "http://localhost/friendforfare/post/index.php"
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
