//
//  ViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController,FBSDKLoginButtonDelegate {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var fbloginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        print("userID: \(userID)")
        
        configureFacebook()
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let name = nameTextField.text , name != "",
            let password = passwordTextField.text , password != "" else {
            return alert(message: "wrong username or password !!!")
        }
        
//        loginData(username:name,password:password)
        let userID = 1
        UserDefaults.standard.set(userID, forKey: "UserID")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nvc = storyBoard.instantiateViewController(withIdentifier: "NavTabBarController") as! TabBarViewController
        self.present(nvc, animated: true, completion: nil)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, gender, picture"]).start {
            (connection, result, error) -> Void in
            
            let resultDictionary = result as? [String : AnyObject]
            print("result facebook \(resultDictionary)!")
            UserDefaults.standard.setValue(resultDictionary, forKey: "datalogin")
            self.performSegue(withIdentifier: "mainTabViewController", sender: self)
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func configureFacebook()
    {
        fbloginButton.readPermissions = ["public_profile", "email", "user_friends"];
        fbloginButton.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension ViewController:RequestFormDelegate {
    func requestFormDidClose(){
         dismiss(animated: true, completion: nil)
    }
    func requestFormDidCompleteAction(){
        
    }
}

//extension ViewController {
//    func loginData() {
//        let parameters: Parameters = [
//            "function": "journeySelect",
//            "iduser" : iduser,
//            "latitude": latt,
//            "longitude": longg
//        ]
//        let url = "http://localhost/friendforfare/get/index.php"
//        let manager = initManager()
//        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
//            .responseJSON(completionHandler: { response in
//                manager.session.invalidateAndCancel()
//                //                debugPrint(response)
//                switch response.result {
//                case .success:
//                    if let JSON = response.result.value {
//                        //                    print("JSON: \(JSON)")
//                        
//                        for trip in JSON as! NSArray {
//                            self.tripList.append(trip as! NSDictionary)
//                            self.filteredTripList = self.tripList
//                        }
//                        
//                        let now = NSDate()
//                        let updateString = "Last Update at " + self.dateFormatter.string(from: now as Date)
//                        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
//                        
//                    }
//                    
//                    self.cpGroup.leave()
//                case .failure(let error):
//                    print(error)
//                    self.cpGroup.leave()
//                }
//            })
//    }
//}
