//
//  HomePage.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(
        coordinator: HomeCoordinator,
        cityData: CityAirPollution?
    ) {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(
//                coordinator: coordinator,
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Home")
            
            Text("ჰომე")
                .font(.firago(.large))
            
            Text("ჰომე")
                .font(.firagoMedium(.xlarge))
            
            Text("ჰომე")
                .font(.firagoBold(.xxlarge))
         }
    }
}

#Preview {
    HomePage(
        coordinator: HomeCoordinator(),
        cityData: CityAirPollution(
            city: "Rustavi",
            response: AirPollutionResponse(
                coord: AirPollutionResponse.Coord(
                    lat: 41.5489,
                    lon: 44.9961
                ),
                list: [
                    AirPollutionResponse.AirPollutionItem(
                        main: AirPollutionResponse.AirPollutionItem.AQI(aqi: 2),
                        components: AirPollutionResponse.AirPollutionItem.AirComponents(
                            co: 230.31,
                            no: 0.0,
                            no2: 0.74,
                            o3: 68.66,
                            so2: 0.64,
                            pm2_5: 3.41,
                            pm10: 3.68,
                            nh3: 0.47
                        ),
                        dt: 1609459200
                    )
                ]
            )
        )
    )
}
