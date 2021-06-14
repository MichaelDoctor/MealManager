//
//  FindLocationManager.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-14.
//

import UIKit
import CoreLocation

protocol FindLocationManagerDelegate: AnyObject {
    func useLocation(lat: CLLocation, long: CLLocation)
}

class FindLocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = FindLocationManager()
    
    private let locationManager: CLLocationManager
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    func start() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let recentLocation = locations.last else {
            return
        }
        locationManager.stopUpdatingLocation()
        lat = recentLocation.coordinate.latitude
        long = recentLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationManager.stopUpdatingLocation()
    }
}
