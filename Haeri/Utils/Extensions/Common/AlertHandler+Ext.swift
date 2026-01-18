//
//  ErrorHandler.swift
//  Haeri
//
//  Created by kv on 08.01.26.
//

import SwiftUI
import UIKit

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct UIKitAlertItem {
    let title: String
    let message: String
    let buttonTitle: String
    
    init(title: String, message: String, buttonTitle: String = "OK") {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
}

@MainActor
protocol AlertHandler: AnyObject {
    var alertItem: AlertItem? { get set }
}

@MainActor
protocol UIKitAlertHandler: AnyObject {
    func showAlert(_ alertItem: UIKitAlertItem)
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
    
    func handleAuthError(_ error: AuthError) {
        switch error {
        case .userNotFound:
            alertItem = AuthAlertContext.userNotFound
        case .invalidCredentials:
            alertItem = AuthAlertContext.invalidCredentials
        case .weakPassword:
            alertItem = AuthAlertContext.weakPassword
        case .emailAlreadyInUse:
            alertItem = AuthAlertContext.emailAlreadyInUse
        case .networkError:
            alertItem = AuthAlertContext.networkError
        case .firestoreError(let message):
            alertItem = AuthAlertContext.firestoreError(message: message)
        case .invalidEmail:
            alertItem = AuthAlertContext.invalidEmail
        case .userDisabled:
            alertItem = AuthAlertContext.userDisabled
        case .tooManyRequests:
            alertItem = AuthAlertContext.tooManyRequests
        case .operationNotAllowed:
            alertItem = AuthAlertContext.operationNotAllowed
        case .requiresRecentLogin:
            alertItem = AuthAlertContext.requiresRecentLogin
        case .unknown(let message):
            alertItem = AuthAlertContext.unknown(message: message)
        }
    }
}

extension UIKitAlertHandler where Self: UIViewController {
    func showAlert(_ alertItem: UIKitAlertItem) {
        let alert = UIAlertController(
            title: alertItem.title,
            message: alertItem.message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: alertItem.buttonTitle,
            style: .default
        ))
        
        present(alert, animated: true)
    }
    
    func handleAuthError(_ error: AuthError) {
        let alertItem: UIKitAlertItem
        
        switch error {
        case .userNotFound:
            alertItem = AuthUIKitAlertContext.userNotFound
        case .invalidCredentials:
            alertItem = AuthUIKitAlertContext.invalidCredentials
        case .weakPassword:
            alertItem = AuthUIKitAlertContext.weakPassword
        case .emailAlreadyInUse:
            alertItem = AuthUIKitAlertContext.emailAlreadyInUse
        case .networkError:
            alertItem = AuthUIKitAlertContext.networkError
        case .firestoreError(let message):
            alertItem = AuthUIKitAlertContext.firestoreError(message: message)
        case .invalidEmail:
            alertItem = AuthUIKitAlertContext.invalidEmail
        case .userDisabled:
            alertItem = AuthUIKitAlertContext.userDisabled
        case .tooManyRequests:
            alertItem = AuthUIKitAlertContext.tooManyRequests
        case .operationNotAllowed:
            alertItem = AuthUIKitAlertContext.operationNotAllowed
        case .requiresRecentLogin:
            alertItem = AuthUIKitAlertContext.requiresRecentLogin
        case .unknown(let message):
            alertItem = AuthUIKitAlertContext.unknown(message: message)
        }
        
        showAlert(alertItem)
    }
}
