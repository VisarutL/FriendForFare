//
//  JourneyViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

protocol JourneyDelegate:class {
    func journeyDidJoin()
}
class JourneyViewController:UIViewController {
    
    var closeBarButton = UIBarButtonItem()
    var myText:String?
    var trip = [String: Any]()
    var userjoinedList = [NSDictionary]()
    var profileList = [NSDictionary]()
    var rateProfile = [NSDictionary]()
    var rateProfileGirl = [NSDictionary]()
    

    
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropoffLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var imageProfile1: UIImageView!
    @IBOutlet weak var imageProfile2: UIImageView!
    @IBOutlet weak var imageProfile3: UIImageView!
    @IBOutlet weak var imageProfile4: UIImageView!
    @IBOutlet weak var username1Label: UILabel!
    @IBOutlet weak var username2Label: UILabel!
    @IBOutlet weak var username3Label: UILabel!
    @IBOutlet weak var username4Label: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var rateImage: UIImageView!
    @IBOutlet weak var rateImageGirl: UIImageView!

    weak var delegate:JourneyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myText = myText {
            title = myText
            print(myText)
        }
        setProfileImage()
        let idtrip = trip["id_journey"] as! String
        userJoined(idjourney: idtrip)
        selectOwnerJourney(idjourney: idtrip)
        viewSetting()
        setCloseButton()
        setInfomation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showMapPickup":
                let vc = segue.destination as! MapPickUpViewController
                vc.latitude = Double(trip["latitude_pick"] as! String)!
                vc.longitude = Double(trip["longitude_pick"] as! String)!
                vc.pick = (trip["pick_journey"] as! String)
                
            default:
                break
            }
        }
        
    }

    
    func viewSetting() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.tabbarColor
        view.backgroundColor = UIColor.white
    }
    
    func setCloseButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Close1"), for: .normal)
        button.sizeToFit()
        closeBarButton = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(self.self.closeAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func setProfile() {
        let path = "\(URLbase.URLbase)friendforfare/images/"
        let url = NSURL(string:"\(path)\(profileList[0]["pic_user"]!)")
        let data = NSData(contentsOf:url! as URL)
        if data == nil {
            profileImage.image = UIImage(named: "userprofile")
        } else {
            profileImage.image = UIImage(data:data as! Data)
        }
        fullnameLabel.text = "\(profileList[0]["fname_user"]!) \(profileList[0]["lname_user"]!)"
        telLabel.text = "Tel : \(profileList[0]["tel_user"]!)"
        let genderUser = UserDefaults.standard.integer(forKey: "UserGender")
        print(genderUser)
        if genderUser == 1 {
            rateImageGirl.isHidden = true
            if rateProfileGirl.count == 0 {
                setRateImageGirl(rate: 0)
            } else {
                let rategirl = "\(rateProfileGirl[0]["rategirl"]!)"
                let rateprofileGirl = Int(rategirl)
                if rateprofileGirl == nil {
                    setRateImageGirl(rate: 0)
                } else {
                    setRateImageGirl(rate: rateprofileGirl!)
                }
            }
            } else {
                rateImage.isHidden = true
                if rateProfile.count == 0 {
                    setRateImage(rate: 0)
                } else {
                    let rate = "\(rateProfile[0]["rate"]!)"
                    let rateprofile = Int(rate)
                    if rateprofile == nil {
                    } else {
                        setRateImage(rate: rateprofile!)
                    }
                }
            }
        }
    
    func setRateImageGirl(rate:Int) {
        var imageName = String()
        switch rate {
        case 1:
            imageName = "rate-g-1"
        case 2:
            imageName = "rate-g-2"
        case 3:
            imageName = "rate-g-3"
        case 4:
            imageName = "rate-g-4"
        case 5:
            imageName = "rate-g-5"
        default:
            imageName = "rate-g-0"
        }
        rateImageGirl.image = UIImage(named: imageName)
    }
    
    
    func setRateImage(rate:Int) {
        var imageName = String()
        switch rate {
        case 1:
            imageName = "rate-1"
        case 2:
            imageName = "rate-2"
        case 3:
            imageName = "rate-3"
        case 4:
            imageName = "rate-4"
        case 5:
            imageName = "rate-5"
        default:
            imageName = "rate-0"
        }
        rateImage.image = UIImage(named: imageName)
    }
    
    func setProfileImage() {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
            self.profileImage.clipsToBounds = true
            self.imageProfile1.layer.cornerRadius = self.imageProfile1.bounds.size.height / 2
            self.imageProfile1.clipsToBounds = true
            self.imageProfile2.layer.cornerRadius = self.imageProfile1.bounds.size.height / 2
            self.imageProfile2.clipsToBounds = true
            self.imageProfile3.layer.cornerRadius = self.imageProfile1.bounds.size.height / 2
            self.imageProfile3.clipsToBounds = true
            self.imageProfile4.layer.cornerRadius = self.imageProfile1.bounds.size.height / 2
            self.imageProfile4.clipsToBounds = true
        }
    }
    
    func setInfomation() {
        pickupLabel.text = "PICK-UP : \(trip["pick_journey"] as! String)"
        dropoffLabel.text = "DROP-OFF : \(trip["drop_journey"] as! String)"
        datetimeLabel.text = "\(trip["date_journey"] as! String) , \(trip["time_journey"] as! String)"
        countLabel.text = "\(userjoinedList.count)/\(trip["count_journey"] as! String)"
        detailTextView.text = "\(trip["detail_journey"] as! String)"
    }
    
    func handleJoinButton() {
        if userjoinedList.count == Int(trip["count_journey"] as! String)! {
            joinButton.setTitle("Full", for: .normal)
            joinButton.backgroundColor = UIColor.redBT
            joinButton.isEnabled = false
        }
        countLabel.text = "\(userjoinedList.count)/\(trip["count_journey"] as! String)"
    }
    
    @IBAction func joinAction(_ sender: Any) {
        let idjour = "\(trip["id_journey"] as! String)"
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        joinJourney(id: userID,idjour:idjour )
    }
    
}

