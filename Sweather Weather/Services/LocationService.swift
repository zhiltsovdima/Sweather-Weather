//
//  LocationService.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 13.05.2025.
//

import CoreLocation

protocol LocationService {
    func getCurrentLocation() async throws -> UserLocation
}

enum LocationError: Error {
    case accessDenied
    case locationUnavailable
    case unknown
}

final class LocationServiceImpl: NSObject, LocationService {
    
    private let locationManager: CLLocationManager
    
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func getCurrentLocation() async throws -> UserLocation {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            return try await waitForAuthorizationAndGetLocation()
        case .restricted, .denied:
            throw LocationError.accessDenied
        case .authorizedWhenInUse:
            return try await requestLocation()
        default:
            throw LocationError.unknown
        }
    }
    
    private func waitForAuthorizationAndGetLocation() async throws -> UserLocation {
        let status = await withCheckedContinuation { continuation in
            self.authorizationContinuation = continuation
            locationManager.requestWhenInUseAuthorization()
        }
        
        switch status {
        case .authorizedWhenInUse:
            return try await requestLocation()
        case .denied, .restricted:
            throw LocationError.accessDenied
        default:
            throw LocationError.unknown
        }
    }
    
    private func requestLocation() async throws -> UserLocation {
        let location = try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.requestLocation()
        }
        
        return UserLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }

}

// MARK: - CLLocationManagerDelegate

extension LocationServiceImpl: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status != .notDetermined {
            authorizationContinuation?.resume(returning: status)
            authorizationContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationContinuation?.resume(returning: location)
        } else {
            locationContinuation?.resume(throwing: LocationError.locationUnavailable)
        }
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: LocationError.locationUnavailable)
        locationContinuation = nil
    }
    
}
