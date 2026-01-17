//
//  HomePage.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var viewModel: HomeViewModel
    @ObservedObject private var aiRecommendationManager: AIRecomendationManager
    private let backgroudColor: String?
    
    @State private var selectedPollutant: PollutantDetail?
    @State private var initialRecomendationLoaded = false
    
    init(
        coordinator: HomeCoordinator,
        cityData: CityAirPollution,
        aiRecommendationManager: AIRecomendationManager,
        backgroudColor: String? = nil
    ) {
        self.backgroudColor = backgroudColor
        self.aiRecommendationManager = aiRecommendationManager
        
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(coordinator: coordinator, cityData: cityData)
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(viewModel.displayCityName)
                    .font(.firagoBold(.xlarge))
                    .foregroundColor(.text)
                    .padding(.top)
                
                if let aqiDetail = viewModel.aqiDetail {
                    AQICard(
                        aqiDetail: aqiDetail,
                        onInfoTapped: {
                            selectedPollutant = aqiDetail
                        })
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("დამაბინძურებლები:")
                        .font(.firagoMedium(.medium))
                        .foregroundColor(.text)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(viewModel.getPollutantDetails()) { detail in
                            PollutantGridCard(
                                detail: detail,
                                onInfoTapped: {
                                    selectedPollutant = detail
                                })
                        }
                    }
                }
                .padding()
                
                
                AIRecomendations(
                    aiRecommendationManager: aiRecommendationManager,
                    cityData: viewModel.cityData
                )
                
            }
        }
        .sheet(item: $selectedPollutant) { pollutant in
            PollutantDetailSheet(pollutantDetail: pollutant)
        }
        .alert(item: $aiRecommendationManager.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            backgroudColor.map { Color($0) } ?? Color.clear
        )
        .onAppear {
            if !initialRecomendationLoaded {
                initialRecomendationLoaded = true
                Task {
                    await aiRecommendationManager.generateAIRecommendation(for: viewModel.cityData)
                }
            }
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
                            pm10: 3.68
                        ),
                        dt: 1609459200
                    )
                ]
            )
        ),
        aiRecommendationManager: AIRecomendationManager(
            networkManager: NetworkManager(),
            authManager: AuthManager()
        ),
        backgroudColor: "Orange Air"
    )
}
