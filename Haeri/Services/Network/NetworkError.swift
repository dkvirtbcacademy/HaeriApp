//
//  NetworkError.swift
//  Haeri
//
//  Created by kv on 08.01.26.
//

import SwiftUI

enum NetworkError: Error {
    case wrongStatusCode
    case invalidResponse(statusCode: Int, data: Data?)
    case noDataAvailable
    case decodingError
    case noResultsFound
    case networkError
    case invalidURL
    
    var localizedDescription: String {
        switch self {
        case .wrongStatusCode:
            return "Received invalid status code from server"
        case .invalidResponse(let statusCode, _):
            return "Invalid response with status code: \(statusCode)"
        case .noDataAvailable:
            return "No data received from server"
        case .decodingError:
            return "Failed to decode server response"
        case .noResultsFound:
            return "No results found"
        case .networkError:
            return "Network connection failed"
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

struct NetworkAlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct NetworkAlertContext {
    static let wrongStatusCode = NetworkAlertItem(
        title: Text("Invalid Status Code"),
        message: Text("The server returned an unexpected status code. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let noDataAvailable = NetworkAlertItem(
        title: Text("No Data"),
        message: Text("No data was received from the server. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let decodingError = NetworkAlertItem(
        title: Text("Data Error"),
        message: Text("Unable to process the server response. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let networkError = NetworkAlertItem(
        title: Text("Network Error"),
        message: Text("Unable to connect to the server. Please check your internet connection."),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidURL = NetworkAlertItem(
        title: Text("Invalid URL"),
        message: Text("The server URL is invalid. Please contact support."),
        dismissButton: .default(Text("OK"))
    )
}
