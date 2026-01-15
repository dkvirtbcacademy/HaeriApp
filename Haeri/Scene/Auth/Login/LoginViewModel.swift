//
//  LoginViewModel.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import Foundation
import Combine
import CoreLocation

final class LoginViewModel: ObservableObject {
    private let coordinator: LoginCoordinator
    private let authManager: AuthManager
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var currentStep: Int = 1
    @Published private(set) var buttonTitle: String = "დაწყება"
    
    let maxSteps = 2
    
    init(
        coordinator: LoginCoordinator,
        authManager: AuthManager,
        locationManager: LocationManager
    ) {
        self.coordinator = coordinator
        self.authManager = authManager
        self.locationManager = locationManager
        
        observeAuthorizationStatus()
    }
    
    func handleButtonTap() {
        if currentStep == maxSteps {
            createAccount()
            return
        }
        
        if currentStep < maxSteps {
            currentStep += 1
            updateButtonTitle()
        }
    }
    
    private func updateButtonTitle() {
        buttonTitle = currentStep == 2 ? "გაგრძელება" : "დაწყება"
    }
    
    private func createAccount() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways, .denied:
            authManager.login()
        case .notDetermined:
            locationManager.requestAuthorization()
        default:
            break
        }
    }
    
    private func observeAuthorizationStatus() {
        locationManager.$authorizationStatus
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] status in
                switch status {
                case .authorizedWhenInUse, .authorizedAlways, .denied, .restricted:
                    self?.authManager.login()
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func navigateToRegister() {
        coordinator.navigate(to: .register)
    }
    
}
