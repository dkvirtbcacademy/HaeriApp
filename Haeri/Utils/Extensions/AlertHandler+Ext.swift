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
}
