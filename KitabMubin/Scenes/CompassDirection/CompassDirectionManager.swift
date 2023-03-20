//
//  CompassDirectionManager.swift
//  KitabMubin
//
//  Created by Moamen Abd Elgawad on 17/08/2022.
//

import Foundation
import UIKit
import CoreLocation

class CompassDirectionManager: NSObject, CLLocationManagerDelegate{
    
    private var latOfOrigin = 21.422487
    private var lngOfOrigin = 39.826206
    private var location: CLLocation?
    private let locationManager = CLLocationManager()
    
    var dialerImageView: UIImageView?
    var pointerImageView: UIImageView?
    var bearingOfKabah = Double()
    
    init(dialerImageView: UIImageView, pointerImageView: UIImageView) {
        self.dialerImageView = dialerImageView
        self.pointerImageView = pointerImageView
    }
    
    func initManager(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    func setOrigin(lat: Double, lng: Double){
        latOfOrigin = lat
        lngOfOrigin = lng
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        let north = -1 * (heading.magneticHeading * Double.pi) / 180
        let directionOfKabah = (bearingOfKabah * Double.pi) / 180 + north
        dialerImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(north))
        pointerImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(directionOfKabah))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        location = newLocation
        bearingOfKabah = getBearingBetweenTwoPoints1(newLocation, latitudeOfOrigin: latOfOrigin, longitudeOfOrigin: lngOfOrigin) //calculating the bearing of KABAH
    }
    
    private func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }
    
    private  func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180.0 / Double.pi
    }
    
    private  func getBearingBetweenTwoPoints1(_ point1: CLLocation, latitudeOfOrigin: Double, longitudeOfOrigin: Double) -> Double {
        let lat1 = degreesToRadians(point1.coordinate.latitude)
        let lon1 = degreesToRadians(point1.coordinate.longitude)
        let lat2 = degreesToRadians(latitudeOfOrigin)
        let lon2 = degreesToRadians(longitudeOfOrigin)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        var radiansBearing = atan2(y, x)
        if(radiansBearing < 0.0) {
            radiansBearing += 2 * Double.pi
        }
        return radiansToDegrees(radiansBearing)
    }
}
