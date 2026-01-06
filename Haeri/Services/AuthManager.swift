//
//  AuthManager.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import Foundation
import Combine

@MainActor
final class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    func login() {
        isLoggedIn = true
    }
    
    func logout() {
        isLoggedIn = false
    }
}
