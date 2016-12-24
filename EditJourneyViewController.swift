//
//  EditJourneyViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/24/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class EditJourneyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

