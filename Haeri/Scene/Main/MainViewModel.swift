//
//  MainViewModel.swift
//  Haeri
//
//  Created by kv on 07.01.26.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class MainViewModel: ObservableObject, AlertHandler {
    
    @Published var alertItem: AlertItem?
    
    private let locationManager: LocationManager
    private let airPollutionManager: AirPollutionManager
    private var cancellables = Set<AnyCancellable>()
    private var lastProcessedLocation: CLLocationCoordinate2D?
    private var locationBeforeBackground: CLLocationCoordinate2D?
    
    private let coordinateDecimalPlaces: Int = 2
    
    init(locationManager: LocationManager, airPollutionManager: AirPollutionManager) {
        self.locationManager = locationManager
        self.airPollutionManager = airPollutionManager
        
        if let currentLocation = locationManager.userLocation {
            lastProcessedLocation = roundCoordinate(currentLocation)
        }
        
        observeLocationUpdates()
    }
    
    func appLaunch() {
        locationManager.requestLocation()
    }
    
    func appWentToBg() {
        if let currentLocation = locationManager.userLocation {
            locationBeforeBackground = roundCoordinate(currentLocation)
            print("App went to background at location: \(locationBeforeBackground!)")
        }
    }
    
    func appBecameActive() {
        print("App became active, checking location change")
        
        locationManager.requestLocation()
        
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            let currentLocation: CLLocationCoordinate2D
            
            // If no location available, use London as fallback
            if let userLocation = locationManager.userLocation {
                currentLocation = userLocation
            } else {
                print("⚠️ No current location available, using London as fallback")
                currentLocation = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
                // Fetch air quality for London
                Task {
                    await updateLocation(roundCoordinate(currentLocation))
                }
                return
            }
            
            let roundedCurrent = roundCoordinate(currentLocation)
            
            if let locationBefore = locationBeforeBackground {
                if roundedCurrent.latitude == locationBefore.latitude &&
                    roundedCurrent.longitude == locationBefore.longitude {
                    print("Location unchanged, skipping refresh")
                } else {
                    print("Location changed! Before: \(locationBefore), Now: \(roundedCurrent)")
                }
            } else {
                print("No previous location to compare")
            }
        }
    }
    
    private func observeLocationUpdates() {
        locationManager.$userLocation
            .compactMap { $0 }
            .map { [weak self] location -> CLLocationCoordinate2D in
                guard let self = self else { return location }
                return self.roundCoordinate(location)
            }
            .removeDuplicates(by: { lhs, rhs in
                lhs.latitude == rhs.latitude &&
                lhs.longitude == rhs.longitude
            })
            .sink { [weak self] location in
                guard let self = self else { return }
                
                print("Rounded location received: (\(location.latitude), \(location.longitude))")
                
                self.lastProcessedLocation = location
                
                Task { [weak self] in
                    await self?.updateLocation(location)
                }
            }
            .store(in: &cancellables)
    }
    
    private func roundCoordinate(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let multiplier = pow(10.0, Double(coordinateDecimalPlaces))
        let roundedLat = round(coordinate.latitude * multiplier) / multiplier
        let roundedLong = round(coordinate.longitude * multiplier) / multiplier
        return CLLocationCoordinate2D(latitude: roundedLat, longitude: roundedLong)
    }
    
    private func updateLocation(_ location: CLLocationCoordinate2D) async {
        print("Fetching air quality for location: \(location)")
        let cityName = await locationManager.getCityName(from: location) ?? "Current Location"
        
        do {
            try await airPollutionManager.fetchNewCity(
                lat: String(location.latitude),
                long: String(location.longitude),
                cityName: cityName
            )
            print("Air quality data fetched successfully for \(cityName)")
        } catch let error as NetworkError {
            handleNetworkError(error, context: cityName)
        } catch let error as AirPollutionError {
            handleAirPollutionError(error)
        } catch {
            handleNetworkError(.networkError)
        }
    }
}
