//
//  DashboardViewModel.swift
//  Haeri
//
//  Created by kv on 09.01.26.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    
    @Published var cities: [CityAirPollution] = []
    @Published var isLoading: Bool = false
    
    private let coordinator: DashboardCoordinator
    private let homeCoordinator: HomeCoordinator
    private let airPollutionManager: AirPollutionManager
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: DashboardCoordinator, homeCoordinator: HomeCoordinator, airPollutionManager: AirPollutionManager) {
        self.coordinator = coordinator
        self.homeCoordinator = homeCoordinator
        self.airPollutionManager = airPollutionManager
        
        observeAirPollutionData()
    }
    
    private func observeAirPollutionData() {
        airPollutionManager.$airPollutionData
            .assign(to: &$cities)
        
        airPollutionManager.$isLoading
            .assign(to: &$isLoading)
    }
    
    func fetchCitiesData() async {
        await airPollutionManager.fetchChoosenCitiesData()
    }
    
    func removeCity(at index: Int) {
        airPollutionManager.removeChoosenCity(index: index)
    }
    
    func navigateToCityDetail(cityData: CityAirPollution, backgroudColor: String) {
        coordinator.navigate(to: .cityDetail(cityData, homeCoordinator, backgroudColor))
    }
}
