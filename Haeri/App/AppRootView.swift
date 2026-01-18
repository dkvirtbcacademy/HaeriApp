//
//  AppRootView.swift
//  Haeri
//
//  Created by kv on 18.01.26.
//

import SwiftUI

struct AppRootView: View {
    @ObservedObject var appCoordinator: AppCoordinator
    let dependencies: AppDependencies
    
    var body: some View {
        Group {
            switch appCoordinator.rootState {
            case .authenticated:
                MainView(
                    dependencies: dependencies,
                    coordinator: dependencies.mainTabCoordinator
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
