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
    private let coordinator: LoginCoordinator
    let authManager: AuthManager
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var currentStep: Int = 1
    @Published private(set) var buttonTitle: String = "გაგრძელება"
    
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    @Published var userCategory: [String] = []
    
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
            await createAccount()
        }
    }
    
    private func updateButtonTitle() {
        buttonTitle = currentStep == 2 ? "დასრულება" : "გაგრძელება"
    }
    
    private func createAccount() async {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways, .denied:
            await authManager.createUser(
                name: userName,
                email: userEmail,
                password: userPassword,
                avatar: "Avatar 1",
                categories: userCategory
            )
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
                guard let self else { return }
                
                switch status {
                case .authorizedWhenInUse, .authorizedAlways, .denied, .restricted:
                    Task { @MainActor in
                        await self.authManager.createUser(
                            name: self.userName,
                            email: self.userEmail,
                            password: self.userPassword,
                            avatar: "Avatar 1",
                            categories: self.userCategory
                        )
                    }
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func navigateBack() {
        coordinator.navigateBack()
    }
}
