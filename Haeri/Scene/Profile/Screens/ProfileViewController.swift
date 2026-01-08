//
//  ProfileViewController.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let coordinator: ProfileCoordinator
    private let authManager: AuthManager
    private var airQualityValue: Int = 25
    
    init(coordinator: ProfileCoordinator, authManager: AuthManager) {
        self.coordinator = coordinator
        self.authManager = authManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAdaptiveBackground(value: airQualityValue)
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBackgroundFrame()
    }
    
    func updateAirQuality(_ value: Int) {
        airQualityValue = value
        addAdaptiveBackground(value: value, animated: true)
    }
    
    private func setupUI() {
        setButton()
    }
    
    private func setButton() {
        let registerButton = UIButton(type: .system)
        registerButton.setTitle("Logout", for: .normal)
        registerButton.addAction(UIAction { [weak self] _ in
            self?.authManager.logout()
        }, for: .touchUpInside)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
