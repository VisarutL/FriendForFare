//
//  EditJourneyViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/24/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class EditJourneyViewController: UIViewController {
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    var count = 1
    var idjourney = Int()
    
    var allTextField:[UITextField] {
        return [
            detailTextField
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    @IBAction func dateAction(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(PostTabBarController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func timeAction(_ sender: UITextField) {
        let timePickerView:UIDatePicker = UIDatePicker()
        
        timePickerView.datePickerMode = UIDatePickerMode.time
        timePickerView.locale = NSLocale(localeIdentifier: "NL") as Locale
        sender.inputView = timePickerView
        timePickerView.addTarget(self, action: #selector(PostTabBarController.timePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func timePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeTextField.text = dateFormatter.string(from: sender.date)
        
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

    @IBAction func doneAction(_ sender: Any) {
        func checkTextField() -> Bool {
            for textField in allTextField {
                if textField.text?.characters.count == 0 { return false }
            }
            return true
        }
        
        if checkTextField() {
            updateData()
        } else {
            let error = "alert please fill all information."
            print("error: \(error)")
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        deletePost()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
}

extension EditJourneyViewController {
    func updateData() {
        let detail = detailTextField.text
        let idtrip = idjourney
        let countjourney = count
        let date = dateTextField.text
        let time = timeTextField.text
        var parameter = Parameters()
        parameter.updateValue(countjourney, forKey: "count_journey")
        parameter.updateValue(date!, forKey: "date_journey")
        parameter.updateValue(time!, forKey: "time_journey")
        parameter.updateValue(detail!, forKey: "detail_journey")
        parameter.updateValue(idtrip, forKey: "id_journey")
        insertUserService(parameter: parameter)
    }
    func insertUserService(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "updateData",
            "parameter": parameter
        ]
        let url = "http://worawaluns.in.th/friendforfare/post/index.php?function=updateData"
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
    
    func deletePost() {
        let idtrip = idjourney
        var parameter = Parameters()
        parameter.updateValue(idtrip, forKey: "id_journey")
        insertData(parameter: parameter)
    }
    func insertData(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "deletePost",
            "parameter": parameter
        ]
        let url = "http://worawaluns.in.th/friendforfare/post/index.php?function=deletePost"
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

