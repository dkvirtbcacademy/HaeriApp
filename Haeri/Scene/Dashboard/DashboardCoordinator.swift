//
//  DashboardCoordinator.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI
import Combine

@MainActor
final class DashboardCoordinator: ObservableObject {
    
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
