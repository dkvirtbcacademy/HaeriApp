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
    
    @Published private(set) var currentStep: Int = 1
    @Published private(set) var buttonTitle: String = "დაწყება"
    
    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    
    let maxSteps = 2
    
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    private var isWaitingForLocationPermission = false
    
    init(
        coordinator: LoginCoordinator,
        authManager: AuthManager,
        locationManager: LocationManager
    ) {
        self.coordinator = coordinator
        self.authManager = authManager
        self.locationManager = locationManager
        observeLocationPermission()
    }
    
    func moveToNextStep() {
        if currentStep < maxSteps {
            currentStep += 1
            updateButtonTitle()
        }
    }
    
    func handleButtonTap() async {
        if currentStep == maxSteps {
            await login()
        }
    }
    
    func navigateToRegister() {
        authManager.authError = nil
        coordinator.navigate(to: .register)
    }
    
    
    private func updateButtonTitle() {
        buttonTitle = currentStep == 2 ? "გაგრძელება" : "დაწყება"
    }
    
    private func login() async {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways, .denied, .restricted:
            await performLogin()
        case .notDetermined:
            isWaitingForLocationPermission = true
            locationManager.requestAuthorization()
        @unknown default:
            break
        }
    }
    
    private func performLogin() async {
        await authManager.login(email: userEmail, password: userPassword)
    }
    
    private func observeLocationPermission() {
        locationManager.$authorizationStatus
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] status in
                guard let self = self, self.isWaitingForLocationPermission else { return }
                
                switch status {
                case .authorizedWhenInUse, .authorizedAlways, .denied, .restricted:
                    self.isWaitingForLocationPermission = false
                    Task { @MainActor in
                        await self.performLogin()
                    }
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
