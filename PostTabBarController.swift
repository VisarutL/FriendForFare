//
//  PostTabBarController.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
protocol PostTabBarDelegate:class {
    func postTabBarDidClose()
}
class PostTabBarController:UIViewController {
    var closeBarButton = UIBarButtonItem()
    weak var delegate:PostTabBarDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setCloseButton() {
        closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeAction))
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    func closeAction() {
        delegate?.postTabBarDidClose()
    }
}
