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
    
    init() {
        let deps = AppDependencies()
        _dependencies = StateObject(wrappedValue: deps)
        _appCoordinator = StateObject(wrappedValue: AppCoordinator(dependencies: deps))
    }
    
    var body: some View {
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
    }
}
