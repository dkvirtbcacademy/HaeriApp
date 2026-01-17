//
//  ActionCardView.swift
//  Haeri
//
//  Created by kv on 17.01.26.
//

import UIKit

class ActionCardView: UIView {
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .firagoBold(.xxsmall)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .firago(.small)
        label.numberOfLines = 0
        label.textColor = UIColor(named: "SecondaryDarkText")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "SecondaryDarkText")?.withAlphaComponent(0.6)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(icon: String, title: String, subtitle: String, isDestructive: Bool = false) {
        super.init(frame: .zero)
        
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = isDestructive ? UIColor(named: "LogoutRed") : UIColor(named: "ButtonBlue")
        
        titleLabel.text = title
        titleLabel.textColor = isDestructive ? UIColor(named: "LogoutRed") : UIColor(named: "DarkText")
        
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = UIColor(named: "SecondaryDarkText")
        
        chevronImageView.tintColor = UIColor(named: "SecondaryDarkText")?.withAlphaComponent(0.6)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(button)
        addSubview(iconImageView)
        addSubview(textStackView)
        addSubview(chevronImageView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            textStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            textStackView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12),
            
            heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        
        button.configurationUpdateHandler = { button in
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = .clear
            
            switch button.state {
            case .highlighted:
                button.alpha = 0.7
                button.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            default:
                button.alpha = 1.0
                button.transform = .identity
            }
            
            button.configuration = config
        }
    }
}
