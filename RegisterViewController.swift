//
//  RegsiterViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/13/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var fristNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkpasswordTextField: UITextField!
    
    var fName:String?
    var lName:String?
    var email:String?
    var tel:String?
    var username:String?
    var password:String?
    var checkpassword:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fristNameTextField.delegate = self
        fristNameTextField.tag = 0
        lastNameTextField.delegate = self
        lastNameTextField.tag = 1
        emailTextField.delegate = self
        emailTextField.tag = 2
        telTextField.delegate = self
        telTextField.tag = 3
        usernameTextField.delegate = self
        usernameTextField.tag = 4
        passwordTextField.delegate = self
        passwordTextField.tag = 5
        checkpasswordTextField.delegate = self
        checkpasswordTextField.tag = 6
        
        
        callService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func callService(){
        //        selectUserService()
        
        uploadUserImage()
        
        
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
    func selectUserService() {
        let parameters: Parameters = [
            "function": "selectUser"
        ]
        let url = "http://localhost/friendforfare/get/index.php?function=testSelect"
        let manager = initManager()
        manager.request(url, method: .get, parameters: parameters, encoding:URLEncoding.default, headers:nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //debugPrint(response)
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
                    
                    //status 202
                    print(JSON["user"]!)
                    
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
                
            })
    }
    
    func simulateRegister() {
        let fname = fristNameTextField.text
        let lname = lastNameTextField.text
        let email = emailTextField.text
        let tel = telTextField.text
        let gender = "1"
        let username = usernameTextField.text
        let password = passwordTextField.text
        var parameter = Parameters()
        parameter.updateValue(fname!, forKey: "fname_user")
        parameter.updateValue(lname!, forKey: "lname_user")
        parameter.updateValue(email!, forKey: "email_user")
        parameter.updateValue(tel!, forKey: "tel_user")
        parameter.updateValue(gender, forKey: "gender_user")
        parameter.updateValue(username!, forKey: "uesrname_user")
        parameter.updateValue(password!, forKey: "password_user")
        insertUserService(parameter: parameter)
    }
    
    func insertUserService(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "insertUser",
            "parameter": parameter
        ]
        
        //        let oldParameters: Parameters = [
        //            "function": "insertUser",
        //            "parameter": [
        //                "UserID": "2016120005",
        //                "UserName": "test",
        //                "UserPassword": "password",
        //            ]
        //        ]
        
        let url = "http://localhost/friendforfare/post/index.php?function=insertUser"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //debugPrint(response)
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
                    
                    //status 202
                    print(JSON)
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
            })
        
    }
    
    func uploadUserImage() {
        //mark: - set folder permition using command line
        //chmod -Rf 777 "FOLDER_PATH"
        let icFacebook = "pic"
        let imageFile = UIImage(named: icFacebook)!
        let imageData = UIImageJPEGRepresentation(imageFile, 0.5)!
        let parameters: Parameters = [
            "function": "uploadImage",
            "userID": "2016120008"
        ]
        let url = "http://localhost/friendforfare/post/index.php?function=uploadImage"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData, withName: "image", fileName: "\(icFacebook).jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                    
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: url,
            encodingCompletion: { encodingResult in
                debugPrint(encodingResult)
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        debugPrint(response)
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            //let imageLocation = JSON.object(forKey: "filepath") as? String
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    
    
    @IBAction func createAction(_ sender: Any) {
//        if let fName = fName,
//        let lName = lName {
//            print("value: \(fName)")
//            print("value: \(lName)")
//            
//        } else {
//            print("fuck you")
//        }
        
        simulateRegister()
        
    }
    
    @IBAction func cancelDidTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    
    
}

extension RegisterViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText:NSString = textField.text! as NSString
        let newText:NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        print(newText)
        
        switch textField.tag {
        case 0:
            fName = newText as String
        case 1:
            lName = newText as String
        case 2:
            email = newText as String
        case 3:
            tel = newText as String
        case 4:
            username = newText as String
        case 5:
            password = newText as String
        case 6:
            checkpassword = newText as String
        default:
            break
        }
        return true
    }
}
