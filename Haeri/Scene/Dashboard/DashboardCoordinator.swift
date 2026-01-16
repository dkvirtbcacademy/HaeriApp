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
        case cityDetail(CityAirPollution, HomeCoordinator, AIRecomendationManager, String)
        case addCity(DashboardViewModel, AddCityViewControllerDelegate)
    }
    
    weak var navigationController: UINavigationController?
    
    func navigate(to destination: Destination) {
        guard let navigationController = navigationController else { return }
        
        let viewController: UIViewController
        
        switch destination {
        case .cityDetail(
            let cityData,
            let homeCoordinator,
            let aiRecommendationManager,
            let backgroudColor
        ):
            let homeView = HomePage(
                coordinator: homeCoordinator,
                cityData: cityData,
                aiRecommendationManager: aiRecommendationManager,
                backgroudColor: backgroudColor
            )
            let hostingController = UIHostingController(rootView: homeView)
            viewController = hostingController
            
        case .addCity(let viewModel, let delegate):
            let addCityVC = AddCityViewController(viewModel: viewModel)
            addCityVC.delegate = delegate
            
            let navController = UINavigationController(rootViewController: addCityVC)
            
            if let sheet = navController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
            }
            
            navigationController.present(navController, animated: true)
            return
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
