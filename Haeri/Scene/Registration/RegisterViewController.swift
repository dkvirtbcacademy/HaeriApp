//
//  RegisterViewController.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class RegisterViewController: UIViewController {
    private let viewModel: RegisterViewModel
    
    private let header = UikitPageHeader(pageName: "რეგისტრაცია")
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAdaptiveBackground(value: 1)
        setupUI()
        setupActions()
    }

    private func setupUI() {
        setHeader()
    }
    
    private func setupActions() {
        header.onBackTapped = { [weak self] in
            self?.viewModel.navigateBack()
        }
    }

    private func setHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
