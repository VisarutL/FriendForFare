//
//  DetailJourneyViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/18/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

protocol DetailJourneyDelegate: class {
    func detailJourneyDidFinish()
}

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
    @IBOutlet weak var username1Label: UILabel!
    @IBOutlet weak var username2Label: UILabel!
    @IBOutlet weak var username3Label: UILabel!
    @IBOutlet weak var username4Label: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    var tripDetail = [String: Any]()
    var closeBarButton = UIBarButtonItem()
    var myText:String?
    var joinButtonToggle:String?
    var commentlist = [NSDictionary]()
    var userjoinedList = [NSDictionary]()
    
    var allTextField:[UITextField] {
        return [
            commentTextField
        ]
    }
    
    weak var delegate:DetailJourneyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setProfileImage()
        viewSetting()
        tableViewSetting()
        setCloseButton()
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
        selectData()
        countLabel.text = "\(userjoinedList.count)/\(tripDetail["count_journey"] as! String)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showMapPickup":
                let vc = segue.destination as! MapPickUpViewController
                vc.latitude = Double(tripDetail["latitude_pick"] as! String)!
                vc.longitude = Double(tripDetail["longitude_pick"] as! String)!
                vc.pick = (tripDetail["pick_journey"] as! String)
            case "editPost":
                let vcc = segue.destination as! EditJourneyViewController
                vcc.idjourney = Int(tripDetail["id_journey"] as! String)!
            case "CheckList":
                let vc = segue.destination as! CheckListViewController
                
                let userID = UserDefaults.standard.integer(forKey: "UserID")
                let test = userjoinedList.filter({ Int($0["user_id_joined"] as! String) != userID })
                vc.userjoinedList = test as! [[String : Any]]
                vc.tripDetail = tripDetail
                
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
            actionButton.setTitle("CHECK", for: .normal)
            actionButton.backgroundColor = UIColor.greenBT
            actionButton.addTarget(self, action: #selector(CheckListAction), for: .touchUpInside)
            
        case "otherTrip".lowercased():
            self.navigationItem.rightBarButtonItem = nil
            actionButton.setTitle("CANCEL", for: .normal)
            actionButton.setTitleColor(UIColor.white, for: .normal)
            actionButton.backgroundColor = UIColor.redBT
//            actionButton.layer.borderWidth = 1
//            actionButton.layer.borderColor = UIColor.black.cgColor
            actionButton.addTarget(self, action: #selector(CancelAction), for: .touchUpInside)
            
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
    
    func CheckListAction() {
        performSegue(withIdentifier: "CheckList", sender: nil)
    }
    
    func CancelAction() {
        let idtrip = "\(tripDetail["id_journey"] as! String)"
        cancelJoin(idjourney: idtrip)
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
    
    func setButton() {
        postButton.backgroundColor = UIColor.black
//        postButton.layer.cornerRadius = 0
//        postButton.layer.borderWidth = 1
//        postButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func postAction(_ sender: Any) {
        
        func checkTextField() -> Bool {
            for textField in allTextField {
                if textField.text?.characters.count == 0 { return false }
            }
            return true
        }
        
        if checkTextField() {
            let idtrip = "\(tripDetail["id_journey"] as! String)"
            postcommentData(idjourney:idtrip)
            alert(message: "Post Sucess")
        } else {
            let error = "alert please fill all information."
            self.alert(message: error)
        }
    }
    
}

extension DetailJourneyViewController: DetailJourneyMapDelegate {
    func detailJourneyMapDidFinish() {
        delegate?.detailJourneyDidFinish()
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
        let url = "\(URLbase.URLbase)friendforfare/get/index.php?function=commentjourneySelect"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
                //                debugPrint(response)
                switch response.result {
                case .success:
                    
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        self.commentlist.removeAll()
                        self.commentTextField.text = ""
                        for item in JSON as! NSArray {
                            self.commentlist.append(item as! NSDictionary)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                            
                            if self.commentlist.count != 0 {
                                let index = IndexPath(row: self.commentlist.count - 1, section: 0)
                                self.tableview.scrollToRow(at: index, at: .bottom,animated: true)
                            }
                            
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
        let url = "\(URLbase.URLbase)friendforfare/get/index.php?function=userJoined"
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
    
    func postcommentData(idjourney:String) {
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        let comment = commentTextField.text
        let idjourney = idjourney
        let userid = userID
        var parameter = Parameters()
        parameter.updateValue(comment!, forKey: "comment_forum")
        parameter.updateValue(idjourney, forKey: "journey_id_forum")
        parameter.updateValue(userid, forKey: "user_id")
        insertUserService(parameter: parameter)
    }
    func insertUserService(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "insertcommentPost",
            "parameter": parameter
        ]
        let url = "\(URLbase.URLbase)friendforfare/post/index.php?function=insertcommentPost"
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
                    
                    
                    self.selectData()
                    
                    //status 202
//                    print(JSON)
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
            })
    }
    
    func cancelJoin(idjourney:String) {
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        let idjourney = idjourney
        let iduser = userID
        let parameters: Parameters = [
            "function": "cancelJoin",
            "userid" : iduser,
            "journeyid" : idjourney
        ]
        let url = "\(URLbase.URLbase)friendforfare/delete/index.php?function=cancelJoin"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)[
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
                    
                    print(JSON)
                    self.alert( message: "Cancel Journey", withCloseAction: true)
//                    self.delegate?.detailJourneyDidFinish()
                    //status 202
                    
                    
                case .failure(let error):
                    print(error)
                }
            })
    }

    
    
}

