//
//  UikitGoogleButton.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class UikitGoogleButton: UIButton {
    
    var googleButtonTapped: (() -> Void)?
    
    private let iconView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "google icon")
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .firagoMedium(.xmedium)
        label.textColor = UIColor(named: "Background Light")
        label.text = "სცადე Google-ით"
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        stack.isUserInteractionEnabled = false
        return stack
    }()

    init() {
        super.init(frame: .zero)
        
        layer.cornerRadius = 16
        backgroundColor = UIColor(named: "TextColor")
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
        
        setupStackView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(label: String) {
        self.label.text = label
    }
    
    private func setupActions() {
        addAction(
            UIAction { [weak self] _ in
                self?.googleButtonTapped?()
            },
            for: .touchUpInside
        )
    }
}
