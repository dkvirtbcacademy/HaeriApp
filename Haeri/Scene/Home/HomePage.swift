//
//  HomePage.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var viewModel: HomeViewModel
    private let calculateBackground: Bool
    @State private var selectedPollutant: PollutantDetail?
    
    init(
        coordinator: HomeCoordinator,
        cityData: CityAirPollution,
        calculateBackground: Bool = false
    ) {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(coordinator: coordinator, cityData: cityData)
        )
        self.calculateBackground = calculateBackground
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(viewModel.displayCityName)
                    .font(.firagoBold(.xlarge))
                    .foregroundColor(.text)
                    .padding(.top)
                
                if let aqiDetail = viewModel.aqiDetail {
                    AQICard(aqiDetail: aqiDetail)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("დამაბინძურებლები:")
                            .font(.firagoMedium(.medium))
                            .foregroundColor(.text)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(viewModel.getPollutantDetails()) { detail in
                                PollutantGridCard(detail: detail)
                            }
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("რეკომენდაციები:")
                            .font(.firagoMedium(.medium))
                            .foregroundColor(.text)
                        
                        Text("asf asf asf asf af awfafas, majkafaskjasfas f a as fas fasfafs")
                            .font(.firago(.xxsmall))
                            .foregroundColor(.secondaryDarkText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .glassEffect(.roundedRectangle(radius: 16))
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .sheet(item: $selectedPollutant) { pollutant in
            PollutantDetailSheet(pollutantDetail: pollutant)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Group {
                if calculateBackground {
                    adaptiveBackgroundColor
                        .ignoresSafeArea()
                }
            }
        )
    }
    
    private var adaptiveBackgroundColor: Color {
        guard let aqi = viewModel.cityData.response.item?.main.aqi else {
            return Color.clear
        }
        
        switch aqi {
        case ..<50:
            return Color("Background Light")
        case 50..<100:
            return Color("Background Moderate")
        default:
            return Color("Background Dark")
        }
    }
}

#Preview {
    HomePage(
        coordinator: HomeCoordinator(),
        cityData: CityAirPollution(
            city: "Rustavi",
            localeName: "რუსთავი",
            response: AirPollutionResponse(
                coord: AirPollutionResponse.Coord(
                    lat: 41.5489,
                    lon: 44.9961
                ),
                list: [
                    AirPollutionResponse.AirPollutionItem(
                        main: AirPollutionResponse.AirPollutionItem.AQI(aqi: 2),
                        components: AirPollutionResponse.AirPollutionItem.Components(
                            co: 230.31,
                            no: 0.0,
                            no2: 0.74,
                            o3: 68.66,
                            so2: 0.64,
                            pm2_5: 3.41,
                            pm10: 3.68,
                        ),
                        dt: 1609459200
                    )
                ]
            )
        ),
        calculateBackground: true
    )
}
