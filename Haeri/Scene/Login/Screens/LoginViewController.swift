//
//  LoginViewController.swift
//  Haeri
//
//  Created by kv on 05.01.26.
//

import UIKit

class LoginViewController: UIViewController {
    private let coordinator: LoginCoordinator
    private let authManager: AuthManager
    
    init(coordinator: LoginCoordinator, authManager: AuthManager) {
        self.coordinator = coordinator
        self.authManager = authManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAdaptiveBackground(value: 1)
        
        setupUI()
    }
    
    private func setupUI() {
        setButton()
    }
    
    private func setButton() {
        let registerButton = UIButton(type: .system)
        registerButton.setTitle("Create Account", for: .normal)
        registerButton.addAction(UIAction { [weak self] _ in
            self?.authManager.login()
        }, for: .touchUpInside)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)
        
        
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
