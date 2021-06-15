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
    
    
    func getLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let recentLocation = locations.last else {
            locationManager.startUpdatingLocation()
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
    
    
    func findBestNearMe(forVC vc: UIViewController, cuisine: Cuisine?, title: String = "Press \"SHOW LIST\" if there are restaurants near you" ) {
        guard let lat = lat,
              let long = long else {
            // Change this to an alert later
            print("Locations needed")
            locationManager.startUpdatingLocation()
            return
        }
        guard let url = URL(string: "https://www.google.com/maps/search/\(cuisine?.name?.folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: " ", with: "+") ?? "")+restaurant+%40\(lat)%2C\(long)/@\(lat),\(long),12z/data=!4m4!2m3!5m1!4e3!6e5") else {
            // Change this to an alert later
            print("URL broke")
            return
        }
        
        vc.presentSafariVC(with: url, title: title)
    }
}
