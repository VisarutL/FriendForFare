//
//  SearchFeedViewController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit

class SearchFeedViewController: UITableViewController  {
    
    let cellIdentifier = "cell"
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let candy: Candy
        if searchController.isActive && searchController.searchBar.text != "" {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        cell.textLabel!.text = candy.name
        cell.detailTextLabel!.text = candy.category
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCandies.count
        }
        return candies.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(indexPath.row)")
    }
    
}

extension SearchFeedViewController {
    func viewSetting() {
        navigationController?.navigationBar.backgroundColor = UIColor.tabbarColor
//        navigationController?.isNavigationBarHidden = true
        searchController.delegate = self
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        searchController.extendedLayoutIncludesOpaqueBars = true
        searchController.obscuresBackgroundDuringPresentation = true
        
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        tableView.tableHeaderView = searchController.searchBar
        
        candies = [
            Candy(category:"Chocolate", name:"Chocolate Bar"),
            Candy(category:"Chocolate", name:"Chocolate Chip"),
            Candy(category:"Chocolate", name:"Dark Chocolate"),
            Candy(category:"Hard", name:"Lollipop"),
            Candy(category:"Hard", name:"Candy Cane"),
            Candy(category:"Hard", name:"Jaw Breaker"),
            Candy(category:"Other", name:"Caramel"),
            Candy(category:"Other", name:"Sour Chew"),
            Candy(category:"Other", name:"Gummi Bear")]
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCandies = candies.filter({( candy : Candy) -> Bool in
            let categoryMatch = (scope == "All") || (candy.category == scope)
            return categoryMatch && candy.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension SearchFeedViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    

    
}

extension SearchFeedViewController: UISearchControllerDelegate {
//    - (void)didPresentSearchController:(UISearchController *)searchController
//    {
//    
//    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        navigationController?.navigationBar.isTranslucent = true
        
        print("show")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        navigationController?.navigationBar.isTranslucent = false
        print("dimiss")
    }
}

extension SearchFeedViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }

}
