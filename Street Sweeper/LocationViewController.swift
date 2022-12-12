//
//  LocationViewController.swift
//  Street Sweeper
//
//  Created by Jason Kelly on 11/27/22.
//

import UIKit
import MapKit
import CoreLocation

struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
//    private var locationManager:CLLocationManager?
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latLngLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var initialLocation = CLLocation()
    
    var currLocation = [CLLocationDegrees]()
    //location manager
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0  // Movement threshold for new events
      //  _locationManager.allowsBackgroundLocationUpdates = true // allow in background

        return _locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        latLngLabel.numberOfLines = 0
        locationManager = CLLocationManager()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        initialLocation = CLLocation(latitude: 42.366, longitude: -71.056)
//        initialLocation = CLLocation(latitude: userDefaults.double(forKey: "Latitude"), longitude: userDefaults.double(forKey: "Longitude"))
        
        
        
        
        mapView.centerToLocation(initialLocation)
        print(locationManager)
        addPreviousCarLoc()
        //getUserLocation()
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("saveButtonTapped")
        getUserLocation()
        print("mapView.userLocation.coordinate \(mapView.userLocation.coordinate)")
        
        // 1. set to center of map the new location
        mapView.setCenter(CLLocationCoordinate2D(latitude: currLocation[0], longitude: currLocation[1]), animated: true)
        
        // 2. set the userDefaults to this value
        userDefaults.set(currLocation[0], forKey: "Latitude")
        userDefaults.set(currLocation[1], forKey: "Longitude")
        
        // 3. set the annotation in the map ( replace if already annotated )
        addCarAnnotation()
        
    }
    
    func getUserLocation() {
        mapView.centerToLocation(initialLocation)
    }
    
    func addCarAnnotation() {
        let carLoc = MKPointAnnotation()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        carLoc.title = "\(dateFormatter.string(from: Date())) CAR"
        carLoc.coordinate = CLLocationCoordinate2D(latitude: userDefaults.double(forKey: "Latitude"), longitude: userDefaults.double(forKey: "Longitude"))
        mapView.addAnnotation(carLoc)
    }
    
    func addPreviousCarLoc() {
        let carLoc = MKPointAnnotation()
        carLoc.title = "Previous Car Location"
        carLoc.coordinate = CLLocationCoordinate2D(latitude: userDefaults.double(forKey: "Latitude"), longitude: userDefaults.double(forKey: "Longitude"))
        mapView.addAnnotation(carLoc)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdate")
        
//        if let location = locations.last {
//            latLngLabel.text = "Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)"
//            userDefaults.set(location.coordinate.latitude, forKey: "Latitude")
//            userDefaults.set(location.coordinate.longitude, forKey: "Longitude")
//
//            let carLoc = MKPointAnnotation()
//            carLoc.title = "CAR"
//            carLoc.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            mapView.addAnnotation(carLoc)
//
//        }
        
//        if locationUpdate == false {
//                locationUpdate = true
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        var latStr = ""
        var longStr = ""
        latStr = String(locValue.latitude)
        longStr = String(locValue.longitude)
        currLocation = [ locValue.latitude, locValue.longitude ]
        
    }
}

// MARK: - CLLocationManagerDelegate
//extension UIViewController:  {
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        for location in locations {
//            print("**********************")
//            print("Long \(location.coordinate.longitude)")
//            print("Lati \(location.coordinate.latitude)")
//            print("Alt \(location.altitude)")
//            print("Sped \(location.speed)")
//            print("Accu \(location.horizontalAccuracy)")
//            print("**********************")
//        }
//    }
//}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

