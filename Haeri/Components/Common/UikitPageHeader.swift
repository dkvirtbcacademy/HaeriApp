//
//  UikitPageHeader.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class UikitPageHeader: UIView {
    
    var onBackTapped: (() -> Void)?
    
    private let backButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    private let iconView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "arrow.left")
        icon.tintColor = UIColor(named: "TextColor")
        icon.isUserInteractionEnabled = false
        return icon
    }()
    
    private let titleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .firagoBold(.medium)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(pageName: String) {
        super.init(frame: .zero)
        
        titleLabel.text = pageName
        setupViews()
        applyGlassmorphism()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(backButtonContainer)
        addSubview(titleContainer)
        
        backButtonContainer.addSubview(backButton)
        backButton.addSubview(iconView)
        
        titleContainer.addSubview(titleLabel)
        
        backButton.addAction(UIAction { [weak self] _ in
            self?.onBackTapped?()
        }, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButtonContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButtonContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButtonContainer.widthAnchor.constraint(equalToConstant: 44),
            backButtonContainer.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.topAnchor.constraint(equalTo: backButtonContainer.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: backButtonContainer.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: backButtonContainer.trailingAnchor),
            backButton.bottomAnchor.constraint(equalTo: backButtonContainer.bottomAnchor),
            
            iconView.centerXAnchor.constraint(equalTo: backButton.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleContainer.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -8)
        ])
    }
    
    private func applyGlassmorphism() {
        backButtonContainer.applyLightGlass(cornerRadius: 22)
        
        titleContainer.applyLightGlass(cornerRadius: 20)
    }
}
