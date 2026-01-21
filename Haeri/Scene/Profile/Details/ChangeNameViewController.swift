//
//  ChangeNameViewController.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit
import SwiftUI
import Combine

class ChangeNameViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let header = UikitPageHeader(pageName: "სახელის შეცვლა")
    
    private let nameField = NameField(
        label: "ახალი სახელი",
        placeholder: "შეიყვანეთ ახალი სახელი"
    )
    
    private let saveButton = UikitButton(label: "შენახვა")
    
    private lazy var loadingHostingController: UIHostingController<ExpandingRings> = {
        let loadingView = ExpandingRings()
        let hostingController = UIHostingController(rootView: loadingView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        hostingController.view.isHidden = true
        return hostingController
    }()
    
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
        observeLoadingState()
    }
    
    private func setupUI() {
        header.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(header)
        view.addSubview(nameField)
        view.addSubview(saveButton)
        
        addChild(loadingHostingController)
        view.addSubview(loadingHostingController.view)
        loadingHostingController.didMove(toParent: self)
        
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
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            loadingHostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingHostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingHostingController.view.widthAnchor.constraint(equalToConstant: 60),
            loadingHostingController.view.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func setActions() {
        setupKeyboardHandling()
        
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
    
    private func observeLoadingState() {
        viewModel.authManager.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                
                if isLoading {
                    loadingHostingController.view.isHidden = false
                    self.saveButton.isEnabled = false
                    self.saveButton.alpha = 0.5
                    self.nameField.isUserInteractionEnabled = false
                } else {
                    loadingHostingController.view.isHidden = true
                    self.saveButton.isEnabled = true
                    self.saveButton.alpha = 1.0
                    self.nameField.isUserInteractionEnabled = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func saveName() {
        guard let name = nameField.getInputText(), !name.isEmpty else {
            nameField.setError("გთხოვთ შეიყვანოთ სახელი")
            return
        }
        
        if name.count < 2 {
            nameField.setError("სახელი უნდა შედგებოდეს მინიმუმ 2 სიმბოლოსგან")
            return
        }
        
        nameField.clearError()
        
        Task { @MainActor in
            await viewModel.authManager.updateUserName(name)
            
            if viewModel.authManager.alertItem == nil {
                viewModel.coordinator.navigateBack()
            }
        }
    }
}
