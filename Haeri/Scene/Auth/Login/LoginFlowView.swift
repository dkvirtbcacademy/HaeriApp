//
//  LoginFlowView.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

struct LoginFlowView: UIViewControllerRepresentable {
    @ObservedObject var dependencies: AppDependencies
    @ObservedObject var loginCoordinator: LoginCoordinator
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewModel = LoginViewModel(
            coordinator: loginCoordinator,
            authManager: dependencies.authManager,
            locationManager: dependencies.locationManager
        )
        let loginVC = LoginViewController(
            viewModel:viewModel,
            formValidationManager: dependencies.formValidationManager
        )
        
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        
        loginCoordinator.navigationController = navigationController
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
