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
    @State private var showLaunchScreen = true
    
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
            ZStack {
                Group {
                    switch appCoordinator.rootState {
                    case .authenticated:
                        MainView(
                            dependencies: dependencies,
                            coordinator: appCoordinator.mainTabCoordinator
                        )
                        .transition(.opacity)
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
                
                if showLaunchScreen {
                    LaunchScreen()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .animation(.easeOut(duration: 0.5), value: showLaunchScreen)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    showLaunchScreen = false
                }
            }
        }
    }
}
