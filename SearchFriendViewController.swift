//
//  SearchFeedViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class SearchFriendViewController: UIViewController  {
    
    var friendViewCell = "FriendViewCell"
    var candies = [NSDictionary]()
    var filteredCandies = [NSDictionary]()
    
    var searchBar:UISearchBar?
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initSearchBar()
        initTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
}

extension SearchFriendViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCandies.count
    }
    
}

extension SearchFriendViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: friendViewCell, for: indexPath) as! FriendViewCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
}

extension SearchFriendViewController {
    func initSearchBar() {
        searchBar = UISearchBar()
        searchBar!.delegate = self
        searchBar!.translatesAutoresizingMaskIntoConstraints = false
        searchBar!.sizeToFit()
        searchBar!.placeholder = "Search by Friend"
        searchBar!.barTintColor = UIColor.tabbarColor
        searchBar!.tintColor = UIColor.black
        searchBar!.scopeButtonTitles = nil
        //        searchBar!.scopeButtonTitles = ["All","Male","Female"]
        
        view.addSubview(searchBar!)
        let top = searchBar!.topAnchor.constraint(equalTo: view.topAnchor)
        let lead = searchBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        let trailing = searchBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        //        let height = searchBar!.heightAnchor.constraint(equalToConstant: 44)
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
        let top = tableView.topAnchor.constraint(equalTo: searchBar!.bottomAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([lead, trail,top,bottom])
        
        tableView.register(UINib(nibName: friendViewCell, bundle: nil), forCellReuseIdentifier: friendViewCell)
        
    }

}

extension SearchFriendViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            filteredCandies = candies
        } else {
            filteredCandies = candies.filter({( list : NSDictionary) -> Bool in
                let name = list["drop_journey"] as! String
                let filterText = name.lowercased()
                return filterText.contains(searchText.lowercased())
            })
        }
        self.tableView!.reloadData()
        
    }
}


