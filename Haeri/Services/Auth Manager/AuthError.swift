//
//  AuthError.swift
//  Haeri
//
//  Created by kv on 18.01.26.
//

import SwiftUI

enum AuthError: Error {
    case userNotFound
    case invalidCredentials
    case weakPassword
    case emailAlreadyInUse
    case networkError
    case firestoreError(String)
    case invalidEmail
    case userDisabled
    case tooManyRequests
    case operationNotAllowed
    case requiresRecentLogin
    case unknown(String)
}

struct AuthAlertContext {
    static let userNotFound = AlertItem(
        title: Text("User Not Found"),
        message: Text("No account exists with this email address."),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidCredentials = AlertItem(
        title: Text("Invalid Credentials"),
        message: Text("The email or password you entered is incorrect."),
        dismissButton: .default(Text("OK"))
    )
    
    static let weakPassword = AlertItem(
        title: Text("Weak Password"),
        message: Text("Password must be at least 6 characters long."),
        dismissButton: .default(Text("OK"))
    )
    
    static let emailAlreadyInUse = AlertItem(
        title: Text("Email Already Registered"),
        message: Text("An account with this email already exists."),
        dismissButton: .default(Text("OK"))
    )
    
    static let networkError = AlertItem(
        title: Text("Network Error"),
        message: Text("Please check your internet connection."),
        dismissButton: .default(Text("OK"))
    )
    
    static func firestoreError(message: String) -> AlertItem {
        AlertItem(
            title: Text("Database Error"),
            message: Text("Error: \(message)"),
            dismissButton: .default(Text("OK"))
        )
    }
    
    static let invalidEmail = AlertItem(
        title: Text("Invalid Email"),
        message: Text("Please enter a valid email address."),
        dismissButton: .default(Text("OK"))
    )
    
    static let userDisabled = AlertItem(
        title: Text("Account Disabled"),
        message: Text("Your account has been disabled."),
        dismissButton: .default(Text("OK"))
    )
    
    static let tooManyRequests = AlertItem(
        title: Text("Too Many Attempts"),
        message: Text("Please wait a few minutes and try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let operationNotAllowed = AlertItem(
        title: Text("Operation Not Allowed"),
        message: Text("This sign-in method is not enabled."),
        dismissButton: .default(Text("OK"))
    )
    
    static let requiresRecentLogin = AlertItem(
        title: Text("Authentication Required"),
        message: Text("Please sign out and sign back in."),
        dismissButton: .default(Text("OK"))
    )
    
    static func unknown(message: String) -> AlertItem {
        AlertItem(
            title: Text("Error"),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }
}


struct AuthUIKitAlertContext {
    static let userNotFound = UIKitAlertItem(
        title: "User Not Found",
        message: "No account exists with this email address."
    )
    
    static let invalidCredentials = UIKitAlertItem(
        title: "Invalid Credentials",
        message: "The email or password you entered is incorrect."
    )
    
    static let weakPassword = UIKitAlertItem(
        title: "Weak Password",
        message: "Password must be at least 6 characters long."
    )
    
    static let emailAlreadyInUse = UIKitAlertItem(
        title: "Email Already Registered",
        message: "An account with this email already exists."
    )
    
    static let networkError = UIKitAlertItem(
        title: "Network Error",
        message: "Please check your internet connection."
    )
    
    static func firestoreError(message: String) -> UIKitAlertItem {
        UIKitAlertItem(
            title: "Database Error",
            message: "Error: \(message)"
        )
    }
    
    static let invalidEmail = UIKitAlertItem(
        title: "Invalid Email",
        message: "Please enter a valid email address."
    )
    
    static let userDisabled = UIKitAlertItem(
        title: "Account Disabled",
        message: "Your account has been disabled."
    )
    
    static let tooManyRequests = UIKitAlertItem(
        title: "Too Many Attempts",
        message: "Please wait a few minutes and try again."
    )
    
    static let operationNotAllowed = UIKitAlertItem(
        title: "Operation Not Allowed",
        message: "This sign-in method is not enabled."
    )
    
    static let requiresRecentLogin = UIKitAlertItem(
        title: "Authentication Required",
        message: "Please sign out and sign back in."
    )
    
    static func unknown(message: String) -> UIKitAlertItem {
        UIKitAlertItem(
            title: "Error",
            message: message
        )
    }
}
