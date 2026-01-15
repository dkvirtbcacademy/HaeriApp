//
//  AppDependencies.swift
//  Haeri
//
//  Created by kv on 09.01.26.
//

import Foundation
import Combine

class AppDependencies: ObservableObject {
    let authManager: AuthManager
    let locationManager: LocationManager
    let networkManager: NetworkManager
    let airPollutionManager: AirPollutionManager
    let communityService: CommunityService
    let coordinator: MainTabCoordinator
    
    init() {
        self.authManager = AuthManager()
        self.locationManager = LocationManager()
        self.networkManager = NetworkManager()
        self.airPollutionManager = AirPollutionManager(networkManager: networkManager)
        self.communityService = CommunityService(authManager: authManager, networkManager: networkManager)
        self.coordinator = MainTabCoordinator()
    }
}
