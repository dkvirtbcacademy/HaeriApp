//
//  ProfileViewController.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 60
        view.clipsToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: viewModel.authManager.currentUser?.avatar ?? "Avatar 1")
        imageView.tintColor = UIColor(named: "DarkText")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "გამარჯობა,"
        label.font = .firagoBold(.medium)
        label.textColor = UIColor(named: "TextColor")?.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.authManager.currentUser?.name ?? "User"
        label.font = .firagoBold(.xlarge)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let manageAccount = ManageAccount()
    private let button = UiKitLogoutButton()
    
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
        viewModel.authManager.$currentUser
            .sink { [weak self] user in
                guard let self = self else { return }
                self.nameLabel.text = user?.name ?? "User"
                self.userIcon.image = UIImage(named: user?.avatar ?? "Avatar 1")
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        setupScrollView()
        setupHeader()
        setupManageAccount()
        setupLogoutButton()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 60),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -70),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupHeader() {
        contentView.addSubview(headerContainer)
        headerContainer.addSubview(iconFrame)
        iconFrame.addSubview(userIcon)
        headerContainer.addSubview(titleLabel)
        headerContainer.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            iconFrame.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            iconFrame.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            iconFrame.widthAnchor.constraint(equalToConstant: 120),
            iconFrame.heightAnchor.constraint(equalToConstant: 120),
            
            userIcon.centerXAnchor.constraint(equalTo: iconFrame.centerXAnchor),
            userIcon.centerYAnchor.constraint(equalTo: iconFrame.centerYAnchor),
            userIcon.widthAnchor.constraint(equalToConstant: 70),
            userIcon.heightAnchor.constraint(equalToConstant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: iconFrame.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -24),
            
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -24),
            nameLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        ])
    }
    
    private func setupManageAccount() {
        contentView.addSubview(manageAccount)
        manageAccount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            manageAccount.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 32),
            manageAccount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            manageAccount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupLogoutButton() {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction { [weak self] _ in
            self?.viewModel.authManager.logout()
        }, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: manageAccount.bottomAnchor, constant: 32),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            button.heightAnchor.constraint(equalToConstant: 54),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
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
}
