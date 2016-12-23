//
//  DetailJourneyViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/18/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

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
    
    var tripme = [String: Any]()
    var tripjoin = [String: Any]()
    let numberOfRow = [1,1]
    
    
    var closeBarButton = UIBarButtonItem()
    var myText:String?
    var joinButtonToggle:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myText = myText {
            title = myText
            print(myText)
        }
        
        
        switch joinButtonToggle!.lowercased() {
        case "myTrip".lowercased():
            actionButton.setTitle("LET'S GO", for: .normal)
            actionButton.backgroundColor = UIColor.redBT
            pickupLabel.text = "PICK-UP : \(tripme["pick_journey"] as! String)"
            dropoffLabel.text = "DROP-OFF : \(tripme["drop_journey"] as! String)"
            datetimeLabel.text = "\(tripme["date_journey"] as! String) , \(tripme["time_journey"] as! String)"
            countLabel.text = "\(tripme["count_journey"] as! String)/4"
            detailTextView.text = "\(tripme["detail_journey"] as! String)"

        case "otherTrip".lowercased():
            self.navigationItem.rightBarButtonItem = nil
            actionButton.setTitle("CANCEL", for: .normal)
            actionButton.backgroundColor = UIColor.greenBT
            pickupLabel.text = "PICK-UP : \(tripjoin["pick_journey"] as! String)"
            dropoffLabel.text = "DROP-OFF : \(tripjoin["drop_journey"] as! String)"
            datetimeLabel.text = "\(tripjoin["date_journey"] as! String) , \(tripjoin["time_journey"] as! String)"
            countLabel.text = "\(tripjoin["count_journey"] as! String)/4"
            detailTextView.text = "\(tripjoin["detail_journey"] as! String)"

        default:
            break
        }
        
        viewSetting()
        tableViewSetting()
        setCloseButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showMapPickup":
                let vc = segue.destination as! MapPickUpViewController
                switch joinButtonToggle!.lowercased() {
                case "myTrip".lowercased():
                    vc.latitude = Double(tripme["latitude_pick"] as! String)!
                    vc.longitude = Double(tripme["longitude_pick"] as! String)!
                    vc.pick = (tripme["pick_journey"] as! String)
                case "otherTrip".lowercased():
                    vc.latitude = Double(tripjoin["latitude_pick"] as! String)!
                    vc.longitude = Double(tripjoin["longitude_pick"] as! String)!
                    vc.pick = (tripjoin["pick_journey"] as! String)
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
    }
    
    func setCloseButton() {
        closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeAction))
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableViewSetting() {
        tableview.delegate = self
        tableview.dataSource = self
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

        switch joinButtonToggle!.lowercased() {
            case "myTrip".lowercased():
//                let tripme = self.tripme[indexPath.row]
                cell.textLabel?.text = (tripme["username_user"] as! String)
                cell.detailTextLabel?.text = "\(tripme["datetime_forum"] as! String) , \(tripme["comment_forum"] as! String)"
            case "otherTrip".lowercased():
//                let tripjoin = self.tripjoin[indexPath.row]
                cell.textLabel?.text = (tripjoin["username_user"] as! String)
                cell.detailTextLabel?.text = "\(tripjoin["datetime_forum"] as! String) , \(tripjoin["comment_forum"] as! String)"
            default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfRow[section]
    }
}

