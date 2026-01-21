//
//  LoginViewModel.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class LoginViewModel: ObservableObject {
    let coordinator: LoginCoordinator
    let authManager: AuthManager
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var currentStep: Int = 1
    @Published private(set) var buttonTitle: String = "დაწყება"
    
    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    
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
    
    func moveToNextStep() {
        if currentStep < maxSteps {
            currentStep += 1
            updateButtonTitle()
        }
    }
    
    private func updateButtonTitle() {
        buttonTitle = currentStep == 2 ? "გაგრძელება" : "დაწყება"
    }
    
    func loginUser() async {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways, .denied:
            await authManager.login(email: userEmail, password: userPassword)
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
                guard let self = self else { return }
                
                switch status {
                case .authorizedWhenInUse, .authorizedAlways, .denied, .restricted:
                    Task { @MainActor in
                        await self.authManager.login(email: self.userEmail, password: self.userPassword)
                    }
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func navigateToRegister() {
        authManager.authError = nil
        coordinator.navigate(to: .register)
    }
}
