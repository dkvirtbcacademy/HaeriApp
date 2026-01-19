//
//  AppCoordinator.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import Foundation
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    
    enum RootState {
        case authenticated
        case unauthenticated
    }
    
    @Published private(set) var rootState: RootState = .unauthenticated
    @Published var loginCoordinator: LoginCoordinator
    @Published var mainTabCoordinator: MainTabCoordinator
    
    private unowned let dependencies: AppDependencies
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        self.loginCoordinator = LoginCoordinator(dependencies: dependencies)
        self.mainTabCoordinator = MainTabCoordinator()
        self.rootState = dependencies.authManager.isLoggedIn ? .authenticated : .unauthenticated
        observeAuthChanges()
    }
    
    private func observeAuthChanges() {
        dependencies.authManager.$isLoggedIn
            .sink { [weak self] isLoggedIn in
                self?.rootState = isLoggedIn ? .authenticated : .unauthenticated
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        dependencies.locationManager.clearLocationOnLogout()
        dependencies.authManager.logout()
        
        loginCoordinator = LoginCoordinator(dependencies: dependencies)
        mainTabCoordinator = MainTabCoordinator()
    }
}
