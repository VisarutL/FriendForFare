//
//  TabBarViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var reserveIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = UIColor.tabColor
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PostTabBarController") as! PostTabBarController
            vc.delegate = self
            let nvc = UINavigationController(rootViewController: vc)
            present(nvc, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        reserveIndex = tabBarController.selectedIndex
        return (tabBarController.selectedViewController != viewController);
    }

}

extension TabBarViewController:PostTabBarDelegate {
    func postTabBarDidClose() {
        self.selectedIndex = reserveIndex
        DispatchQueue.main.async {
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}


