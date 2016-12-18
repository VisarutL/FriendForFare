//
//  RegsiterViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/13/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class RegsiterViewController: UIViewController {
    
    
    @IBOutlet weak var fristNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    var fName:String?
    var lName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fristNameTextField.delegate = self
        fristNameTextField.tag = 0
        lastNameTextField.delegate = self
        lastNameTextField.tag = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func createAction(_ sender: Any) {
        if let fName = fName,
        let lName = lName {
            print("value: \(fName)")
            print("value: \(lName)")
            
        } else {
            print("fuck you")
        }
    }
    
    @IBAction func cancelDidTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}

extension RegsiterViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText:NSString = textField.text! as NSString
        let newText:NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        print(newText)
        
        switch textField.tag {
        case 0:
            fName = newText as String
        case 1:
            lName = newText as String
        default:
            break
        }
        return true
    }
}
