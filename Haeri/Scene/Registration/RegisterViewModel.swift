//
//  RegisterViewModel.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import Foundation
import Combine

final class RegisterViewModel: ObservableObject {
    private let coordinator: LoginCoordinator
    private let authManager: AuthManager
    private let locationManager: LocationManager
    
    init(
        coordinator: LoginCoordinator,
        authManager: AuthManager,
        locationManager: LocationManager
    ) {
        self.coordinator = coordinator
        self.authManager = authManager
        self.locationManager = locationManager
    }
    
    func navigateBack() {
        coordinator.navigateBack()
    }
}