extension JourneyViewController {
    
    func userJoined(idjourney:String) {
        let parameters: Parameters = [
            "function": "userJoined",
            "idjourney": idjourney
        ]
        let url = "\(URLbase.URLbase)friendforfare/get/index.php?function=userJoined"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
                        for item in JSON as! NSArray {
                            self.userjoinedList.append(item as! NSDictionary)
                        }
                        self.handleJoinButton()
                        self.loadImage()
                    }
                case .failure(let error):
                    print(error)
            }
        })
    }
    
    func selectOwnerJourney(idjourney:String) {
        let parameters: Parameters = [
            "function": "selectOwnerJourney",
            "idjourney": idjourney
        ]
        let url = "\(URLbase.URLbase)friendforfare/get/index.php?function=selectOwnerJourney"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
                        for item in JSON as! NSArray {
                            self.profileList.append(item as! NSDictionary)
                        }
                        let iduser = Int("\(self.profileList[0]["id_user"]!)")
                        self.avgrate(iduser: iduser!)
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func avgrate(iduser:Int) {
        let parameters: Parameters = [
            "function": "avgrate",
            "iduser" : iduser
        ]
        let url = "\(URLbase.URLbase)friendforfare/get/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //                debugPrint(response)
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        //                        print("JSON: \(JSON)")
                        for item in JSON as! NSArray {
                            self.rateProfile.append(item as! NSDictionary)
                        }
                        self.avgrategirl(iduser: iduser)
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func avgrategirl(iduser:Int) {
        let parameters: Parameters = [
            "function": "avgrategirl",
            "iduser" : iduser
        ]
        let url = "\(URLbase.URLbase)friendforfare/get/index.php"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //                debugPrint(response)
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        //                        print("JSON: \(JSON)")
                        for item in JSON as! NSArray {
                            self.rateProfileGirl.append(item as! NSDictionary)
                        }
                        self.setProfile()
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func loadImage() {
        var profileImages:[UIImageView] = [imageProfile1,imageProfile2,imageProfile3,imageProfile4]
        var allLabel:[UILabel] = [username1Label,username2Label,username3Label,username4Label]
        guard userjoinedList.count != 0 else { return }
        let count = userjoinedList.count - 1
        for i in 0...count {
            let user = userjoinedList[i]
            let pic_user = user["pic_user"] as! String
            let username_user = user["username_user"] as! String
            let path = "\(URLbase.URLbase)friendforfare/images/"
            let url = NSURL(string:"\(path)\(pic_user)")
            let data = NSData(contentsOf:url as! URL)
            let image = data == nil ? #imageLiteral(resourceName: "userprofile") : UIImage(data:data as! Data)
            profileImages[i].image = image
            allLabel[i].text = username_user
        }
    }
    
    func joinJourney(id:Int,idjour:String) {
        let userid = id
        let idjourney = idjour
        var parameter = Parameters()
        parameter.updateValue(userid, forKey: "user_id")
        parameter.updateValue(idjourney, forKey: "id_journey")
        insertUserService(parameter: parameter)
    }
    
    func insertUserService(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "joinJourney",
            "parameter": parameter
        ]
        let url = "\(URLbase.URLbase)friendforfare/post/index.php?function=joinJourney"
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
                    self.alert( message: "Wait for accept", withCloseAction: true)
                    
                case .failure(let error):
 
                    print(error.localizedDescription)
                }
            })
    }
}
