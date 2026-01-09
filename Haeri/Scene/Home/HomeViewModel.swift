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
    
    var pollutionDetails: [PollutionDetail] {
        guard let item = cityData.response.item else { return [] }
        
        return [
            PollutionDetail(label: "AQI", value: "\(item.main.aqi)"),
            PollutionDetail(label: "PM2.5", value: String(format: "%.2f", item.components.pm2_5)),
            PollutionDetail(label: "PM10", value: String(format: "%.2f", item.components.pm10)),
            PollutionDetail(label: "CO", value: String(format: "%.2f", item.components.co)),
            PollutionDetail(label: "NO₂", value: String(format: "%.2f", item.components.no2)),
            PollutionDetail(label: "O₃", value: String(format: "%.2f", item.components.o3)),
            PollutionDetail(label: "SO₂", value: String(format: "%.2f", item.components.so2)),
            PollutionDetail(label: "NH₃", value: String(format: "%.2f", item.components.nh3))
        ]
    }
}
