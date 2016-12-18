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



    @IBOutlet weak var fbloginButton: FBSDKLoginButton!
    @IBAction func loginButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "TabViewList", bundle: nil)
        let nvc = storyBoard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        let vc = nvc.topViewController as! ListTapBarController
        vc.requestFormDelegate = self
        self.present(nvc, animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureFacebook()
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



}

extension ViewController:RequestFormDelegate {
    func requestFormDidClose(){
         dismiss(animated: true, completion: nil)
    }
    func requestFormDidCompleteAction(){
        
    }
}
