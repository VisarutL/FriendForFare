//
//  PostTabBarController.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

protocol PostTabBarDelegate:class {
    func postTabBarDidClose()
}

class PostTabBarController:UIViewController {

    var closeBarButton = UIBarButtonItem()
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPin: MKPlacemark?
    let locationManager = CLLocationManager()
    weak var delegate:PostTabBarDelegate?
    

    @IBOutlet weak var pickupButton: UIButton!
    @IBOutlet weak var dropoffButton: UIButton!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    
    var count = 1
    var latitudepickup = Double()
    var longtudepickup = Double()
    var latitudedropoff = Double()
    var longitudedropoff = Double()

    var allTextField:[UITextField] {
        return [
            detailTextField,
            dateTextField,
            timeTextField
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setCloseButton()
        
        oneButton.backgroundColor = UIColor.tabbarColor
        oneButton.setTitleColor(UIColor.black, for: .normal)
        oneButton.addTarget(self, action: #selector(selectCount), for: .touchUpInside)
        twoButton.addTarget(self, action: #selector(selectCount), for: .touchUpInside)
        threeButton.addTarget(self, action: #selector(selectCount), for: .touchUpInside)
        fourButton.addTarget(self, action: #selector(selectCount), for: .touchUpInside)
        oneButton.tag = 1
        twoButton.tag = 2
        threeButton.tag = 3
        fourButton.tag = 4
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func pickupAction(_ sender: Any) {

        let vc = PickSearchLocationController()
        let nvc = UINavigationController(rootViewController: vc)
        vc.locationHandle = "pickup"
        vc.mapView = mapView
        vc.handleMapSearchDelegate = self
        present(nvc, animated: true, completion: nil)
    }
    
    @IBAction func dropoffAction(_ sender: Any) {
        
        let vc = PickSearchLocationController()
        let nvc = UINavigationController(rootViewController: vc)
        vc.locationHandle = "dropoff"
        vc.mapView = mapView
        vc.handleMapSearchDelegate = self
        present(nvc, animated: true, completion: nil)
    }
    
    
    @IBAction func postAction(_ sender: Any) {
        
        func checkTextField() -> Bool {
            for textField in allTextField {
                if textField.text?.characters.count == 0 { return false }
            }
            return true
        }
        
        if checkTextField() {
            addData()
        } else {
            return alert(message: "alert please fill all information.")        }

    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(PostTabBarController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func timeTextFieldEditing(_ sender: UITextField) {
        let timePickerView:UIDatePicker = UIDatePicker()
        
        timePickerView.datePickerMode = UIDatePickerMode.time
        timePickerView.locale = NSLocale(localeIdentifier: "NL") as Locale
        sender.inputView = timePickerView
        timePickerView.addTarget(self, action: #selector(PostTabBarController.timePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func timePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func selectCount(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if ((button as AnyObject).tag == 1) {
            oneButton.backgroundColor = UIColor.tabbarColor
            twoButton.backgroundColor = UIColor.textfield
            threeButton.backgroundColor = UIColor.textfield
            fourButton.backgroundColor = UIColor.textfield
            count = 1
            print(count)
        } else if ((button as AnyObject).tag == 2) {
            oneButton.backgroundColor = UIColor.textfield
            twoButton.backgroundColor = UIColor.tabbarColor
            threeButton.backgroundColor = UIColor.textfield
            fourButton.backgroundColor = UIColor.textfield
            count = 2
            print(count)
        } else if ((button as AnyObject).tag == 3) {
            oneButton.backgroundColor = UIColor.textfield
            twoButton.backgroundColor = UIColor.textfield
            threeButton.backgroundColor = UIColor.tabbarColor
            fourButton.backgroundColor = UIColor.textfield
            count = 3
            print(count)
        } else if ((button as AnyObject).tag == 4) {
            oneButton.backgroundColor = UIColor.textfield
            twoButton.backgroundColor = UIColor.textfield
            threeButton.backgroundColor = UIColor.textfield
            fourButton.backgroundColor = UIColor.tabbarColor
            count = 4
            print(count)
        }
    }
    
    func initManager() -> SessionManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
    func setCloseButton() {
        closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeAction))
        self.navigationItem.leftBarButtonItem = closeBarButton
    }
    
    func closeAction() {
        delegate?.postTabBarDidClose()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }   
    
}

extension PostTabBarController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark,locationFor:String){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        
        switch locationFor {
        case "pickup":
            //set pickup variable
            latitudepickup = placemark.coordinate.latitude
            longtudepickup = placemark.coordinate.longitude
            let pickupname = placemark.name
            pickupButton.setTitle(pickupname, for: .normal)
            
            print("pickupname \(pickupname)")
            print("latitude \(latitudepickup)")
            print("longitude \(longtudepickup)")
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
    
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
    
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            
        mapView.setRegion(region, animated: true)
        case "dropoff":
            
            latitudedropoff = placemark.coordinate.latitude
            longitudedropoff = placemark.coordinate.longitude
            let dropoffname = placemark.name
            dropoffButton.setTitle(dropoffname, for: .normal)
            
            print("pickupname \(dropoffname)")
            print("latitude \(latitudedropoff)")
            print("longitude \(longitudedropoff)")
            
        //set pickup variable
        default:
            break
        }
        
        
        

    }
    
}

extension PostTabBarController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
//    func getDirections(){
//        guard let selectedPin = selectedPin else { return }
//        let mapItem = MKMapItem(placemark: selectedPin)
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        mapItem.openInMaps(launchOptions: launchOptions)
//    }
}

extension PostTabBarController : MKMapViewDelegate {
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
//        
//        guard !(annotation is MKUserLocation) else { return nil }
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        }
//        pinView?.pinTintColor = UIColor.orange
//        pinView?.canShowCallout = true
//        let smallSquare = CGSize(width: 30, height: 30)
//        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
//        button.setBackgroundImage(UIImage(named: "car"), for: UIControlState())
//        button.addTarget(self, action: #selector(self.getDirections), for: .touchUpInside)
//        pinView?.leftCalloutAccessoryView = button
//        
//        return pinView
//    }
}



extension PostTabBarController {
    
    func addData() {
        let userID = UserDefaults.standard.integer(forKey: "UserID")
        let pickup = pickupButton.titleLabel?.text
        let latpickup = latitudepickup
        let longpickup = longtudepickup
        let dropoff = dropoffButton.titleLabel?.text
        let latdropoff = latitudedropoff
        let longdropoff = longitudedropoff
        let detail = detailTextField.text
        let countjourney = count
        let date = dateTextField.text
        let time = timeTextField.text
        let userid = userID
        var parameter = Parameters()
        parameter.updateValue(pickup!, forKey: "pick_journey")
        parameter.updateValue(latpickup, forKey: "latitude_pick")
        parameter.updateValue(longpickup, forKey: "longitude_pick")
        parameter.updateValue(dropoff!, forKey: "drop_journey")
        parameter.updateValue(latdropoff, forKey: "latitude_drop")
        parameter.updateValue(longdropoff, forKey: "longitude_drop")
        parameter.updateValue(countjourney, forKey: "count_journey")
        parameter.updateValue(date!, forKey: "date_journey")
        parameter.updateValue(time!, forKey: "time_journey")
        parameter.updateValue(detail!, forKey: "detail_journey")
        parameter.updateValue(userid, forKey: "user_id_create")
        insertUserService(parameter: parameter)
    }
    func insertUserService(parameter:Parameters)  {
        
        let parameters: Parameters = [
            "function": "insertPost",
            "parameter": parameter
        ]
        let url = "http://192.168.2.101/friendforfare/post/index.php?function=insertPost"
        let manager = initManager()
        manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { response in
                manager.session.invalidateAndCancel()
//                debugPrint(response)
                switch response.result {
                case .success:
                    if let JSON = response.result.value as? NSDictionary {
                        print("JSON: \(JSON)")
                        let status = JSON["status"] as! String
                    if  status == "404" {
                        print("error: \(JSON["message"] as! String)")
                        return
                        }
                    }
                    self.delegate?.postTabBarDidClose()
                case .failure(let error):
                    //alert
                    print(error.localizedDescription)
                }
            })
    }
}
