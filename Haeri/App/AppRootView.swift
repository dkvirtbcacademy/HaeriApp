//
//  AppRootView.swift
//  Haeri
//
//  Created by kv on 18.01.26.
//

import SwiftUI

struct AppRootView: View {
    @StateObject private var dependencies = AppDependencies()
    @StateObject private var appCoordinator: AppCoordinator
    @State private var isTransitioning = false
    
    init() {
        let deps = AppDependencies()
        _dependencies = StateObject(wrappedValue: deps)
        _appCoordinator = StateObject(wrappedValue: AppCoordinator(dependencies: deps))
    }
    
    var body: some View {
        ZStack {
            if appCoordinator.rootState == .authenticated || isTransitioning {
                MainView(
                    dependencies: dependencies,
                    coordinator: appCoordinator.mainTabCoordinator
                )
                .transition(.opacity)
                .zIndex(appCoordinator.rootState == .authenticated ? 1 : 0)
            }
            
            if appCoordinator.rootState == .unauthenticated || isTransitioning {
                LoginFlowView(
                    dependencies: dependencies,
                    loginCoordinator: appCoordinator.loginCoordinator
                )
                .ignoresSafeArea()
                .transition(.opacity)
                .zIndex(appCoordinator.rootState == .unauthenticated ? 1 : 0)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appCoordinator.rootState)
        .onChange(of: appCoordinator.rootState) { _, _ in
            isTransitioning = true
            Task {
                try? await Task.sleep(nanoseconds: 300_000_000)
                isTransitioning = false
            }
        }
    }
}
