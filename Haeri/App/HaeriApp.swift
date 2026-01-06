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
    @StateObject private var appCoordinator: AppCoordinator
    
    init() {
        let authManager = AuthManager()
        _authManager = StateObject(wrappedValue: authManager)
        _appCoordinator = StateObject(wrappedValue: AppCoordinator(authManager: authManager))
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appCoordinator.rootState {
                case .authenticated:
                    MainView()
                        .environmentObject(appCoordinator.mainTabCoordinator)
                        .transition(.opacity)
                case .unauthenticated:
                    LoginFlowView()
                        .environmentObject(appCoordinator.loginCoordinator)
                        .environmentObject(authManager)
                        .ignoresSafeArea()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: appCoordinator.rootState)
            .environmentObject(authManager)
            .environmentObject(appCoordinator)
        }
    }
}
