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
    @State private var airQualityIndex: Int
    
    init(
        dependencies: AppDependencies,
        coordinator: MainTabCoordinator
    ) {
        self.dependencies = dependencies
        self.coordinator = coordinator
        
        _airQualityIndex = State(initialValue: dependencies.airPollutionManager.airQualityIndex)
        
        _viewModel = StateObject(wrappedValue: MainViewModel(
            locationManager: dependencies.locationManager,
            airPollutionManager: dependencies.airPollutionManager,
            userDefaultsManager: dependencies.userDefaultsManager
        ))
    }
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            HomeFlowView(
                coordinator: coordinator.homeCoordinator,
                airPollutionManager: dependencies.airPollutionManager,
                aiRecommendationManager: dependencies.aiRecommendationManager
            )
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(MainTabCoordinator.Tab.home)
            
            DashboardFlowView(
                dashboardCoordinator: coordinator.dashboardCoordinator,
                airPollutionManager: dependencies.airPollutionManager,
                aiRecommendationManager: dependencies.aiRecommendationManager
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
            if dependencies.locationManager.authorizationStatus == .notDetermined {
                dependencies.locationManager.requestAuthorization()
            }
            
            configureTabBarAppearance()
            Task {
                await viewModel.appLaunch()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            handleScenePhaseChange(newPhase)
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().overrideUserInterfaceStyle = .light
    }
    
    private func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .background, .inactive:
            viewModel.appWentToBg()
        case .active:
            viewModel.appBecameActive()
        @unknown default:
            break
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
