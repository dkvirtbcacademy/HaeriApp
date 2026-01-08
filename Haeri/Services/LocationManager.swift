//
//  LocationManager.swift
//  Haeri
//
//  Created by kv on 07.01.26.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class LocationManager: NSObject, ObservableObject {
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    private var isRequestingLocation = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = locationManager.authorizationStatus
    }
    
    func requestAuthorization() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func requestLocation() {
        guard !isRequestingLocation else { return }
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            isRequestingLocation = true
            locationManager.requestLocation()
        }
    }
    
    func getCityName(from coordinate: CLLocationCoordinate2D) async -> String? {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            return placemarks.first?.locality
        } catch {
            print("geocoding error: \(error)")
            return nil
        }
    }
    
    func clearLocationOnLogout() {
        userLocation = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        isRequestingLocation = false
        userLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isRequestingLocation = false
        
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("Location access denied")
            case .locationUnknown:
                print("Location unknown - retrying...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    self?.requestLocation()
                }
            default:
                print("Location error: \(error)")
            }
        }
    }
}
