//
//  UIViewController.swift
//  FriendForFare
//
//  Created by Visarut on 2/9/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title:String? = "",message:String = "",withCloseAction close:Bool? = false) {
        let alert = UIAlertController(title:title, message:message, preferredStyle:.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            if close! {
                self.dismiss(animated: true, completion: nil)
            }
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
        self.view.tintColor = UIColor.black
    }
    
    
}
