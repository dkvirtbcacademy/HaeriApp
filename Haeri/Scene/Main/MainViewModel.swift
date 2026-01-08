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
    
    @Published private(set) var lastBackgroundTime: Date?
    @Published var alertItem: AlertItem?
    
    private let locationManager: LocationManager
    private let airPollutionManager: AirPollutionManager
    private var cancellables = Set<AnyCancellable>()
    
    private let refreshInterval: TimeInterval = 30 * 60
    
    init(locationManager: LocationManager, airPollutionManager: AirPollutionManager) {
        self.locationManager = locationManager
        self.airPollutionManager = airPollutionManager
        
        observeLocationUpdates()
    }
    
    func appLaunch() {
        locationManager.requestLocation()
    }
    
    func appWentToBg() {
        lastBackgroundTime = Date()
    }
    
    func appBecameActive() {
        guard lastBackgroundTime != nil else { return }
        
        if refreshLocation() {
            locationManager.requestLocation()
        } else {
            print("less than 30 minutes since went to background")
        }
    }
    
    private func refreshLocation() -> Bool {
        guard let lastBackgroundTime = lastBackgroundTime else {
            return false
        }
        
        let timeSinceBackground = Date().timeIntervalSince(lastBackgroundTime)
        print("Time since background: \(timeSinceBackground) seconds")
        
        return timeSinceBackground >= refreshInterval
    }
    
    private func observeLocationUpdates() {
        locationManager.$userLocation
            .compactMap { $0 }
            .removeDuplicates(by: { lhs, rhs in
                lhs.latitude == rhs.latitude &&
                lhs.longitude == rhs.longitude
            })
            .sink { [weak self] location in
                Task { [weak self] in
                    await self?.updateLocation(location)
                }
            }
            .store(in: &cancellables)
    }

    
    private func updateLocation(_ location: CLLocationCoordinate2D) async {
        print("location updated: \(location)")
        let cityName = await locationManager.getCityName(from: location) ?? "Current Location"
        
        do {
            try await airPollutionManager.fetchNewCity(
                lat: String(location.latitude),
                long: String(location.longitude),
                cityName: cityName
            )
        } catch let error as NetworkError {
            handleNetworkError(error, context: cityName)
        } catch let error as AirPollutionError {
            handleAirPollutionError(error)
        } catch {
            handleNetworkError(.networkError)
        }
    }
}
