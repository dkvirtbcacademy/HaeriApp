//
//  RemoveAccountViewController.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit
import Combine

class RemoveAccountViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    
    private let header = UikitPageHeader(pageName: "ექაუნთის გაუქმება")
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "ნამდვილად გსურთ ექაუნთის გაუქმება? ეს მოქმედება შეუქცევადია და ყველა თქვენი მონაცემი წაიშლება."
        label.font = .firago(.medium)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("ექაუნთის წაშლა", for: .normal)
        button.titleLabel?.font = .firagoMedium(.xmedium)
        button.setTitleColor(UIColor(named: "TextColor"), for: .normal)
        button.backgroundColor = UIColor(named: "LogoutRed")
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        view.addSubview(header)
        view.addSubview(warningLabel)
        view.addSubview(deleteButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60),
            
            warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setActions() {
        header.onBackTapped = { [weak self] in
            self?.viewModel.coordinator.navigateBack()
        }
        
        deleteButton.addAction(
            UIAction { [weak self] _ in
                self?.showDeleteConfirmation()
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
                    self.activityIndicator.startAnimating()
                    self.deleteButton.isEnabled = false
                    self.deleteButton.alpha = 0.5
                } else {
                    self.activityIndicator.stopAnimating()
                    self.deleteButton.isEnabled = true
                    self.deleteButton.alpha = 1.0
                }
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func showDeleteConfirmation() {
        let alert = UIAlertController(
            title: "ბოლო გაფრთხილება",
            message: "დარწმუნებული ხართ რომ გსურთ ექაუნთის წაშლა?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "გაუქმება", style: .cancel))
        alert.addAction(UIAlertAction(title: "წაშლა", style: .destructive) { [weak self] _ in
            self?.deleteAccount()
        })
        
        present(alert, animated: true)
    }
    
    private func deleteAccount() {
        Task { @MainActor in
            await viewModel.authManager.deleteAccount()
        }
    }
}
