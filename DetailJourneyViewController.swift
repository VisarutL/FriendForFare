//
//  DetailJourneyViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/18/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class DetailJourneyViewController:UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var closeBarButton = UIBarButtonItem()
    var myText:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myText = myText {
            title = myText
            print(myText)
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
