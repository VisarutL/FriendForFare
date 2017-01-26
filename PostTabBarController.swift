//
//  PostTabBarController.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire


protocol PostTabBarDelegate:class {
    func postTabBarDidClose()
}
class PostTabBarController:UIViewController {
    
    var closeBarButton = UIBarButtonItem()
    weak var delegate:PostTabBarDelegate?
    
    
    @IBOutlet weak var pickupTextField: UITextField!
    @IBOutlet weak var dropoffTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    
    var count = 1

    var allTextField:[UITextField] {
        return [
            pickupTextField,
            dropoffTextField,
            detailTextField
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCloseButton()
        oneButton.backgroundColor = UIColor.tabbarColor
        oneButton.setTitleColor(UIColor.black, for: .normal)
        oneButton.addTarget(self, action: #selector(selectCount), for: .touchUpInside)
        twoButton.addTarget(self, action: #selector(selectCount), for: .touchUpInside)
        threeButton.addTarget(self, action: #selector(selectCount), for: .touchUpInside)
        fourButton.addTarget(self, action: #selector(selectCount), for: .touchUpInside)
        oneButton.tag = 1
        twoButton.tag = 2
        threeButton.tag = 3
        fourButton.tag = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func postAction(_ sender: Any) {
        
        func checkTextField() -> Bool {
            for textField in allTextField {
                if textField.text?.characters.count == 0 { return false }
            }
            return true
        }
        
        if checkTextField() {
            addData()
        } else {
            let error = "alert please fill all information."
            print("error: \(error)")
        }

    }
    
    @IBAction func selectCount(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if ((button as AnyObject).tag == 1) {
            oneButton.backgroundColor = UIColor.tabbarColor
            oneButton.setTitleColor(UIColor.black, for: .normal)
            twoButton.backgroundColor = UIColor.textfield
            twoButton.setTitleColor(UIColor.black, for: .normal)
            threeButton.backgroundColor = UIColor.textfield
            threeButton.setTitleColor(UIColor.black, for: .normal)
            fourButton.backgroundColor = UIColor.textfield
            fourButton.setTitleColor(UIColor.black, for: .normal)
            count = 1
            print(count)
        } else if ((button as AnyObject).tag == 2) {
            oneButton.backgroundColor = UIColor.textfield
            oneButton.setTitleColor(UIColor.black, for: .normal)
            twoButton.backgroundColor = UIColor.tabbarColor
            twoButton.setTitleColor(UIColor.black, for: .normal)
            threeButton.backgroundColor = UIColor.textfield
            threeButton.setTitleColor(UIColor.black, for: .normal)
            fourButton.backgroundColor = UIColor.textfield
            fourButton.setTitleColor(UIColor.black, for: .normal)
            count = 2
            print(count)
        } else if ((button as AnyObject).tag == 3) {
            oneButton.backgroundColor = UIColor.textfield
            oneButton.setTitleColor(UIColor.black, for: .normal)
            twoButton.backgroundColor = UIColor.textfield
            twoButton.setTitleColor(UIColor.black, for: .normal)
            threeButton.backgroundColor = UIColor.tabbarColor
            threeButton.setTitleColor(UIColor.black, for: .normal)
            fourButton.backgroundColor = UIColor.textfield
            fourButton.setTitleColor(UIColor.black, for: .normal)
            count = 3
            print(count)
        } else if ((button as AnyObject).tag == 4) {
            oneButton.backgroundColor = UIColor.textfield
            oneButton.setTitleColor(UIColor.black, for: .normal)
            twoButton.backgroundColor = UIColor.textfield
            twoButton.setTitleColor(UIColor.black, for: .normal)
            threeButton.backgroundColor = UIColor.textfield
            threeButton.setTitleColor(UIColor.black, for: .normal)
            fourButton.backgroundColor = UIColor.tabbarColor
            fourButton.setTitleColor(UIColor.black, for: .normal)
            count = 4
            print(count)
        }
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
    func setCloseButton() {
        closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeAction))
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    func closeAction() {
        delegate?.postTabBarDidClose()
    }
    
}


extension PostTabBarController {
    
    func addData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let pickup = pickupTextField.text
        let dropoff = dropoffTextField.text
        let detail = detailTextField.text
        let countjourney = count
        let userid = appDelegate.userID
        var parameter = Parameters()
        parameter.updateValue(pickup!, forKey: "pick_journey")
        parameter.updateValue(dropoff!, forKey: "drop_journey")
        parameter.updateValue(countjourney, forKey: "count_journey")
        parameter.updateValue(detail!, forKey: "detail_journey")
        parameter.updateValue(userid, forKey: "user_id_create")
        insertUserService(parameter: parameter)
    }
    func insertUserService(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "insertPost",
            "parameter": parameter
        ]
        let url = "http://worawaluns.in.th/friendforfare/post/index.php?function=insertPost"
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
                    
                    self.delegate?.postTabBarDidClose()
                    
                    //status 202
                    print(JSON)
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
            })
    }
}
