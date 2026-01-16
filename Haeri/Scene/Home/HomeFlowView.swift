//
//  HomeFlowView.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

struct HomeFlowView: View {
    
    @ObservedObject var coordinator: HomeCoordinator
    @ObservedObject var airPollutionManager: AirPollutionManager
    @ObservedObject var aiRecommendationManager: AIRecomendationManager
    @Environment(\.airQuality) var airQuality
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                if let cityData = airPollutionManager.currentCityData {
                    HomePage(
                        coordinator: coordinator,
                        cityData: cityData,
                        aiRecommendationManager: aiRecommendationManager,
                    )
                } else {
                    SwiftUILoadingView(label: "დაელოდეთ ინფორმაცია იტვირთება...")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(for: Int.self) { id in }
            .adaptiveBackground()
        }
    }
}

#Preview {
    HomeFlowView(
        coordinator: HomeCoordinator(),
        airPollutionManager: AirPollutionManager(
            networkManager: NetworkManager(),
            userDefaultsManager: UserDefaultsManager()
        ),
        aiRecommendationManager: AIRecomendationManager(
            networkManager: NetworkManager(),
            authManager: AuthManager()
        ),
    )
}
