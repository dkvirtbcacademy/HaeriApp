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
    private let userDefaultsManager: UserDefaultsManager
    private var cancellables = Set<AnyCancellable>()
    private var lastProcessedLocation: CLLocationCoordinate2D?
    private var locationBeforeBackground: CLLocationCoordinate2D?
    private var hasLoadedInitialCity = false
    
    private let coordinateDecimalPlaces: Int = 2
    private let defaultLocation = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
    
    init(locationManager: LocationManager, airPollutionManager: AirPollutionManager, userDefaultsManager: UserDefaultsManager) {
        self.locationManager = locationManager
        self.airPollutionManager = airPollutionManager
        self.userDefaultsManager = userDefaultsManager
        
        if let currentLocation = locationManager.userLocation {
            lastProcessedLocation = roundCoordinate(currentLocation)
        }
        
        observeLocationUpdates()
        observeAuthorizationStatus()
    }
    
    func appLaunch() async {
        if let favoriteCity = userDefaultsManager.loadFavoriteCity() {
            await fetchFavoriteCity(favoriteCity)
            hasLoadedInitialCity = true
        } else {
            handleLocationBasedOnAuthStatus()
        }
    }
    
    func appWentToBg() {
        if let currentLocation = locationManager.userLocation {
            locationBeforeBackground = roundCoordinate(currentLocation)
        }
    }
    
    func appBecameActive() {
        guard userDefaultsManager.loadFavoriteCity() == nil else {
            return
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            handleLocationBasedOnAuthStatus()
        }
    }
    
    private func handleLocationBasedOnAuthStatus() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            
        case .denied, .restricted:
            Task {
                await updateLocation(defaultLocation, cityName: "London")
            }
            
        case .notDetermined:
            break
            
        @unknown default:
            Task {
                await updateLocation(defaultLocation, cityName: "London")
            }
        }
    }
    
    private func observeAuthorizationStatus() {
        locationManager.$authorizationStatus
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] status in
                guard let self = self else { return }
                
                guard self.userDefaultsManager.loadFavoriteCity() == nil else {
                    print("Favorite exists, ignoring authorization change")
                    return
                }
                
                switch status {
                case .authorizedWhenInUse, .authorizedAlways:
                    self.locationManager.requestLocation()
                    
                case .denied, .restricted:
                    print("Location denied, fetching default location")
                    Task {
                        await self.updateLocation(self.defaultLocation, cityName: "London")
                    }
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
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
                
                guard self.userDefaultsManager.loadFavoriteCity() == nil else {
                    return
                }
                
                self.lastProcessedLocation = location
                
                Task { [weak self] in
                    await self?.updateLocation(location)
                }
            }
            .store(in: &cancellables)
    }
    
    private func roundCoordinate(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let multiplier = pow(10.0, Double(coordinateDecimalPlaces))
        return CLLocationCoordinate2D(
            latitude: round(coordinate.latitude * multiplier) / multiplier,
            longitude: round(coordinate.longitude * multiplier) / multiplier
        )
    }
    
    private func fetchFavoriteCity(_ cityName: String) async {
        do {
            guard let coord = try await airPollutionManager.fetchCoordinates(city: cityName) else {
                handleLocationBasedOnAuthStatus()
                return
            }
            
            try await airPollutionManager.fetchNewCity(
                lat: String(coord.lat),
                long: String(coord.lon),
                cityName: cityName,
                localeName: coord.localeName,
                homeCity: true
            )
            
        } catch let error as AirPollutionError {
            handleAirPollutionError(error)
            handleLocationBasedOnAuthStatus()
        } catch let error as NetworkError {
            handleNetworkError(error, context: cityName)
            handleLocationBasedOnAuthStatus()
        } catch {
            handleNetworkError(.networkError)
            handleLocationBasedOnAuthStatus()
        }
    }
    
    private func updateLocation(_ location: CLLocationCoordinate2D, cityName: String? = nil) async {
        
        let finalCityName: String
        let localeName: String?
        
        if let providedCityName = cityName {
            finalCityName = providedCityName
            localeName = nil
        } else {
            finalCityName = await locationManager.getCityName(from: location) ?? "Current Location"
            localeName = try? await airPollutionManager.fetchCoordinates(city: finalCityName)?.localeName
        }
        
        do {
            try await airPollutionManager.fetchNewCity(
                lat: String(location.latitude),
                long: String(location.longitude),
                cityName: finalCityName,
                localeName: localeName,
                homeCity: true
            )
            hasLoadedInitialCity = true
        } catch let error as NetworkError {
            handleNetworkError(error, context: finalCityName)
        } catch let error as AirPollutionError {
            handleAirPollutionError(error)
        } catch {
            handleNetworkError(.networkError)
        }
    }
}
