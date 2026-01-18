//
//  AIRecomendations.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import SwiftUI

struct AIRecomendations: View {
    @ObservedObject var aiRecommendationManager: AIRecomendationManager
    let cityData: CityAirPollution
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("AI რეკომენდაციები:")
                    .font(.firagoMedium(.medium))
                    .foregroundColor(.text)
                
                Spacer()
                
                if !aiRecommendationManager.isLoadingRecommendation {
                    Button(action: {
                        Task {
                            await aiRecommendationManager.generateAIRecommendation(for: cityData)
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            recommendationContent
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    @ViewBuilder
    private var recommendationContent: some View {
        if aiRecommendationManager.isLoadingRecommendation {
            loadingView
        } else if let recommendation = aiRecommendationManager.aiRecommendation {
            successView(recommendation)
        } else {
            placeholderView
        }
    }
    
    private var loadingView: some View {
        SwiftUILoadingView(label: "რეკომენდაციების გენერირება...")
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .glassEffect(.roundedRectangle(radius: 16))
    }
    
    private func successView(_ recommendation: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recommendation)
                .font(.firago(.xxsmall))
                .foregroundColor(.secondaryDarkText)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .glassEffect(.roundedRectangle(radius: 16))
    }
    
    private var placeholderView: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "sparkles")
                .font(.firago(.xsmall))
                .foregroundColor(.blue)
            
            Text("დააწკაპუნეთ პერსონალიზებული რეკომენდაციების მისაღებად")
                .font(.firago(.xxsmall))
                .foregroundColor(.secondaryDarkText)
                .multilineTextAlignment(.center)
            
            Button("გენერირება") {
                Task {
                    await aiRecommendationManager.generateAIRecommendation(for: cityData)
                }
            }
            .font(.firagoMedium(.xsmall))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .glassEffect(.roundedRectangle(radius: 16))
    }
}

#Preview {
    AIRecomendations(
        aiRecommendationManager: AIRecomendationManager(
            networkManager: NetworkManager(),
            authManager: AuthManager()
        ),
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
        )
    )
}
