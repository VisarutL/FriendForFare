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
    @IBOutlet weak var profile1ImageView: UIImageView!
    @IBOutlet weak var profile2ImageView: UIImageView!
    @IBOutlet weak var profile3ImageView: UIImageView!
    @IBOutlet weak var profile4ImageView: UIImageView!
    
    
    var closeBarButton = UIBarButtonItem()
    var myText:String?
    var joinButtonTogle:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myText = myText {
            title = myText
            print(myText)
        }
        
        switch joinButtonTogle!.lowercased() {
        case "myTrip".lowercased():
            actionButton.setTitle("LET'S GO", for: .normal)
            actionButton.backgroundColor = UIColor.redBT
        case "otherTrip".lowercased():
            actionButton.setTitle("CANCEL", for: .normal)
            actionButton.backgroundColor = UIColor.greenBT
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
                vc.latitude = 12
                vc.longitude = 13
                
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

        
        
        cell.textLabel?.text = "Username: \(indexPath.row)"
        cell.detailTextLabel?.text = "Comment: \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
