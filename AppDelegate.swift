//
//  AppDelegate.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import CoreLocation

import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userID = Int()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setNavigationBarAppearace()
        
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        if userID > 0 {
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nvc = storyBoard.instantiateViewController(withIdentifier: "NavTabBarController") as! TabBarViewController
                self.window!.rootViewController = nvc
            }
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        if userID > 0 {
            setLocationService()
        }
        return true
    }
    
    public func application(_ app: UIApplication,open url: URL,options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open : url as URL!,
            sourceApplication:
            options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any
        )
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation:Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation:annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        LocationService.sharedInstance.stopUpdatingLocation()
    }

    func setNavigationBarAppearace() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.black
        navigationBarAppearace.barTintColor = UIColor.tabbarColor
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
    }
}

extension AppDelegate : LocationServiceDelegate {
    func setLocationService() {
        LocationService.sharedInstance.delegate = self
        LocationService.sharedInstance.startUpdatingLocation()
    }
    
    func tracingLocation(_ currentLocation: CLLocation) {

    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
    
    }
}

