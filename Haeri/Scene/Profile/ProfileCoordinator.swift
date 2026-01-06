//
//  ProfileCoordinator.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//
import Combine
import UIKit

@MainActor
final class ProfileCoordinator: ObservableObject {
    
    enum Destination: Hashable {}
    
    weak var navigationController: UINavigationController?
    
    func navigate(to destination: Destination) {
        guard let navigationController = navigationController else { return }
        
        let viewController: UIViewController
    }
    
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
