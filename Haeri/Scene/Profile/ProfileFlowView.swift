//
//  ProfileFlowView.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI

struct ProfileFlowView: UIViewControllerRepresentable {
    @ObservedObject var coordinator: ProfileCoordinator
    @ObservedObject var authManager: AuthManager
    @Environment(\.airQuality) var airQuality
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewModel = ProfileViewModel(
            coordinator: coordinator,
            authManager: authManager
        )
        
        coordinator.profileViewModel = viewModel
        
        let profileVC = ProfileViewController(
            viewModel: viewModel
        )
        let navigationController = UINavigationController(rootViewController: profileVC)
        
        coordinator.navigationController = navigationController
        
        profileVC.updateAirQuality(airQuality)
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        if let profileVC = uiViewController.viewControllers.first as? ProfileViewController {
            profileVC.updateAirQuality(airQuality)
        }
    }
}
