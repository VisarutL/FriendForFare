//
//  TabBarViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.tabBar.barTintColor = UIColor.tabbarColor
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(tabBarController.selectedIndex)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.tabBar.barTintColor = .yellow
//        let item1 = Item1ViewController()
//        let icon1 = UITabBarItem(title: "Title", image: UIImage(named: "someImage.png"), selectedImage: UIImage(named: "otherImage.png"))
//        item1.tabBarItem = icon1
//        let controllers = [item1]  //array of the root view controllers displayed by the tab bar interface
//        self.viewControllers = controllers

    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}

