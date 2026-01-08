//
//  HaeriApp.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

@main
struct HaeriApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var networkManager = NetworkManager()
    @StateObject private var appCoordinator: AppCoordinator
    
    
    init() {
        let authManager = AuthManager()
        let locationManager = LocationManager()
        
        _authManager = StateObject(wrappedValue: authManager)
        _locationManager = StateObject(wrappedValue: locationManager)
        _appCoordinator = StateObject(wrappedValue: AppCoordinator(authManager: authManager, locationManager: locationManager))
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appCoordinator.rootState {
                case .authenticated:
                    MainView(
                        authManager: authManager,
                        locationManager: locationManager,
                        networkManager: networkManager,
                        coordinator: appCoordinator.mainTabCoordinator
                    )
                case .unauthenticated:
                    LoginFlowView(
                        loginCoordinator: appCoordinator.loginCoordinator,
                        authManager: authManager,
                        locationManager: locationManager
                    )
                    .ignoresSafeArea()
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: appCoordinator.rootState)
        }
    }
}
