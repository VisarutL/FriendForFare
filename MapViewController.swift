//
//  MapViewController.swift
//  FriendForFare
//
//  Created by Visarut on 2/19/2560 BE.
//  Copyright © 2560 BE Newfml. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

protocol DetailJourneyMapDelegate: class {
    func detailJourneyMapDidFinish()
}
class MapViewController:UIViewController {
    
    var tripDetail = [String: Any]()
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    weak var delegate:DetailJourneyMapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        print(tripDetail)
        self.title = "Distance"
        let latpick = Double(tripDetail["latitude_pick"] as! String)!
        let longpick = Double(tripDetail["longitude_pick"] as! String)!
        let pick = (tripDetail["pick_journey"])
        
        
        let sourceLocation = CLLocationCoordinate2D(latitude: latpick, longitude: longpick)
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = pick as! String?
        sourceAnnotation.subtitle = "pick up."
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
        destinationAnnotation.subtitle = "drop off."
        
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
            let travelTime = (route.expectedTravelTime)/60
            let travelDistance = (route.distance)/1000
            let myFormatter = NumberFormatter()
            myFormatter.maximumFractionDigits = 0
            
            let time = myFormatter.string(from: NSNumber(value:travelTime))
            let distance = myFormatter.string(from: NSNumber(value:travelDistance))
            print(time!)
            print(distance!)
            self.distanceLabel.text = "Distance: \(distance!) KM"
            self.timeLabel.text = "Traveltime: \(time!) Min"
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        return Alamofire.SessionManager(configuration: configuration)
    }
    
    
    @IBAction func finishAction(_ sender: Any) {
        let idtrip = Int(tripDetail["id_journey"] as! String)!
        finishUpdate(idjourney:idtrip)
        delegate?.detailJourneyMapDidFinish()
    }
   
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.routeMap
        renderer.lineWidth = 4.0
        return renderer
    }

}

extension MapViewController {
    func finishUpdate(idjourney:Int) {
        let idjourney = idjourney
        var parameter = Parameters()
        parameter.updateValue(idjourney, forKey: "id_journey")
        insertUserid(parameter: parameter)
    }
    
    func insertUserid(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "finishUpdate",
            "parameter": parameter
        ]
        let url = "\(URLbase.URLbase)friendforfare/post/index.php?function=finishUpdate"
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
                    self.alert( message: "Finish Journey", withCloseAction: true)
                    case .failure(let error):
                    
                    print(error.localizedDescription)
                }
            })
    }
}
