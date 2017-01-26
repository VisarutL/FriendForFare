//
//  DetailJourneyViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/18/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire
class DetailJourneyViewController:UIViewController {
    
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var dropoffLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var profile1ImageView: UIImageView!
    @IBOutlet weak var profile2ImageView: UIImageView!
    @IBOutlet weak var profile3ImageView: UIImageView!
    @IBOutlet weak var profile4ImageView: UIImageView!
    
    var tripDetail = [String: Any]()
    var closeBarButton = UIBarButtonItem()
    var myText:String?
    var joinButtonToggle:String?
    var commentlist = [NSDictionary]()
    var userjoinedList = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProfileImage()
        viewSetting()
        tableViewSetting()
        setCloseButton()
        selectData()
        loadImage()
        
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countLabel.text = "\(userjoinedList.count)/\(tripDetail["count_journey"] as! String)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showMapPickup":
                let vc = segue.destination as! MapPickUpViewController
                switch joinButtonToggle!.lowercased() {
                case "myTrip".lowercased():
                    vc.latitude = Double(tripDetail["latitude_pick"] as! String)!
                    vc.longitude = Double(tripDetail["longitude_pick"] as! String)!
                    vc.pick = (tripDetail["pick_journey"] as! String)
                case "otherTrip".lowercased():
                    vc.latitude = Double(tripDetail["latitude_pick"] as! String)!
                    vc.longitude = Double(tripDetail["longitude_pick"] as! String)!
                    vc.pick = (tripDetail["pick_journey"] as! String)
                default:
                    break
                }
            case "editPost":
                let vcc = segue.destination as! EditJourneyViewController
                switch joinButtonToggle!.lowercased() {
                case "myTrip".lowercased():
                    vcc.idjourney = Int(tripDetail["id_journey"] as! String)!
                case "otherTrip".lowercased():
                    vcc.idjourney = Int(tripDetail["id_journey"] as! String)!
                default:
                    break
                }
            default:
                break
            }
        }
        
    }
    
    func viewSetting() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.tabbarColor
        view.backgroundColor = UIColor.white
        
        if let myText = myText {
            title = myText
            print(myText)
        }
        
        switch joinButtonToggle!.lowercased() {
        case "myTrip".lowercased():
            actionButton.setTitle("LET'S GO", for: .normal)
            actionButton.backgroundColor = UIColor.greenBT
            
            
        case "otherTrip".lowercased():
            self.navigationItem.rightBarButtonItem = nil
            actionButton.setTitle("CANCEL", for: .normal)
            actionButton.backgroundColor = UIColor.redBT
            
        default:
            break
        }
        
        pickupLabel.text = "PICK-UP : \(tripDetail["pick_journey"] as! String)"
        dropoffLabel.text = "DROP-OFF : \(tripDetail["drop_journey"] as! String)"
        datetimeLabel.text = "\(tripDetail["date_journey"] as! String) , \(tripDetail["time_journey"] as! String)"
        countLabel.text = "0/\(tripDetail["count_journey"] as! String)"
        detailTextView.text = "\(tripDetail["detail_journey"] as! String)"
        let idtrip = "\(tripDetail["id_journey"] as! String)"
        userJoined(idjourney: idtrip)
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
            self.profile1ImageView.layer.cornerRadius = self.profile1ImageView.bounds.size.height / 2
            self.profile1ImageView.clipsToBounds = true
            self.profile2ImageView.layer.cornerRadius = self.profile2ImageView.bounds.size.height / 2
            self.profile2ImageView.clipsToBounds = true
            self.profile3ImageView.layer.cornerRadius = self.profile3ImageView.bounds.size.height / 2
            self.profile3ImageView.clipsToBounds = true
            self.profile4ImageView.layer.cornerRadius = self.profile4ImageView.bounds.size.height / 2
            self.profile4ImageView.clipsToBounds = true
        }
    }
    
    func tableViewSetting() {
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func loadImage() {
        var profileImages:[UIImageView] = [profile1ImageView,profile2ImageView,profile3ImageView,profile4ImageView]
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
}

extension DetailJourneyViewController:UITableViewDelegate {

}

extension DetailJourneyViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        print("\(indexPath.row)")
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if commentlist.count > 0 {
            let comment = commentlist[indexPath.row]
            cell.textLabel?.text = (comment["username_user"] as! String)
            cell.detailTextLabel?.text = "\(comment["datetime_forum"] as! String) , \(comment["comment_forum"] as! String)"
        } else {
            let comment = commentlist[indexPath.row]
            cell.textLabel?.text = "name"
            cell.detailTextLabel?.text = "detail"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentlist.count
    }
}

extension DetailJourneyViewController {
    
    func selectData() {
        let idtrip = (tripDetail["id_journey"] as! String)
        let parameters: Parameters = [
            "function": "commentjourneySelect",
            "journeyid" : idtrip
        ]
        let url = "http://worawaluns.in.th/friendforfare/get/index.php?function=commentjourneySelect"
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
                            self.commentlist.append(item as! NSDictionary)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        })
    }
    
    func userJoined(idjourney:String) {
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
    
}

