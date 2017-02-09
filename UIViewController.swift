//
//  UIViewController.swift
//  FriendForFare
//
//  Created by Visarut on 2/9/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title:String? = "",message:String = "") {
        let alert = UIAlertController(title:title, message:message, preferredStyle:.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
}
