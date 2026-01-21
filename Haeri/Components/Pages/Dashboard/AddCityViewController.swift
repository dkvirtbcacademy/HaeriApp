//
//  AddCityViewController.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import UIKit
import Combine

protocol AddCityViewControllerDelegate: AnyObject {
    func didSelectCity(_ city: GeoResponse)
}

class AddCityViewController: UIViewController {
    
    weak var delegate: AddCityViewControllerDelegate?
    private let viewModel: DashboardViewModel
    private var cancellables = Set<AnyCancellable>()
    private var searchResults: [GeoResponse] = []
    private let characterLimit = 40
    
    private let searchTextField: UITextField = {
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
        
        return textField
    }()
    
    private lazy var findButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ძებნა", for: .normal)
        button.titleLabel?.font = .firagoMedium(.medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.text, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in
            self?.findButtonTapped()
        }, for: .touchUpInside)
        return button
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
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
        
        searchTextField.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchTextField)
        view.addSubview(findButton)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            findButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            findButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findButton.widthAnchor.constraint(equalToConstant: 120),
            findButton.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: findButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: findButton.bottomAnchor, constant: 40),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.topAnchor.constraint(equalTo: findButton.bottomAnchor, constant: 40)
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
    
    private func findButtonTapped() {
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            return
        }
        
        searchTextField.resignFirstResponder()
        activityIndicator.startAnimating()
        tableView.isHidden = true
        emptyStateLabel.isHidden = true
        
        Task {
            await viewModel.findCity(name: searchText)
            
            await MainActor.run {
                activityIndicator.stopAnimating()
                searchResults = viewModel.getSearchResults()
                
                if searchResults.isEmpty {
                    emptyStateLabel.isHidden = false
                } else {
                    tableView.isHidden = false
                    tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

extension AddCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CitySearchCell.identifier,
            for: indexPath
        ) as? CitySearchCell else {
            return UITableViewCell()
        }
        
        let city = searchResults[indexPath.row]
        cell.configure(with: city)
        
        return cell
    }
}

extension AddCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCity = searchResults[indexPath.row]
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
