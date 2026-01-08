//
//  DashboardFlowView.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI

struct DashboardFlowView: UIViewControllerRepresentable {
    @ObservedObject var coordinator: DashboardCoordinator
    @ObservedObject var authManager: AuthManager
    @Environment(\.airQuality) var airQuality
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let dashboardVC = DashboardViewController(
            coordinator: coordinator,
            authManager: authManager
        )
        let navigationController = UINavigationController(rootViewController: dashboardVC)
        
        coordinator.navigationController = navigationController
        
        dashboardVC.updateAirQuality(airQuality)
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        if let profileVC = uiViewController.viewControllers.first as? ProfileViewController {
            profileVC.updateAirQuality(airQuality)
        }
    }
}
