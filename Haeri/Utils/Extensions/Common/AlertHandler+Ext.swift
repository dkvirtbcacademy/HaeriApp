//
//  ErrorHandler.swift
//  Haeri
//
//  Created by kv on 08.01.26.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

@MainActor
protocol AlertHandler: AnyObject {
    var alertItem: AlertItem? { get set }
}

extension AlertHandler {
    func handleNetworkError(_ error: NetworkError, context: String = "") {
        switch error {
        case .wrongStatusCode:
            alertItem = NetworkAlertContext.wrongStatusCode
        case .invalidResponse(let statusCode, _):
            alertItem = NetworkAlertContext.wrongStatusCode
        case .noDataAvailable:
            alertItem = NetworkAlertContext.noDataAvailable
        case .decodingError:
            alertItem = NetworkAlertContext.decodingError
        case .noResultsFound:
            alertItem = NetworkAlertContext.noDataAvailable
        case .networkError:
            alertItem = NetworkAlertContext.networkError
        case .invalidURL:
            alertItem = NetworkAlertContext.invalidURL
        }
    }
    
    func handleAirPollutionError(_ error: AirPollutionError) {
        switch error {
        case .cityNotFound(let cityName):
            alertItem = AirPollutionAlertContent.cityNotFound(cityName: cityName)
        case .dataUnavailable:
            alertItem = AirPollutionAlertContent.airPollutionDataUnavailable
        case .coordinatesNotFound(let cityName):
            alertItem = AirPollutionAlertContent.cityNotFound(cityName: cityName)
        }
    }
    
    func handleAIRecomendationError(_ error: AIRecomendationError) {
        switch error {
        case .invalidURL:
            alertItem = AIRecomendationAlertContext.invalidURL
        case .encodingError:
            alertItem = AIRecomendationAlertContext.encodingError
        case .invalidResponse:
            alertItem = AIRecomendationAlertContext.invalidResponse
        case .invalidRequest:
            alertItem = AIRecomendationAlertContext.invalidRequest
        case .authenticationError:
            alertItem = AIRecomendationAlertContext.authenticationError
        case .rateLimitError:
            alertItem = AIRecomendationAlertContext.rateLimitError
        case .serverError:
            alertItem = AIRecomendationAlertContext.serverError
        case .decodingError:
            alertItem = AIRecomendationAlertContext.decodingError
        case .emptyResponse:
            alertItem = AIRecomendationAlertContext.emptyResponse
        }
    }
}
