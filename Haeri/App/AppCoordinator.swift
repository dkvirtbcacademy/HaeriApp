//
//  AppCoordinator.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import Foundation
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    
    enum RootState {
        case authenticated
        case unauthenticated
    }
    
    @Published private(set) var rootState: RootState = .unauthenticated
    @Published var loginCoordinator: LoginCoordinator
    @Published var mainTabCoordinator = MainTabCoordinator()
    
    private let authManager: AuthManager
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(authManager: AuthManager, locationManager: LocationManager) {
        self.authManager = authManager
        self.locationManager = locationManager
        self.loginCoordinator = LoginCoordinator(
            authManager: authManager,
            locationManager: locationManager
        )
        self.rootState = authManager.isLoggedIn ? .authenticated : .unauthenticated
        observeAuthChanges()
    }
    
    private func observeAuthChanges() {
        authManager.$isLoggedIn
            .sink { [weak self] isLoggedIn in
                self?.rootState = isLoggedIn ? .authenticated : .unauthenticated
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        locationManager.clearLocationOnLogout()
        authManager.logout()
        
        loginCoordinator = LoginCoordinator(
            authManager: authManager,
            locationManager: locationManager
        )
        mainTabCoordinator = MainTabCoordinator()
    }
}
