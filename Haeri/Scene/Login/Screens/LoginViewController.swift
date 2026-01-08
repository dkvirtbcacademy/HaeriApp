//
//  LoginViewController.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import UIKit
import Combine
import CoreLocation

class LoginViewController: UIViewController {
    private let coordinator: LoginCoordinator
    private let authManager: AuthManager
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: LoginCoordinator, authManager: AuthManager, locationManager: LocationManager) {
        self.coordinator = coordinator
        self.authManager = authManager
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAdaptiveBackground(value: 1)
        
        setupUI()
        observeAuthorizationStatus()
    }
    
    private func setupUI() {
        setButton()
    }
    
    private func setButton() {
        let registerButton = UIButton(type: .system)
        registerButton.setTitle("Create Account", for: .normal)
        registerButton.addAction(UIAction { [weak self] _ in
            self?.createAccount()
        }, for: .touchUpInside)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)
        
        
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
}
