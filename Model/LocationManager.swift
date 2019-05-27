//
//  LocationManager.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 23/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationCoordinate {
    var lat: Double
    var lon: Double
    
    static func create(location: CLLocation) -> LocationCoordinate {
        return LocationCoordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
    var manager = CLLocationManager()
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    var blockForSave: ((LocationCoordinate) -> Void)?
    
    func getCurrentLocation(block: ((LocationCoordinate) -> Void)?) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            print("Пользователь не дал доступа к локации")
            return
        }
        
        blockForSave = block
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .other
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationCoordinate = LocationCoordinate.create(location: locations.last!)
        blockForSave?(locationCoordinate)
        manager.stopUpdatingLocation()
    }
}
