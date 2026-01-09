//
//  MainView.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI
import CoreLocation
import Combine

struct MainView: View {
    
    @ObservedObject private var dependencies: AppDependencies
    @ObservedObject private var coordinator: MainTabCoordinator
    @StateObject private var viewModel: MainViewModel
    
    @Environment(\.scenePhase) private var scenePhase
    
    init(
        dependencies: AppDependencies,
        coordinator: MainTabCoordinator
    ) {
        self.dependencies = dependencies
        self.coordinator = coordinator
        
        _viewModel = StateObject(wrappedValue: MainViewModel(
            locationManager: dependencies.locationManager,
            airPollutionManager: dependencies.airPollutionManager
        ))
    }
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            
            HomeFlowView(
                coordinator: coordinator.homeCoordinator,
                airPollutionManager: dependencies.airPollutionManager
            )
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(MainTabCoordinator.Tab.home)
            
            DashboardFlowView(
                dashboardCoordinator: coordinator.dashboardCoordinator,
                airPollutionManager: dependencies.airPollutionManager
            )
            .ignoresSafeArea()
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash.header.rectangle.fill")
                }
                .tag(MainTabCoordinator.Tab.dashboard)
            
            CommunityFlowView(coordinator: coordinator.communityCoordinator)
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
                .tag(MainTabCoordinator.Tab.community)
            
            ProfileFlowView(
                coordinator: coordinator.profileCoordinator,
                authManager: dependencies.authManager
            )
            .ignoresSafeArea()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(MainTabCoordinator.Tab.profile)
        }
        .environmentObject(coordinator)
        .environment(\.airQuality, dependencies.airPollutionManager.airQualityIndex)
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            viewModel.appLaunch()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background || newPhase == .inactive {
                viewModel.appWentToBg()
            } else if newPhase == .active {
                viewModel.appBecameActive()
            }
        }
    }
}

#Preview {
    let deps = AppDependencies()
    MainView(
        dependencies: deps,
        coordinator: MainTabCoordinator()
    )
}
