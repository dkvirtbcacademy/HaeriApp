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
    @State private var airQualityIndex = 25
    
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
            
            CommunityFlowView(
                coordinator: coordinator.communityCoordinator,
                communityService: dependencies.communityService,
                authManager: dependencies.authManager
            )
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
        .environment(\.airQuality, airQualityIndex)
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
        .onReceive(dependencies.airPollutionManager.$airQualityIndex) { newValue in
            airQualityIndex = newValue
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().overrideUserInterfaceStyle = .light
            
            viewModel.appLaunch()
            
//            Task { @MainActor in
//                try await Task.sleep(nanoseconds: 1_500_000_000)
//                self.dependencies.airPollutionManager.airQualityIndex = 70
//            }
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
