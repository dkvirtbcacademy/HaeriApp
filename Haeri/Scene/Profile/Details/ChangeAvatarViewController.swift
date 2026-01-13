//
//  ChangeAvatarViewController.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit

class ChangeAvatarViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    
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
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self.selectedAvatar = viewModel.authManager.userAvatar
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
    }
    
    private func setupUI() {
        header.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(header)
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        
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
            saveButton.heightAnchor.constraint(equalToConstant: 50)
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
    
    private func saveAvatar() {
        guard let avatar = selectedAvatar else { return }
        viewModel.authManager.changeUserAvatar(avatar)
        viewModel.coordinator.navigateBack()
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
