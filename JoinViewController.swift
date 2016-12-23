//
//  JoinViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/24/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class JoinViewController:UIViewController {
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
