//
//  ProfileViewController.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
     
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "გამარჯობა, \(viewModel.authManager.userName)"
        label.font = .firagoBold(.xmedium)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var iconFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 55
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var userIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: viewModel.authManager.userAvatar)
        imageView.tintColor = UIColor(named: "DarkText")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let button = UiKitLogoutButton()
    private let manageAccount = ManageAccount()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAdaptiveBackground(value: viewModel.airQualityValue)
        
        setupUI()
        setActions()
        observeUserChanges()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBackgroundFrame()
    }
    
    func updateAirQuality(_ value: Int) {
        viewModel.airQualityValue = value
        addAdaptiveBackground(value: value, animated: true)
    }
    
    private func observeUserChanges() {
        viewModel.authManager.$userName
            .sink { [weak self] newName in
                self?.titleLabel.text = "გამარჯობა, \(newName)"
            }
            .store(in: &cancellables)
        
        viewModel.authManager.$userAvatar
            .sink { [weak self] newAvatar in
                self?.userIcon.image = UIImage(named: newAvatar)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        setTitleLabel()
        setButton()
        setIconFrame()
        setManageAccount()
    }
    
    private func setActions() {
        manageAccount.changeNameTapped = { [weak self] in
            self?.viewModel.coordinator.navigate(to: .changeName)
        }
        
        manageAccount.changePasswordTapped = { [weak self] in
            self?.viewModel.coordinator.navigate(to: .changePassword)
        }
        
        manageAccount.changeAvatarTapped = { [weak self] in
            self?.viewModel.coordinator.navigate(to: .changeAvatar)
        }
        
        manageAccount.changeCategoryTapped = { [weak self] in
            self?.viewModel.coordinator.navigate(to: .changeCategory)
        }
        
        manageAccount.removeAccountTapped = { [weak self] in
            self?.viewModel.coordinator.navigate(to: .removeAccount)
        }
    }
    
    private func setTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setButton() {
        button.addAction(UIAction { [weak self] _ in
            self?.viewModel.authManager.logout()
        }, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setIconFrame() {
        view.addSubview(iconFrame)
        iconFrame.addSubview(userIcon)
        
        NSLayoutConstraint.activate([
            iconFrame.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconFrame.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            iconFrame.widthAnchor.constraint(equalToConstant: 110),
            iconFrame.heightAnchor.constraint(equalToConstant: 110),
            
            userIcon.centerXAnchor.constraint(equalTo: iconFrame.centerXAnchor),
            userIcon.centerYAnchor.constraint(equalTo: iconFrame.centerYAnchor),
            userIcon.widthAnchor.constraint(equalToConstant: 60),
            userIcon.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setManageAccount() {
        view.addSubview(manageAccount)
        manageAccount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            manageAccount.topAnchor.constraint(equalTo: iconFrame.bottomAnchor, constant: 60),
            manageAccount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            manageAccount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            manageAccount.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -60)
        ])
    }
}
