//
//  DashboardFlowView.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI

struct DashboardFlowView: UIViewControllerRepresentable {
    @ObservedObject private var dashboardCoordinator: DashboardCoordinator
    @ObservedObject private var airPollutionManager: AirPollutionManager
    @EnvironmentObject private var coordinator: MainTabCoordinator
    @Environment(\.airQuality) private var airQuality
    
    init(dashboardCoordinator: DashboardCoordinator, airPollutionManager: AirPollutionManager) {
        self.dashboardCoordinator = dashboardCoordinator
        self.airPollutionManager = airPollutionManager
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewModel = DashboardViewModel(
            coordinator: dashboardCoordinator,
            homeCoordinator: coordinator.homeCoordinator,
            airPollutionManager: airPollutionManager
        )
        
        let dashboardVC = DashboardViewController(
            viewModel: viewModel
        )
        let navigationController = UINavigationController(rootViewController: dashboardVC)
        
        dashboardCoordinator.navigationController = navigationController
        
        dashboardVC.updateAirQuality(airQuality)
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        if let dashboardVC = uiViewController.viewControllers.first as? DashboardViewController {
            dashboardVC.updateAirQuality(airQuality)
        }
    }
}
