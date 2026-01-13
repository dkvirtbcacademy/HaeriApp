//
//  UikitPageHeader.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class UikitPageHeader: UIView {
    
    var onBackTapped: (() -> Void)?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(backButton)
        addSubview(titleLabel)
        backButton.addSubview(iconView)
        
        backButton.addAction(UIAction { [weak self] _ in
            self?.onBackTapped?()
        }, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            iconView.centerXAnchor.constraint(equalTo: backButton.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -60)
        ])
    }

}
