//
//  ChangeAvatarViewController.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit
import Combine

class ChangeAvatarViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let header = UikitPageHeader(pageName: "ავატარის შეცვლა")
    private var selectedAvatar: String?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AvatarCell.self, forCellWithReuseIdentifier: "AvatarCell")
        return collectionView
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
        self.selectedAvatar = viewModel.authManager.currentUser?.avatar
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
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        view.addSubview(activityIndicator)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            
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
                self?.saveAvatar()
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
                    self.collectionView.isUserInteractionEnabled = false
                } else {
                    self.activityIndicator.stopAnimating()
                    self.saveButton.isEnabled = true
                    self.saveButton.alpha = 1.0
                    self.collectionView.isUserInteractionEnabled = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func saveAvatar() {
        guard let avatar = selectedAvatar else { return }
        
        Task { @MainActor in
            await viewModel.authManager.updateUserAvatar(avatar)
            
            if viewModel.authManager.alertItem == nil {
                viewModel.coordinator.navigateBack()
            }
        }
    }
}

extension ChangeAvatarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.authManager.avatarOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
        let avatar = viewModel.authManager.avatarOptions[indexPath.item]
        cell.configure(with: avatar, isSelected: avatar == selectedAvatar)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAvatar = viewModel.authManager.avatarOptions[indexPath.item]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 48 - 20) / 3
        return CGSize(width: width, height: width)
    }
}
