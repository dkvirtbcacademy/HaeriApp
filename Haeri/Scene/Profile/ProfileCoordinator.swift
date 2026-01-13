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
    
    enum Destination: Hashable {
        case changeName
        case changePassword
        case changeAvatar
        case changeCategory
        case removeAccount
    }
    
    weak var navigationController: UINavigationController?
    weak var profileViewModel: ProfileViewModel?
    
    func navigate(to destination: Destination) {
        guard let navigationController = navigationController,
              let profileViewModel = profileViewModel else { return }
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        let viewController: UIViewController
        
        switch destination {
        case .changeName:
            viewController = ChangeNameViewController(viewModel: profileViewModel)
        case .changePassword:
            viewController = ChangePasswordViewController(viewModel: profileViewModel)
        case .changeAvatar:
            viewController = ChangeAvatarViewController(viewModel: profileViewModel)
        case .changeCategory:
            viewController = ChangeCategoryViewController(viewModel: profileViewModel)
        case .removeAccount:
            viewController = RemoveAccountViewController(viewModel: profileViewModel)
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
