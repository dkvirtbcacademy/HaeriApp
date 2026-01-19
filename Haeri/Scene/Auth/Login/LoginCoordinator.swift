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
    private unowned let dependencies: AppDependencies
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    func navigate(to destination: Destination) {
        guard let navigationController = navigationController else { return }
        navigationController.setNavigationBarHidden(true, animated: false)
        
        let viewController: UIViewController
        
        switch destination {
        case .register:
            let viewModel = RegisterViewModel(
                coordinator: self,
                authManager: dependencies.authManager,
                locationManager: dependencies.locationManager
            )
            viewController = RegisterViewController(
                viewModel: viewModel,
                formValidationManager: dependencies.formValidationManager
            )
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
