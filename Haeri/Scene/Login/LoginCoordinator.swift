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
    
    enum Destination: Hashable {
        case register
        case forgotPassword
        case emailVerification(email: String)
    }
    
    weak var navigationController: UINavigationController?
    
    func navigate(to destination: Destination) {
        guard let navigationController = navigationController else { return }
        
        let viewController: UIViewController
        
//        switch destination {
//        case .register:
//            viewController = RegisterViewController(coordinator: self)
//        case .forgotPassword:
//            viewController = ForgotPasswordViewController(coordinator: self)
//        case .emailVerification(let email):
//            viewController = EmailVerificationViewController(email: email, coordinator: self)
//        }
//        
//        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
