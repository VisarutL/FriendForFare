//
//  JourneyViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class JourneyViewController:UIViewController {
    
    var closeBarButton = UIBarButtonItem()
    var myText:String?
    var trip = [String: Any]()
    var userjoinedList = [NSDictionary]()
    

    
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropoffLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var imageProfile1: UIImageView!
    @IBOutlet weak var imageProfile2: UIImageView!
    @IBOutlet weak var imageProfile3: UIImageView!
    @IBOutlet weak var imageProfile4: UIImageView!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myText = myText {
            title = myText
            print(myText)
        }
        setProfileImage()
        let idtrip = "\(trip["id_journey"] as! String)"
        selectData(idjourney: idtrip)
        viewSetting()
        setCloseButton()
        pickupLabel.text = "PICK-UP : \(trip["pick_journey"] as! String)"
        dropoffLabel.text = "DROP-OFF : \(trip["drop_journey"] as! String)"
        datetimeLabel.text = "\(trip["date_journey"] as! String) , \(trip["time_journey"] as! String)"
        countLabel.text = "\(userjoinedList.count)/\(trip["count_journey"] as! String)"
        detailTextView.text = "\(trip["detail_journey"] as! String)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countLabel.text = "\(userjoinedList.count)/\(trip["count_journey"] as! String)"
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
        closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeAction))
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func setProfileImage() {
        DispatchQueue.main.async {
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
    
    func loadImage() {
        var profileImages:[UIImageView] = [imageProfile1,imageProfile2,imageProfile3,imageProfile4]
        guard userjoinedList.count != 0 else { return }
        let count = userjoinedList.count - 1
        for i in 0...count {
            let path = "http://worawaluns.in.th/friendforfare/images/"
            let imageName = "\(userjoinedList[i]["pic_user"] as! String)"
            let url = NSURL(string:"\(path)\(imageName)")
            let data = NSData(contentsOf:url as! URL)
            let image = data == nil ? #imageLiteral(resourceName: "userprofile") : UIImage(data:data as! Data)
            profileImages[i].image = image
        }
    }
    
    @IBAction func joinAction(_ sender: Any) {
        let idjour = "\(trip["id_journey"] as! String)"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        joinJourney(id:appDelegate.userID,idjour:idjour )
    }
    
}

extension JourneyViewController {
    
    func selectData(idjourney:String) {
        let parameters: Parameters = [
            "function": "userJoined",
            "idjourney": idjourney
        ]
        let url = "http://worawaluns.in.th/friendforfare/get/index.php?function=userJoined"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
                switch response.result {
                case .success:
                    
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        for item in JSON as! NSArray {
                            self.userjoinedList.append(item as! NSDictionary)
                        }
                        self.loadImage()
                    }
                case .failure(let error):
                    print(error)
            }
        })
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
        let url = "http://worawaluns.in.th/friendforfare/post/index.php?function=joinJourney"
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
                    //status 202
                    print(JSON)
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
            })
        
    }
}
