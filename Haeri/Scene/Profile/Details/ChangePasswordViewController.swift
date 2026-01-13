//
//  ChangePasswordViewController.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    
    private let header = UikitPageHeader(pageName: "პაროლის შეცვლა")
    
    private let currentPasswordField = PasswordField(
        label: "მიმდინარე პაროლი",
        placeholder: "შეიყვანეთ მიმდინარე პაროლი"
    )
    
    private let newPasswordField = PasswordField(
        label: "ახალი პაროლი",
        placeholder: "შეიყვანეთ ახალი პაროლი"
    )
    
    private let saveButton = UikitButton(label: "შენახვა")
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        addAdaptiveBackground(value: viewModel.airQualityValue)
        
        setupUI()
        setActions()
    }
    
    private func setupUI() {
        header.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(header)
        view.addSubview(currentPasswordField)
        view.addSubview(newPasswordField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60),
            
            currentPasswordField.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 40),
            currentPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            currentPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            newPasswordField.topAnchor.constraint(equalTo: currentPasswordField.bottomAnchor, constant: 20),
            newPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            newPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setActions() {
        setupKeyboardHandling()
        
        header.onBackTapped = { [weak self] in
            self?.viewModel.coordinator.navigateBack()
        }
        
        saveButton.addAction(
            UIAction { [weak self] _ in
                self?.savePassword()
            },
            for: .touchUpInside
        )
    }
    
    private func savePassword() {
        guard let currentPassword = currentPasswordField.getInputText() else {
            currentPasswordField.showError("გთხოვთ შეიყვანოთ მიმდინარე პაროლი")
            return
        }
        
        guard let newPassword = newPasswordField.getInputText() else {
            newPasswordField.showError("გთხოვთ შეიყვანოთ ახალი პაროლი")
            return
        }
        
        if currentPassword != viewModel.authManager.userPassword {
            currentPasswordField.showError("არასწორი პაროლი")
            return
        }
        
        if newPassword.count < 8 {
            newPasswordField.showError("პაროლი უნდა შედგებოდეს მინიმუმ 8 სიმბოლოსგან")
            return
        }
        
        currentPasswordField.clearError()
        newPasswordField.clearError()
        
        viewModel.authManager.changeUserPassword(newPassword)
        viewModel.coordinator.navigateBack()
    }
}
