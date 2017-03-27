//
//  SearchFeedViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire

class SearchFriendViewController: UIViewController  {
    
    var searchBar = UISearchBar()
    var tableView = UITableView()
    var closeBarButton = UIBarButtonItem()
    
    var searchFriendViewCell = "SearchFriendViewCell"
    var userList = [NSDictionary]()
    var filteredUserList = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Friend"
        initSearchBar()
        initTableView()
        setCloseButton()
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        selectData(iduser: userID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return Alamofire.SessionManager(configuration: configuration)
    }
    
    func setCloseButton() {
        closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeAction))
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SearchFriendViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUserList.count
    }
}

extension SearchFriendViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchFriendViewCell, for: indexPath) as! SearchFriendViewCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let friend = filteredUserList[indexPath.row]
        cell.nameLabel.text = "\(friend["fname_user"]!) \(friend["lname_user"]!)"
        cell.usernameLabel.text = "\(friend["username_user"]!)"
        
        guard let imageName = friend["pic_user"] as? String ,imageName != "" else {
            return cell
        }
        
        let path = "\(URLbase.URLbase)friendforfare/images/"
        if let url = NSURL(string: "\(path)\(imageName)") {
            if let data = NSData(contentsOf: url as URL) {
                DispatchQueue.main.async {
                    cell.profileImage.image = UIImage(data: data as Data)
                }
                
            }
        }
        cell.delegate = self
        cell.indexPath = indexPath as NSIndexPath
        
        return cell
    }
}

extension SearchFriendViewController:SearchFriendViewCellDelegate {
    func searchFriendViewCellDidAdd(index: NSIndexPath) {
        let addUser = filteredUserList[index.row]
        if let i = userList.index(of: addUser) {
            userList.remove(at: i)
            filteredUserList.remove(at:index.row)
            let userID = UserDefaults.standard.integer(forKey: "UserID")
            addFriendData(id: userID, idfriend: "\(addUser["id_user"] as! String)")
            self.alert(message: "Add Success")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
}

extension SearchFriendViewController {
    
    func initSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.sizeToFit()
        searchBar.placeholder = "Search by username"
        searchBar.barTintColor = UIColor.tabbarColor
        searchBar.tintColor = UIColor.black
        searchBar.scopeButtonTitles = nil
        //        searchBar.scopeButtonTitles = ["All","Male","Female"]
        
        view.addSubview(searchBar)
        let top = searchBar.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
        let lead = searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        let trailing = searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        //        let height = searchBar.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([top,lead, trailing])
    }
    
    func initTableView() {
        
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        view.addSubview(tableView)
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let lead = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        let trail = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        let top = tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([lead, trail,top,bottom])
        
        tableView.register(UINib(nibName: searchFriendViewCell, bundle: nil), forCellReuseIdentifier: searchFriendViewCell)
        
    }

}

extension SearchFriendViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            filteredUserList = [NSDictionary]()
        } else {
            filteredUserList = userList.filter({( list : NSDictionary) -> Bool in
                let name = list["username_user"] as! String
                let filterText = name.lowercased()
                return filterText.contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
        
    }
}

extension SearchFriendViewController {
    
    func selectData(iduser:Int) {
        let parameters: Parameters = [
            "function": "searchFriendSelect",
            "iduser": iduser
        ]
        let url = "\(URLbase.URLbase)friendforfare/get/index.php?function=searchFriendSelect"
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
                            self.userList.append(item as! NSDictionary)
                            
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func addFriendData(id:Int,idfriend:String) {
        let userid = id
        let useridfriend = idfriend
        var parameter = Parameters()
        parameter.updateValue(userid, forKey: "user_id")
        parameter.updateValue(useridfriend, forKey: "user_id_friend")
        insertUserService(parameter: parameter)
    }
    
    func insertUserService(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "addFriendData",
            "parameter": parameter
        ]
        let url = "\(URLbase.URLbase)friendforfare/post/index.php?function=addFriendData"
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
                    //status 202
                    print(JSON)
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
            })
        
    }


    
}


