//
//  AirPollutionError.swift
//  Haeri
//
//  Created by kv on 08.01.26.
//

import SwiftUI

enum AirPollutionError: Error {
    case cityNotFound(cityName: String)
    case dataUnavailable
    case coordinatesNotFound(cityName: String)
    
    var localizedDescription: String {
        switch self {
        case .cityNotFound(let cityName):
            return "City '\(cityName)' not found"
        case .dataUnavailable:
            return "Air pollution data unavailable"
        case .coordinatesNotFound(let cityName):
            return "Coordinates not found for '\(cityName)'"
        }
    }
}

struct AirPollutionAlertContent {
    static func cityNotFound(cityName: String) -> AlertItem {
        AlertItem(
            title: Text("City Not Found"),
            message: Text("Unable to find coordinates for '\(cityName)'. Please check the spelling and try again."),
            dismissButton: .default(Text("OK"))
        )
    }
    
    static func noCitiesFound(searchTerm: String) -> AlertItem {
        AlertItem(
            title: Text("No Results"),
            message: Text("No cities found matching '\(searchTerm)'. Please try a different search term."),
            dismissButton: .default(Text("OK"))
        )
    }
    
    static let airPollutionDataUnavailable = AlertItem(
        title: Text("Data Unavailable"),
        message: Text("Air pollution data is currently unavailable for this location. Please try again later."),
        dismissButton: .default(Text("OK"))
    )
}
