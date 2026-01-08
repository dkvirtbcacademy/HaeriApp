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
    @Environment(\.airQuality) var airQuality
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomePage(
                coordinator: coordinator,
                cityData: airPollutionManager.currentCityData
            )
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
            networkManager: NetworkManager()
        )
    )
}
