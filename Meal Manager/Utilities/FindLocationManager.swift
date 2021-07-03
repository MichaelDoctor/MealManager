//
//  FindLocationManager.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-14.
//

import UIKit
import CoreLocation


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
        locationManager.stopUpdatingLocation()
    }
    
    
    func findBestNearMe(forVC vc: UIViewController, cuisine: Cuisine?) {
        locationManager.startUpdatingLocation()
        guard let lat = lat,
              let long = long else {
            presentInfo(forVC: vc)
            return
        }
        
        guard let url = URL(string: "https://www.google.com/maps/search/\(cuisine?.name?.folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: " ", with: "+") ?? "")+restaurant+%40\(lat)%2C\(long)/@\(lat),\(long),12z/data=!4m4!2m3!5m1!4e3!6e5") else {
            return
        }
        
        locationManager.stopUpdatingLocation()
        vc.presentSafariVC(with: url)
    }
    
    
    func presentInfo(forVC vc: UIViewController) {
        let alert = UIAlertController(title: "Find the best near me", message: "☝️ Location service must be enabled.\n\n✌️ If there are restaurants near you, click the \"SHOW LIST\" near the bottom.\n\n🤟 If none are found, \"No results found for your search\" will be displayed near the bottom.", preferredStyle: .alert)
        alert.redActions()
        alert.addAction(UIAlertAction(title: "Enable Location", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            if CLLocationManager.locationServicesEnabled() {
                switch self.locationManager.authorizationStatus {
                case .notDetermined:
                    self.start()
                case .restricted, .denied:
                    self.locationDisabled(vc)
                case .authorizedAlways, .authorizedWhenInUse:
                    self.locationEnabled(vc)
                @unknown default:
                    break
                }
            } else {
                self.locationDisabled(vc)
            }
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true)
    }
    
    
    private func locationDisabled(_ vc: UIViewController) {
        let ac = UIAlertController( title: "No Access to Location Services", message: "In order to find the best near you:\nOpen Settings > Privacy > Location Services > Meal Manager > Select \"While Using the App\"", preferredStyle: .alert)
        ac.redActions()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let url = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url as URL)
            }
        }))
        vc.present(ac, animated: true)
    }
    
    
    private func locationEnabled(_ vc: UIViewController) {
        let ac = UIAlertController(title: "Enabled", message: "Location services has already been successfully enabled", preferredStyle: .alert)
        ac.redActions()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.locationManager.startUpdatingLocation()
        }))
        vc.present(ac, animated: true)
    }
}
