//
//  AIRecomendationManager.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import Foundation
import Combine

@MainActor
final class AIRecomendationManager: ObservableObject, AlertHandler {
    private let networkManager: NetworkManager
    private let authManager: AuthManager
    private var currentCityData: CityAirPollution?
    
    var displayCityName: String {
        currentCityData?.city ?? "unknown"
    }
    
    @Published var aiRecommendation: String?
    @Published var isLoadingRecommendation = false
    @Published var alertItem: AlertItem?
    
    private let groqAPIKey = Secrets.AIApiKey
    private let groqAPIURL = "https://api.groq.com/openai/v1/chat/completions"
    
    init(networkManager: NetworkManager, authManager: AuthManager) {
        self.networkManager = networkManager
        self.authManager = authManager
    }
    
    func clearRecommendation() {
        aiRecommendation = nil
        currentCityData = nil
        isLoadingRecommendation = false
    }
    
    func generateAIRecommendation(for cityData: CityAirPollution) async {
        self.currentCityData = cityData
        
        guard let airPollutionItem = cityData.response.item else {
            alertItem = AirPollutionAlertContent.airPollutionDataUnavailable
            return
        }
        
        isLoadingRecommendation = true
        aiRecommendation = nil
        
        do {
            let recommendation = try await generateRecommendationFromAPI(
                userCategories: getUserCategories(),
                airPollution: airPollutionItem
            )
            aiRecommendation = recommendation
        } catch let error as AIRecomendationError {
            handleAIRecomendationError(error)
        } catch let error as NetworkError {
            handleNetworkError(error)
        } catch {
            alertItem = AIRecomendationAlertContext.serverError
        }
        
        isLoadingRecommendation = false
    }
    
    private func getUserCategories() -> [UserCategoryModel] {
        guard let user = authManager.currentUser else {
            return []
        }
        
        return authManager.userCategories.filter { categoryModel in
            user.categories.contains(categoryModel.slug)
        }
    }
    
    private func generateRecommendationFromAPI(
        userCategories: [UserCategoryModel],
        airPollution: AirPollutionResponse.AirPollutionItem
    ) async throws -> String {
        
        let prompt = buildPrompt(
            userCategories: userCategories,
            airPollution: airPollution
        )
        
        let requestBody = GroqAPIRequest(
            model: "llama-3.3-70b-versatile",
            messages: [GroqMessage(role: "user", content: prompt)],
            temperature: 0.7,
            topP: 0.9
        )
        
        guard let url = URL(string: groqAPIURL) else {
            throw AIRecomendationError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(groqAPIKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            throw AIRecomendationError.encodingError
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIRecomendationError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            switch httpResponse.statusCode {
            case 401, 403: throw AIRecomendationError.authenticationError
            case 429: throw AIRecomendationError.rateLimitError
            case 500...: throw AIRecomendationError.serverError
            default: throw AIRecomendationError.invalidRequest
            }
        }
        
        do {
            let result = try JSONDecoder().decode(GroqAPIResponse.self, from: data)
            
            guard let content = result.choices.first?.message.content?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !content.isEmpty else {
                throw AIRecomendationError.emptyResponse
            }
            
            return content
        } catch {
            throw AIRecomendationError.decodingError
        }
    }
    
    private func buildPrompt(
        userCategories: [UserCategoryModel],
        airPollution: AirPollutionResponse.AirPollutionItem
    ) -> String {
        let categories = userCategories.isEmpty
        ? "ზოგადი მომხმარებელი"
        : userCategories.map { $0.label }.joined(separator: ", ")
        
        let aqiInfo = "AQI: \(airPollution.main.aqi) (\(airPollution.aqiCategory.description))"
        let pm25Info = "PM2.5: \(String(format: "%.1f", airPollution.components.pm2_5)) μg/m³ (\(airPollution.pm25Level.description))"
        let pm10Info = "PM10: \(String(format: "%.1f", airPollution.components.pm10)) μg/m³ (\(airPollution.pm10Level.description))"
        let coInfo = "CO: \(String(format: "%.1f", airPollution.components.co / 1000)) mg/m³ (\(airPollution.coLevel.description))"
        let no2Info = "NO₂: \(String(format: "%.1f", airPollution.components.no2)) μg/m³ (\(airPollution.no2Level.description))"
        let o3Info = "O₃: \(String(format: "%.1f", airPollution.components.o3)) μg/m³ (\(airPollution.o3Level.description))"
        let so2Info = "SO₂: \(String(format: "%.1f", airPollution.components.so2)) μg/m³ (\(airPollution.so2Level.description))"
        
        return """
        შენ ხარ ჰაერის ხარისხის ექსპერტი. დაწერე მოკლე, კონკრეტული რეკომენდაცია ქართულად.
        
        მომხმარებელი: \(categories)
        ქალაქი: \(displayCityName)
        
        ჰაერის მონაცემები:
        • \(aqiInfo)
        • \(pm25Info)
        • \(pm10Info)
        • \(coInfo)
        • \(no2Info)
        • \(o3Info)
        • \(so2Info)
        
        დაწერე მხოლოდ 4-5 წინადადება ქართულად:
        1. ვითარების შეფასება (1 წინადადება)
        2. მთავარი რეკომენდაციები (2-3 წინადადება)
        3. დამატებითი რჩევა (1 წინადადება)
        
        პასუხი: მხოლოდ ქართულად, პარაგრაფებით, 4-5 წინადადება, კონკრეტული რჩევები.
        """
    }
}
