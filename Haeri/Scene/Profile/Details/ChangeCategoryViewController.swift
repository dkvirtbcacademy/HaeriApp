//
//  ChangeCategoryViewController.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit
import Combine

class ChangeCategoryViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let header = UikitPageHeader(pageName: "კატეგორიის შეცვლა")
    
    private var selectedIndices: Set<Int> = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "აირჩიე მინიმუმ ერთი კატეგორია:"
        label.font = .firagoMedium(.medium)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsMultipleSelection = true
        table.separatorStyle = .none
        table.backgroundColor = .clear
        return table
    }()
    
    private let saveButton = UikitButton(label: "შენახვა")
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        if let userCategories = viewModel.authManager.currentUser?.categories {
            for (index, category) in viewModel.authManager.userCategories.enumerated() {
                if userCategories.contains(category.slug) {
                    selectedIndices.insert(index)
                }
            }
        }
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
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(saveButton)
        view.addSubview(activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCategoryCell.self, forCellReuseIdentifier: "UserCategoryCell")
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setActions() {
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
                guard let self = self else { return }
                
                if isLoading {
                    self.activityIndicator.startAnimating()
                    self.saveButton.isEnabled = false
                    self.saveButton.alpha = 0.5
                    self.tableView.isUserInteractionEnabled = false
                } else {
                    self.activityIndicator.stopAnimating()
                    self.saveButton.isEnabled = true
                    self.saveButton.alpha = 1.0
                    self.tableView.isUserInteractionEnabled = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func saveCategories() {
        guard !selectedIndices.isEmpty else {
            showError("გთხოვთ აირჩიოთ მინიმუმ ერთი კატეგორია")
            return
        }
        
        let selectedCategorySlugs = selectedIndices.sorted().map {
            viewModel.authManager.userCategories[$0].slug
        }
        
        Task { @MainActor in
            await viewModel.authManager.updateUserCategories(selectedCategorySlugs)
            
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

extension ChangeCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.authManager.userCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCategoryCell", for: indexPath) as! UserCategoryCell
        let category = viewModel.authManager.userCategories[indexPath.row]
        let isSelected = selectedIndices.contains(indexPath.row)
        cell.configure(with: category.label, iconName: category.iconName, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if selectedIndices.contains(indexPath.row) {
            selectedIndices.remove(indexPath.row)
        } else {
            selectedIndices.insert(indexPath.row)
        }
        
        UIView.animate(withDuration: 0.3) {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
