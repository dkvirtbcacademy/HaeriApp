//
//  AddCityViewController.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import UIKit
import SwiftUI
import Combine

protocol AddCityViewControllerDelegate: AnyObject {
    func didSelectCity(_ city: GeoResponse)
}

class AddCityViewController: UIViewController {
    
    weak var delegate: AddCityViewControllerDelegate?
    
    private let viewModel: DashboardViewModel
    private var cancellables = Set<AnyCancellable>()
    private let characterLimit = 40
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ჩაწერეთ ქალაქის სახელი"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.placeholder.cgColor
        textField.font = .firago(.medium)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.rightViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.addAction(UIAction { [weak self] _ in
            self?.viewModel.searchText = textField.text ?? ""
        }, for: .editingChanged)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(CitySearchCell.self, forCellReuseIdentifier: CitySearchCell.identifier)
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.isHidden = true
        return table
    }()
    
    private lazy var loadingHostingController: UIHostingController<ExpandingRings> = {
        let loadingView = ExpandingRings()
        let hostingController = UIHostingController(rootView: loadingView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.isHidden = true
        return hostingController
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "ქალაქები ვერ მოიძებნა"
        label.font = .firagoMedium(.medium)
        label.textColor = .secondaryDarkText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
        searchTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.clearSearch()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        addChild(loadingHostingController)
        view.addSubview(loadingHostingController.view)
        loadingHostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingHostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingHostingController.view.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 40),
            loadingHostingController.view.widthAnchor.constraint(equalToConstant: 40),
            loadingHostingController.view.heightAnchor.constraint(equalToConstant: 40),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 40)
        ])
    }
    
    private func setupNavigationBar() {
        title = "დაამატე ქალაქი"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    private func bindViewModel() {
        viewModel.$searchResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.tableView.reloadData()
                self?.updateUIState()
            }
            .store(in: &cancellables)
        
        viewModel.$isSearchLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loadingHostingController.view.isHidden = !isLoading
            }
            .store(in: &cancellables)
        
        viewModel.$showEmptyState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showEmpty in
                self?.emptyStateLabel.isHidden = !showEmpty
            }
            .store(in: &cancellables)
    }
    
    private func updateUIState() {
        let hasResults = !viewModel.searchResults.isEmpty
        tableView.isHidden = !hasResults || viewModel.isSearchLoading
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

extension AddCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CitySearchCell.identifier,
            for: indexPath
        ) as? CitySearchCell else {
            return UITableViewCell()
        }
        
        let city = viewModel.searchResults[indexPath.row]
        cell.configure(with: city)
        return cell
    }
}

extension AddCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCity = viewModel.searchResults[indexPath.row]
        delegate?.didSelectCity(selectedCity)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension AddCityViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= characterLimit
    }
}
