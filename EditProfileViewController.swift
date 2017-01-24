//
//  EditProfileViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/13/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices

protocol EditProfileViewDelegate:class {
    func editProfileViewDidFinish()
}

class EditProfileViewController: UIViewController {
    
    var fname = String()
    var lname = String()
    var tel = String()
    var email = String()
    var picuser = String()
    var userid = String()
    
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!

    var profileList = [NSDictionary]()
    
    var allTextField:[UITextField] {
        return [
            firstnameTextField,
            lastnameTextField,
            emailTextField,
            telTextField,
        ]
    }
    
    var picker = UIImagePickerController()
    
    weak var delegate:EditProfileViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageSetting()
        
        let path = "http://worawaluns.in.th/friendforfare/images/"
        let url = NSURL(string:"\(path)\(picuser)")
        let data = NSData(contentsOf:url! as URL)
        profileimage.image = UIImage(data:data as! Data)
        firstnameTextField.text = fname
        lastnameTextField.text = lname
        emailTextField.text = email
        telTextField.text = tel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDone(_ sender: Any) {
        
        func checkTextField() -> Bool {
            for textField in allTextField {
                if textField.text?.characters.count == 0 { return false }
            }
            return true
        }
        
        if checkTextField() {
            uploadUserImage()
            
        } else {
            let error = "alert please fill all information."
            print("error: \(error)")
        }
        
    }

    @IBAction func uploadImage(_ sender: Any) {
        uploadimage()
    }
    
}

extension EditProfileViewController {
    
    func simulateEdit(uid:String) {
        let fname = firstnameTextField.text
        let lname = lastnameTextField.text
        let email = emailTextField.text
        let tel = telTextField.text
        var parameter = Parameters()
        parameter.updateValue(userid, forKey: "userid")
        parameter.updateValue(fname!, forKey: "fname_user")
        parameter.updateValue(lname!, forKey: "lname_user")
        parameter.updateValue(email!, forKey: "email_user")
        parameter.updateValue(tel!, forKey: "tel_user")
        parameter.updateValue(uid, forKey: "pic_user")
        updateProfile(parameter: parameter)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func updateProfile(parameter:Parameters)  {
        let parameters: Parameters = [
            "function": "updateProfile",
            "parameter": parameter
        ]
        
        let url = "http://worawaluns.in.th/friendforfare/update/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                debugPrint(response)
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
                    
                    self.delegate?.editProfileViewDidFinish()
                    
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
        let imageFile = profileimage.image
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
                        
//                        debugPrint(response)
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
//                            let imageLocation = JSON.object(forKey: "filepath") as? String
                            
                            let uniqid = JSON["uniqid"] as! String
                            self.simulateEdit(uid:uniqid)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
}

extension EditProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
        profileimage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func profileImageSetting(){
        profileimage.layer.cornerRadius = profileimage.frame.size.width/2
        profileimage.clipsToBounds = true
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
