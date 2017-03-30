//
//  ViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fbloginButton: FBSDKLoginButton!
    
    
    var userlogin = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = FIRInstanceID.instanceID().token()
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        print("InstanceID token: \(token!)")
        print("userID: \(userID)")
    
        configureFacebook()
    
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }

    
    @IBAction func loginAction(_ sender: Any) {
        guard let name = nameTextField.text , name != "",
            let password = passwordTextField.text , password != "" else {
            return alert(message: "wrong username or password !!!")
        }

        loginData(username:name,password:password)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func login(iduser:Int,genderuser:Int) {
        print("userID: \(iduser)")
        print("uesrGender: \(genderuser)")
        UserDefaults.standard.set(iduser, forKey: "UserID")
        UserDefaults.standard.set(genderuser, forKey: "UserGender")
        self.presentNavTabBarController()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.setLocationService()
//       
//        let currentLocation = LocationService.sharedInstance.currentLocation
//        let latitude = currentLocation?.coordinate.latitude
//        let longitude = currentLocation?.coordinate.longitude
//        print("latitude:\(latitude), longitude:\(longitude)")
//        if latitude! > 0 || longitude! > 0  {
//            self.presentNavTabBarController()
//        }
        
    }
    
    func presentNavTabBarController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nvc = storyBoard.instantiateViewController(withIdentifier: "NavTabBarController") as! TabBarViewController
        self.present(nvc, animated: true, completion: nil)
    }

}

extension ViewController:FBSDKLoginButtonDelegate {

    func configureFacebook() {
        fbloginButton.readPermissions = ["public_profile", "email", "user_friends"];
        fbloginButton.delegate = self
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        
        
        let parameter = ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]
        //        let parameter = ["fields":"first_name,last_name, picture.type(large)"]
        FBSDKGraphRequest.init(graphPath: "me", parameters: parameter).start {
            (conncetion, result, error) -> Void in
            
            guard error == nil else {
                return self.alert(title:"loginButton",message: "fb login: \(error?.localizedDescription)")
            }
            
            if ((FBSDKAccessToken.current()) != nil) {
                let resultDictionary = result as? [String : AnyObject]
                self.registerAction(dict: resultDictionary!)
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func registerAction(dict:[String : AnyObject]) {

        let picture = dict["picture"] as! NSDictionary
        let data = picture["data"]  as! NSDictionary
        let imageUrl = data["url"] as! String
        let gender = dict["gender"] as! String
        let last_name = dict["last_name"] as! String
        let name = dict["name"] as! String
        let id = dict["id"] as! String
        let first_name = dict["first_name"] as! String
        
        var userImage =  UIImage()
        if let url = NSURL(string: imageUrl) {
            if let data = NSData(contentsOf: url as URL) {
                userImage = UIImage(data: data as Data)!
            }
        }
        
        let imageFile = userImage
        let imageData = UIImageJPEGRepresentation(imageFile, 0.5)!
        let parameters: Parameters = [
            "function": "registerUser",
            "gender": gender,
            "first_name": first_name,
            "last_name": last_name,
            "name": name,
            "id": id
        ]
        let url = "\(URLbase.URLbase)friendforfare/post/index.php"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData, withName: "image", fileName: "\(imageData).jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                    
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: url,
            encodingCompletion: { encodingResult in
                //                debugPrint(encodingResult)
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
//                        debugPrint(response)
                        switch response.result {
                        case .success:
                            if let JSON = response.result.value as? NSDictionary {
                                print("JSON: \(JSON)")
                                let status = JSON["status"] as! String
                                switch status {
                                case "202":
                                    let id = JSON["iduser"] as! Int
                                    let gender = JSON["gender"] as! Int
                                    UserDefaults.standard.set(id, forKey: "UserID")
                                    UserDefaults.standard.set(gender, forKey: "UserGender")
                                    self.presentNavTabBarController()
                                case "303":
                                    let id = JSON["iduser"] as! Int
                                    let gender = JSON["gender"] as! Int
                                    UserDefaults.standard.set(id, forKey: "UserID")
                                    UserDefaults.standard.set(gender, forKey: "UserGender")
                                    self.presentNavTabBarController()
                                case "404":
                                    let message = JSON["message"] as! String
                                    print("error: \(message)")
                                default:
                                    print("error: \(JSON)")
                                    break
                                }
                                
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        
                        }
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
        
    }

}

extension ViewController:RequestFormDelegate {
    
    func requestFormDidClose(){
         dismiss(animated: true, completion: nil)
    }
    
    func requestFormDidCompleteAction(){
        
    }
    
}

extension ViewController {
    func loginData(username:String,password:String) {
        let parameters: Parameters = [
            "function": "loginData",
            "username": username,
            "password": password
            
        ]
        let url = "\(URLbase.URLbase)friendforfare/get/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        let json = JSON(result)
                        let status = json["status"].stringValue
                        switch status {
                        case "202":
                            let iduser = json["iduser"].intValue
                            let gender = json["gender"].intValue
                            self.login(iduser: iduser,genderuser: gender )
                        case "404":
                            let message = json["message"].stringValue
                            self.alert(message: "\(message)")
                        default:
                            print("error: \(json)")
                            break
                        }
//                        print("JSON: \(JSON)")

                    }
                case .failure(let error):
                    self.alert(title: "", message: "login: \(error.localizedDescription)", withCloseAction: false)
                }
            })
    }
}
