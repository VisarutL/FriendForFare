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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myText = myText {
            title = myText
            print(myText)
        }
        let idtrip = "\(trip["id_journey"] as! String)"
        selectData(idjourney: idtrip)
        viewSetting()
        setCloseButton()
        pickupLabel.text = "PICK-UP : \(trip["pick_journey"] as! String)"
        dropoffLabel.text = "DROP-OFF : \(trip["drop_journey"] as! String)"
        datetimeLabel.text = "\(trip["date_journey"] as! String) , \(trip["time_journey"] as! String)"
        countLabel.text = "0/\(trip["count_journey"] as! String)"
        detailTextView.text = "\(trip["detail_journey"] as! String)"
        print(userjoinedList)
        loadImage()
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
        closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeAction))
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func loadImage() {
        
        var profileImages:[UIImageView] = [imageProfile1,imageProfile2,imageProfile3,imageProfile4]
        let row = userjoinedList.count
            print(row)

        var profileImageNames = ["","","",""]
        for i in 0...3 {
            let path = "http://worawaluns.in.th/friendforfare/images/"
            let url = NSURL(string:"\(path)\(profileImageNames[i])")
            let data = NSData(contentsOf:url as! URL)
            let image = data == nil ? #imageLiteral(resourceName: "userprofile") : UIImage(data:data as! Data)
            profileImages[i].image = image
        }
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
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
}
