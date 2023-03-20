//
//  LocationService.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 08/11/2022.
//

import Foundation
import UIKit
import CoreLocation

public class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    
    let locationManager = CLLocationManager()
    var latitude: Double = 0
    var longitude: Double = 0
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        else {
            //tell view controllers to show an alert
            showTurnOnLocationServiceAlert()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied){
            showTurnOnLocationServiceAlert()
        }
    }
    
    func showTurnOnLocationServiceAlert(){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self, preferredLocale: Locale(identifier: "en-US")) {completion($0?.first?.locality, $0?.first?.country, $1)
        }
    }
    
    func fetchCountry(completion: @escaping( _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self, preferredLocale: Locale(identifier: "en-US")) {
            completion($0?.first?.country, $1)
        }
    }
    
    func fetchCity(completion: @escaping(_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self, preferredLocale: Locale(identifier: "ar_SA")) {completion($0?.first?.locality, $1)
        }
    }
    
}



//    func showLocationDisabledpopUp() {
//        let alertController = UIAlertController(title: "Background Location Access  Disabled", message: "We need your location", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        let openAction = UIAlertAction(title: "Open Setting", style: .default) { (action) in
//            if let url = URL(string: UIApplication.openSettingsURLString){
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
//        alertController.addAction(openAction)
//        self.present(alertController, animated: true)
//    }


//func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
//    CLGeocoder().reverseGeocodeLocation(self, preferredLocale: Locale(identifier: "en-US")) {completion($0?.first?.locality, $0?.first?.country, $1)
//    }
//}
//
