//
//  LoginFlowView.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import SwiftUI

struct LoginFlowView: UIViewControllerRepresentable {
    @EnvironmentObject var loginCoordinator: LoginCoordinator
    @EnvironmentObject var authManager: AuthManager
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let loginVC = LoginViewController(
            coordinator: loginCoordinator,
            authManager: authManager
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
