//
//  ChangeNameViewController.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit

class ChangeNameViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    
    private let header = UikitPageHeader(pageName: "სახელის შეცვლა")
    
    private let nameField = NameField(
        label: "ახალი სახელი",
        placeholder: "შეიყვანეთ ახალი სახელი"
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
        view.addSubview(nameField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60),
            
            nameField.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 40),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setActions() {
        header.onBackTapped = { [weak self] in
            self?.viewModel.coordinator.navigateBack()
        }
        
        saveButton.addAction(
            UIAction { [weak self] _ in
                self?.saveName()
            },
            for: .touchUpInside
        )
    }
    
    private func saveName() {
        guard let name = nameField.getInputText() else {
            nameField.showError("გთხოვთ შეიყვანოთ სახელი")
            return
        }
        
        nameField.clearError()
        viewModel.authManager.changeUserName(name)
        viewModel.coordinator.navigateBack()
    }
}
