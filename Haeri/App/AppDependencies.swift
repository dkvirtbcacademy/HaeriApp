//
//  AppDependencies.swift
//  Haeri
//
//  Created by kv on 09.01.26.
//

import Foundation
import Combine

@MainActor
class AppDependencies: ObservableObject {
    let authManager: AuthManager
    let locationManager: LocationManager
    let networkManager: NetworkManager
    let userDefaultsManager: UserDefaultsManager
    let airPollutionManager: AirPollutionManager
    let communityService: CommunityService
    let aiRecommendationManager: AIRecomendationManager
    let mainTabCoordinator: MainTabCoordinator
    let appCoordinator: AppCoordinator
    
    init() {
        self.authManager = AuthManager()
        self.locationManager = LocationManager()
        self.networkManager = NetworkManager()
        self.userDefaultsManager = UserDefaultsManager()
        self.airPollutionManager = AirPollutionManager(
            networkManager: networkManager,
            userDefaultsManager: userDefaultsManager
        )
        self.communityService = CommunityService(
            authManager: authManager,
            networkManager: networkManager
        )
        
        self.aiRecommendationManager = AIRecomendationManager(
            networkManager: networkManager,
            authManager: authManager
        )
        
        self.mainTabCoordinator = MainTabCoordinator()
        
        self.appCoordinator = AppCoordinator(
            authManager: authManager,
            locationManager: locationManager
        )
    }
}
