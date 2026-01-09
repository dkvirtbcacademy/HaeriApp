//
//  HaeriApp.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

@main
struct HaeriApp: App {
    @StateObject private var dependencies = AppDependencies()
    @StateObject private var appCoordinator: AppCoordinator
    
    init() {
        let deps = AppDependencies()
        _dependencies = StateObject(wrappedValue: deps)
        _appCoordinator = StateObject(wrappedValue: AppCoordinator(
            authManager: deps.authManager,
            locationManager: deps.locationManager
        ))
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appCoordinator.rootState {
                case .authenticated:
                    MainView(
                        dependencies: dependencies,
                        coordinator: appCoordinator.mainTabCoordinator
                    )
                case .unauthenticated:
                    LoginFlowView(
                        dependencies: dependencies,
                        loginCoordinator: appCoordinator.loginCoordinator
                    )
                    .ignoresSafeArea()
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: appCoordinator.rootState)
        }
    }
}
