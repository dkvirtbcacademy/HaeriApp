//
//  RegisterViewModel.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class RegisterViewModel: ObservableObject {
    let coordinator: LoginCoordinator
    let authManager: AuthManager
    
    @Published private(set) var currentStep: Int = 1
    @Published private(set) var buttonTitle: String = "გაგრძელება"
    
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    @Published var userCategory: [String] = []
    
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
    
    func getUserCategories() -> [UserCategoryModel] {
        authManager.userCategories
    }
    
    func moveToNextStep() {
        if currentStep < maxSteps {
            currentStep += 1
            updateButtonTitle()
        }
    }
    
    func handleButtonTap() async {
        if currentStep == maxSteps {
            await register()
        }
    }
    
    func navigateBack() {
        authManager.authError = nil
        coordinator.navigateBack()
    }
    
    
    private func updateButtonTitle() {
        buttonTitle = currentStep == 2 ? "დასრულება" : "გაგრძელება"
    }
    
    private func register() async {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways, .denied, .restricted:
            await createAccount()
        case .notDetermined:
            isWaitingForLocationPermission = true
            locationManager.requestAuthorization()
        @unknown default:
            break
        }
    }
    
    private func createAccount() async {
        await authManager.createUser(
            name: userName,
            email: userEmail,
            password: userPassword,
            avatar: "Avatar 1",
            categories: userCategory
        )
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
                        await self.createAccount()
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
