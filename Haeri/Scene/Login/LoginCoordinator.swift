//
//  LoginCoordinator.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//
import Combine
import UIKit

@MainActor
final class LoginCoordinator: ObservableObject {
    
    enum Destination {
        case register
    }
    
    weak var navigationController: UINavigationController?
    
    private let authManager: AuthManager
    private let locationManager: LocationManager
    
    init(authManager: AuthManager, locationManager: LocationManager) {
        self.authManager = authManager
        self.locationManager = locationManager
    }
    
    func navigate(to destination: Destination) {
        guard let navigationController = navigationController else { return }
        navigationController.setNavigationBarHidden(true, animated: false)
        
        let viewController: UIViewController
        
        switch destination {
        case .register:
            let viewModel = RegisterViewModel(
                coordinator: self,
                authManager: authManager,
                locationManager: locationManager
            )
            viewController = RegisterViewController(viewModel: viewModel)
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
