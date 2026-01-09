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
    @State private var showSheet = false
    
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
        VStack(spacing: 20) {
            Text(viewModel.cityData.city)
                .font(.firagoBold(.xxlarge))
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.pollutionDetails) { detail in
                    HStack {
                        Text(detail.label)
                            .font(.firago(.large))
                        
                        Spacer()
                        
                        Text(detail.value)
                            .font(.firagoMedium(.large))
                    }
                    .padding(.horizontal, 40)
                }
            }
            
            Button("Show Info") {
                showSheet.toggle()
            }
        }
        .sheet(isPresented: $showSheet) {
            Text("Sheet Content")
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
                            nh3: 0.47
                        ),
                        dt: 1609459200
                    )
                ]
            )
        ),
        calculateBackground: true
    )
}
