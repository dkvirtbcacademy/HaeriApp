//
//  HomeViewModel.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    private let coordinator: HomeCoordinator
    
    private var airPollutionManager: AirPollutionManager?
    private var cancellables = Set<AnyCancellable>()
    
    private let staticCityData: CityAirPollution?
    
    @Published private(set) var cityData: CityAirPollution?
    
    init(coordinator: HomeCoordinator, airPollutionManager: AirPollutionManager) {
        self.coordinator = coordinator
        self.airPollutionManager = airPollutionManager
        self.staticCityData = nil
        self.cityData = airPollutionManager.currentCityData
        
        airPollutionManager.$currentCityData
            .assign(to: &$cityData)
    }
    
    init(coordinator: HomeCoordinator, cityData: CityAirPollution) {
        self.coordinator = coordinator
        self.airPollutionManager = nil
        self.staticCityData = cityData
        self.cityData = cityData
    }
    
    func getPollutantDetails() -> [PollutantDetail] {
        guard let item = cityData?.response.item else { return [] }
        let types: [PollutantType] = [.pm25, .pm10, .co, .no2, .o3, .so2]
        return types.map { item.getPollutantDetail(for: $0) }
    }
    
    var aqiDetail: PollutantDetail? {
        cityData?.response.item?.getPollutantDetail(for: .aqi)
    }
    
    var displayCityName: String {
        cityData?.localeName ?? cityData?.city ?? ""
    }
}
