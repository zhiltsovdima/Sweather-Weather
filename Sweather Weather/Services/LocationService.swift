//
//  LocationService.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import Foundation
import CoreLocation

protocol LocationService {
    func requestLocation(completion: @escaping (CLLocation?) -> Void)
}

final class LocationServiceImpl: NSObject, LocationService {
    
    private let locationManager = CLLocationManager()
    private var locationRequestCompletion: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation(completion: @escaping (CLLocation?) -> Void) {
        locationRequestCompletion = completion
        locationManager.requestLocation()
    }
    
}

// MARK: - CLLocationManagerDelegate

extension LocationServiceImpl: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            locationRequestCompletion?(nil)
            return
        }
        locationRequestCompletion?(location)
        locationRequestCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        locationRequestCompletion?(nil)
        locationRequestCompletion = nil
    }
}
