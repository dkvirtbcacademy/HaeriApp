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
    let formValidationManager: FormValidationManager
    let airPollutionManager: AirPollutionManager
    let communityService: CommunityService
    let aiRecommendationManager: AIRecomendationManager
    
    init() {
        self.authManager = AuthManager()
        self.locationManager = LocationManager()
        self.networkManager = NetworkManager()
        self.userDefaultsManager = UserDefaultsManager()
        self.formValidationManager = FormValidationManager()
        
        self.airPollutionManager = AirPollutionManager(
            networkManager: networkManager,
            userDefaultsManager: userDefaultsManager
        )
        self.communityService = CommunityService(
            authManager: authManager,
        )
        
        self.aiRecommendationManager = AIRecomendationManager(
            networkManager: networkManager,
            authManager: authManager
        )
        
    }
}
