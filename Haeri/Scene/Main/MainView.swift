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
    
    @ObservedObject private var coordinator: MainTabCoordinator
    @StateObject private var viewModel: MainViewModel
    
    @StateObject private var airPollutionManager: AirPollutionManager
    @ObservedObject private var authManager: AuthManager
    @ObservedObject private var locationManager: LocationManager
    @ObservedObject private var networkManager: NetworkManager
    
    @State private var airQualityIndex = 25
    @Environment(\.scenePhase) private var scenePhase
    
    init(
        authManager: AuthManager,
        locationManager: LocationManager,
        networkManager: NetworkManager,
        coordinator: MainTabCoordinator
    ) {
        self.authManager = authManager
        self.locationManager = locationManager
        self.networkManager = networkManager
        self.coordinator = coordinator
        
        let airPollution = AirPollutionManager(networkManager: networkManager)
        _airPollutionManager = StateObject(wrappedValue: airPollution)
        
        _viewModel = StateObject(wrappedValue: MainViewModel(
            locationManager: locationManager,
            airPollutionManager: airPollution
        ))
    }
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            
            HomeFlowView(coordinator: coordinator.homeCoordinator)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(MainTabCoordinator.Tab.home)
            
            DashboardFlowView(coordinator: coordinator.dashboardCoordinator)
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
            
            ProfileFlowView(authManager: authManager, coordinator: coordinator.profileCoordinator)
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
        .onAppear {
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
    MainView(
        authManager: AuthManager(),
        locationManager: LocationManager(),
        networkManager: NetworkManager(),
        coordinator: MainTabCoordinator()
    )
}
