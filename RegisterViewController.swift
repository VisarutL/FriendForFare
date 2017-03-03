//
//  RegsiterViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/13/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fristNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkpasswordTextField: UITextField!
    @IBOutlet weak var maleBt: UIButton!
    @IBOutlet weak var femaleBt: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    var activeField: UITextField?
    @IBOutlet weak var scrollView: UIScrollView!
    var allTextField:[UITextField] {
        return [
            fristNameTextField,
            lastNameTextField,
            emailTextField,
            telTextField,
            usernameTextField,
            passwordTextField,
            checkpasswordTextField
        ]
    }
    
    var picker = UIImagePickerController()
    var genderButtonToggle = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageSetting()
        genderButtonToggle = true
        maleBt.backgroundColor = UIColor.tabbarColor
        
        
        
        allTextField.forEach({ $0.delegate = self })
        registerForKeyboardNotifications()
    }
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }

    @IBAction func createAction(_ sender: Any) {
        
        func checkTextField() -> Bool {
            for textField in allTextField {
                if textField.text?.characters.count == 0 { return false }
            }
            return true
        }
        
        if checkTextField() {
            uploadUserImage()
            
        } else {
            return alert(message: "alert please fill all information.")
        }
    }

    @IBAction func uploadImage(_ sender: Any) {
        uploadimage()
    }
    
    @IBAction func cancelDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func maleAction(_ sender: Any) {
        genderButtonToggle = true
        maleBt.backgroundColor = UIColor.tabbarColor
        maleBt.setTitleColor(UIColor.black, for: .normal)
        femaleBt.backgroundColor = UIColor.textfield
        femaleBt.setTitleColor(UIColor.black, for: .normal)
    }

    @IBAction func femaleAction(_ sender: Any) {
        genderButtonToggle = false
        maleBt.backgroundColor = UIColor.textfield
        maleBt.setTitleColor(UIColor.black, for: .normal)
        femaleBt.backgroundColor = UIColor.tabbarColor
        femaleBt.setTitleColor(UIColor.black, for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func openCamera() {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title:"Error", message:"No camera", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    func openGallary(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        print("picker cancel.")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func profileImageSetting(){
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
    }
    
    func uploadimage() {
        let title = "Choose Profile Image"
        
        let alert = UIAlertController(title:title, message:nil, preferredStyle:.alert)
        let camera = UIAlertAction(title: "Camera", style: .default,
                                   handler: { action in
                                    self.openCamera()
        })
        let album = UIAlertAction(title: "Album", style: .default,
                                  handler: { action in
                                    self.openGallary()
        })
        let cancle = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(cancle)
        self.present(alert, animated: true, completion: nil)
    }

}

extension RegisterViewController {
    
    func simulateRegister(uid:String) {
        let fname = fristNameTextField.text
        let lname = lastNameTextField.text
        let email = emailTextField.text
        let tel = telTextField.text
        let gender = genderButtonToggle == true ? "1" : "2"
        let username = usernameTextField.text
        let password = passwordTextField.text
        var parameter = Parameters()
        parameter.updateValue(fname!, forKey: "fname_user")
        parameter.updateValue(lname!, forKey: "lname_user")
        parameter.updateValue(email!, forKey: "email_user")
        parameter.updateValue(tel!, forKey: "tel_user")
        parameter.updateValue(gender, forKey: "gender_user")
        parameter.updateValue(username!, forKey: "username_user")
        parameter.updateValue(password!, forKey: "password_user")
        parameter.updateValue(uid, forKey: "pic_user")
        insertUserService(parameter: parameter)
    }
    
    func insertUserService(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "insertUser",
            "parameter": parameter
        ]
        //        let oldParameters: Parameters = [
        //            "function": "insertUser",
        //            "parameter": [
        //                "UserID": "2016120005",
        //                "UserName": "test",
        //                "UserPassword": "password",
        //            ]
        //        ]
        
        let url = "http://worawaluns.in.th/friendforfare/post/index.php?function=insertUser"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
                switch response.result {
                case .success:
                    guard let JSON = response.result.value as! [String : Any]? else {
                        print("error: cannnot cast result value to JSON or nil.")
                        return
                    }
                    
                    let status = JSON["status"] as! String
                    if  status == "404" {
                        print("error: \(JSON["message"] as! String)")
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    //status 202
//                    print(JSON)
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
            })
        
    }
    
    func uploadUserImage() {
        //mark: - set folder permition using command line
        //chmod -Rf 777 "FOLDER_PATH"
        let imageFile = profileImage.image
        let imageData = UIImageJPEGRepresentation(imageFile!, 0.5)!
        let parameters: Parameters = [
            "function": "uploadImage"
        ]
        let url = "http://worawaluns.in.th/friendforfare/post/index.php?function=uploadImage"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData, withName: "image", fileName: "\(imageData).jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                    
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: url,
            encodingCompletion: { encodingResult in
//                debugPrint(encodingResult)
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        debugPrint(response)
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            let imageLocation = JSON.object(forKey: "filepath") as? String
                            
                            let uniqid = JSON["uniqid"] as! String
                            self.simulateRegister(uid:uniqid)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }

}

//mark: - keyboard
extension RegisterViewController {
    
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        print("registerForKeyboardNotifications")
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        print("deregisterFromKeyboardNotifications")
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(_ notification: Notification) {
        print("keyboardWasShown")
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(64, 0.0, keyboardSize!.height+40, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height+40
        if let _ = activeField{
            if (!aRect.contains(activeField!.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(_ notification: Notification){
        print("keyboardWillBeHidden")
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(64, 0.0, -keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("textFieldDidBeginEditing")
        textField.textColor = UIColor.black
//        #selector(self.closeAction)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        print("textFieldDidEndEditing")
        activeField = nil
    }
    
    func didTapView() {
        self.view.endEditing(true)
    }
}
