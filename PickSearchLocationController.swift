//
//  PickSearchLocationController.swift
//  FriendForFare
//
//  Created by Visarut on 2/1/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark,locationFor:String)
}

class PickSearchLocationController:UITableViewController,UISearchBarDelegate {
    
    var locationHandle = String()
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    
    weak var handleMapSearchDelegate: HandleMapSearch?
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        let searchBar = searchController.searchBar
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for \(locationHandle)"
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
    }
    
    func parseAddress(_ selectedItem:MKPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        dismiss(animated: true, completion: nil)
        // Hide the cancel button
        searchBar.showsCancelButton = false
        // You could also change the position, frame etc of the searchBar
    }
    
}

extension PickSearchLocationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem)
        return cell
    }
    
}

extension PickSearchLocationController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        
        handleMapSearchDelegate?.dropPinZoomIn(selectedItem,locationFor: locationHandle)
        dismiss(animated: true, completion: nil)
        
    }
    
}


extension PickSearchLocationController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
        
    }
    
}
