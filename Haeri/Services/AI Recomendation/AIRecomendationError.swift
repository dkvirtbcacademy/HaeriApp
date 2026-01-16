//
//  AIRecomendationError.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import SwiftUI

enum AIRecomendationError: Error {
    case invalidURL
    case encodingError
    case invalidResponse
    case invalidRequest
    case authenticationError
    case rateLimitError
    case serverError
    case decodingError
    case emptyResponse
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .encodingError:
            return "Failed to encode request"
        case .invalidResponse:
            return "Invalid server response"
        case .invalidRequest:
            return "Invalid request"
        case .authenticationError:
            return "Authentication failed"
        case .rateLimitError:
            return "Rate limit exceeded"
        case .serverError:
            return "Server error"
        case .decodingError:
            return "Failed to decode response"
        case .emptyResponse:
            return "Empty response from API"
        }
    }
}

struct AIRecomendationAlertContext {
    static let invalidURL = AlertItem(
        title: Text("Invalid URL"),
        message: Text("The API URL is invalid. Please contact support."),
        dismissButton: .default(Text("OK"))
    )
    
    static let encodingError = AlertItem(
        title: Text("Request Error"),
        message: Text("Failed to prepare the request. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidResponse = AlertItem(
        title: Text("Invalid Response"),
        message: Text("Received an invalid response from the AI service. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidRequest = AlertItem(
        title: Text("Invalid Request"),
        message: Text("The request could not be processed. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let authenticationError = AlertItem(
        title: Text("Authentication Failed"),
        message: Text("Unable to authenticate with the AI service. Please contact support."),
        dismissButton: .default(Text("OK"))
    )
    
    static let rateLimitError = AlertItem(
        title: Text("Rate Limit Exceeded"),
        message: Text("Too many requests. Please wait a moment and try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let serverError = AlertItem(
        title: Text("Server Error"),
        message: Text("The AI service is experiencing issues. Please try again later."),
        dismissButton: .default(Text("OK"))
    )
    
    static let decodingError = AlertItem(
        title: Text("Data Error"),
        message: Text("Unable to process the AI response. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let emptyResponse = AlertItem(
        title: Text("No Response"),
        message: Text("No recommendation was generated. Please try again."),
        dismissButton: .default(Text("OK"))
    )
}
