//
//  MapViewController.swift
//  FriendForFare
//
//  Created by Visarut on 2/19/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit
import MapKit

protocol DetailJourneyMapDelegate: class {
    func detailJourneyMapDidFinish()
}
class MapViewController:UIViewController {
    
    var tripDetail = [String: Any]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    weak var delegate:DetailJourneyMapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        print(tripDetail)
        let latpick = Double(tripDetail["latitude_pick"] as! String)!
        let longpick = Double(tripDetail["longitude_pick"] as! String)!
        let pick = (tripDetail["pick_journey"])
        
        
        let sourceLocation = CLLocationCoordinate2D(latitude: latpick, longitude: longpick)
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = pick as! String?
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let latdrop = Double(tripDetail["latitude_drop"] as! String)!
        let longdrop = Double(tripDetail["longitude_drop"] as! String)!
        let drop = (tripDetail["drop_journey"])
        let destinationLocation = CLLocationCoordinate2D(latitude: latdrop, longitude: longdrop)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = drop as! String?
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )

        drawStock(source: sourceMapItem, destination: destinationMapItem)
        
        
    }
    
    
    func drawStock(source:MKMapItem,destination:MKMapItem) {
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = source
        directionRequest.destination = destination
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    
    @IBAction func finishAction(_ sender: Any) {
        delegate?.detailJourneyMapDidFinish()
        
    }
   
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 6.0
        return renderer
    }

}
