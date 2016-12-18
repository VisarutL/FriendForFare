//
//  JourneyViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class JourneyViewController:UIViewController {
    
    var closeBarButton = UIBarButtonItem()
    var myText:String?
    var trip = [String: Any]()
    
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropoffLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myText = myText {
            title = myText
            print(myText)
        }
        viewSetting()
        setCloseButton()
        pickupLabel.text = "PICK-UP : \(trip["pick_journey"] as! String)"
        dropoffLabel.text = "DROP-OFF : \(trip["drop_journey"] as! String)"
        datetimeLabel.text = "\(trip["date_journey"] as! String) , \(trip["time_journey"] as! String)"
        countLabel.text = "\(trip["count_journey"] as! String)/4"
        detailTextView.text = "\(trip["detail_journey"] as! String)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showMapPickup":
                let vc = segue.destination as! MapPickUpViewController
                vc.latitude = Double(trip["latitude_pick"] as! String)!
                vc.longitude = Double(trip["longitude_pick"] as! String)!
                
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

}
