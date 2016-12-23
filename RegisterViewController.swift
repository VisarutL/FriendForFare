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
class RegisterViewController: UIViewController {
    
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
        maleBt.backgroundColor = UIColor.gray
        callService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func callService(){
        //        selectUserService()
        uploadUserImage()
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
            print("fuck new")
            //        simulateRegister()
        } else {
            let error = "alert please fill all information."
            print("error: \(error)")
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
    func selectUserService() {
        let parameters: Parameters = [
            "function": "selectUser"
        ]
        let url = "http://localhost/friendforfare/get/index.php?function=selectUser"
        let manager = initManager()
        manager.request(url, method: .get, parameters: parameters, encoding:URLEncoding.default, headers:nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //debugPrint(response)
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
                    
                    //status 202
                    print(JSON["user"]!)
                    
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
                
            })
    }
    
    func simulateRegister() {
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
        parameter.updateValue(username!, forKey: "uesrname_user")
        parameter.updateValue(password!, forKey: "password_user")
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
        
        let url = "http://localhost/friendforfare/post/index.php?function=insertUser"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //debugPrint(response)
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
                    
                    //status 202
                    print(JSON)
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
            })
        
    }
    
    func uploadUserImage() {
        //mark: - set folder permition using command line
        //chmod -Rf 777 "FOLDER_PATH"
        let icFacebook = "ic-facebook"
        let imageFile = UIImage(named: icFacebook)!
        let imageData = UIImageJPEGRepresentation(imageFile, 0.5)!
        let parameters: Parameters = [
            "function": "uploadImage"
        ]
        let url = "http://localhost/friendforfare/post/index.php"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData, withName: "image", fileName: "\(icFacebook).jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                    
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: url,
            encodingCompletion: { encodingResult in
                debugPrint(encodingResult)
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        debugPrint(response)
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            let imageLocation = JSON.object(forKey: "filepath") as? String
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }

}
