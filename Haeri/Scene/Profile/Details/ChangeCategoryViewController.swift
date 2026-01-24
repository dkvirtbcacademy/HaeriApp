//
//  ChangeCategoryViewController.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit
import SwiftUI
import Combine

final class ChangeCategoryViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let header = UikitPageHeader(pageName: "კატეგორიის შეცვლა")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "აირჩიე მინიმუმ ერთი კატეგორია:"
        label.font = .firagoMedium(.medium)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var categoryGameView: CategoryGameView = {
        let preselectedSlugs = viewModel.authManager.currentUser?.categories ?? []
        let gameView = CategoryGameView(
            userCategories: viewModel.authManager.userCategories,
            preselectedSlugs: preselectedSlugs
        )
        gameView.translatesAutoresizingMaskIntoConstraints = false
        return gameView
    }()
    
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
        setupActions()
        observeLoadingState()
    }
    
    private func setupUI() {
        setupHeader()
        setupTitleLabel()
        setupSaveButton()
        setupCategoryGameView()
        setupLoadingView()
    }
    
    private func setupHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupCategoryGameView() {
        view.addSubview(categoryGameView)
        
        NSLayoutConstraint.activate([
            categoryGameView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoryGameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            categoryGameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            categoryGameView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20)
        ])
    }
    
    private func setupSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupLoadingView() {
        addChild(loadingHostingController)
        view.addSubview(loadingHostingController.view)
        loadingHostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            loadingHostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingHostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingHostingController.view.widthAnchor.constraint(equalToConstant: 60),
            loadingHostingController.view.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActions() {
        header.onBackTapped = { [weak self] in
            self?.viewModel.coordinator.navigateBack()
        }
        
        saveButton.addAction(
            UIAction { [weak self] _ in
                self?.saveCategories()
            },
            for: .touchUpInside
        )
    }
    
    private func observeLoadingState() {
        viewModel.authManager.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading)
            }
            .store(in: &cancellables)
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        loadingHostingController.view.isHidden = !isLoading
        saveButton.isEnabled = !isLoading
        saveButton.alpha = isLoading ? 0.5 : 1.0
        categoryGameView.isUserInteractionEnabled = !isLoading
    }
    
    private func saveCategories() {
        let selectedCategorySlugs = categoryGameView.getSelectedCategorySlugs()
        
        guard !selectedCategorySlugs.isEmpty else {
            showError("გთხოვთ აირჩიოთ მინიმუმ ერთი კატეგორია")
            return
        }
        
        Task { @MainActor in
            _ = await viewModel.authManager.updateUserCategories(selectedCategorySlugs)
            
            if viewModel.authManager.alertItem == nil {
                viewModel.coordinator.navigateBack()
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "შეცდომა", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "კარგი", style: .default))
        present(alert, animated: true)
    }
}
