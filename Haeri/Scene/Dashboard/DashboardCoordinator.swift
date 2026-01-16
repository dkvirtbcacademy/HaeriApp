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
    
    enum Destination {
        case cityDetail(CityAirPollution, HomeCoordinator, String)
    }
    
    weak var navigationController: UINavigationController?
    
    func navigate(to destination: Destination) {
        guard let navigationController = navigationController else { return }
        
        let viewController: UIViewController
        
        switch destination {
        case .cityDetail(let cityData, let homeCoordinator, let backgroudColor):
            let homeView = HomePage(
                coordinator: homeCoordinator,
                cityData: cityData,
                backgroudColor: backgroudColor
            )
            let hostingController = UIHostingController(rootView: homeView)
            viewController = hostingController
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
