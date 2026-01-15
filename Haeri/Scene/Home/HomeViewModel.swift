//
//  HomeViewModel.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    let cityData: CityAirPollution
    private let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator, cityData: CityAirPollution) {
        self.coordinator = coordinator
        self.cityData = cityData
    }
    
    func getPollutantDetails() -> [PollutantDetail] {
        guard let item = cityData.response.item else { return [] }
        let types: [PollutantType] = [.pm25, .pm10, .co, .no2, .o3, .so2]
        return types.map { item.getPollutantDetail(for: $0) }
    }
    
    var aqiDetail: PollutantDetail? {
        cityData.response.item?.getPollutantDetail(for: .aqi)
    }
    
    var displayCityName: String {
        cityData.localeName ?? cityData.city
    }
}
