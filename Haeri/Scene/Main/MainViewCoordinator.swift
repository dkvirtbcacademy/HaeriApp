//
//  MainViewCoordinator.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//
import Foundation
import Combine

@MainActor
final class MainTabCoordinator: ObservableObject {
    
    enum Tab: Hashable {
        case home
        case dashboard
        case community
        case profile
    }
    
    @Published var selectedTab: Tab = .home
    
    @Published var homeCoordinator = HomeCoordinator()
    @Published var dashboardCoordinator = DashboardCoordinator()
    @Published var communityCoordinator = CommunityCoordinator()
    @Published var profileCoordinator = ProfileCoordinator()
    
    func switchTab(_ tab: Tab) {
        selectedTab = tab
    }

}
