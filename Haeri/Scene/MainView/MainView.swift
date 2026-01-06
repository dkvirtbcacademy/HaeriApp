//
//  MainView.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var coordinator = MainTabCoordinator()
    @State private var airQualityIndex = 25
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            
            HomeFlowView(coordinator: coordinator.homeCoordinator)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(MainTabCoordinator.Tab.home)
            
            DashboardFlowView(coordinator: coordinator.dashboardCoordinator)
                .tabItem {
                    Label("Dashboard", systemImage: "list.dash.header.rectangle.fill")
                }
                .tag(MainTabCoordinator.Tab.dashboard)
            
            CommunityFlowView(coordinator: coordinator.communityCoordinator)
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
                .tag(MainTabCoordinator.Tab.community)
            
            ProfileFlowView(coordinator: coordinator.profileCoordinator)
                .ignoresSafeArea()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(MainTabCoordinator.Tab.profile)
        }
        .onAppear {
            Task { @MainActor in
                try await Task.sleep(nanoseconds: 3_000_000_000)
                self.airQualityIndex = 160
            }
        }
        .environmentObject(coordinator)
        .environment(\.airQuality, airQualityIndex)
    }
}

#Preview {
    MainView()
}
