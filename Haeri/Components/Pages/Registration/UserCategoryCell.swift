//
//  UserCategoryCell.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit

class UserCategoryCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "DarkText")
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .firago(.xxsmall)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.applyLightGlass()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with text: String, iconName: String, isSelected: Bool) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.firago(.xxsmall),
                .foregroundColor: UIColor(named: "DarkText") ?? .black
            ]
        )
        
        categoryLabel.attributedText = attributedString
        iconImageView.image = UIImage(named: iconName)
        
        if isSelected {
            containerView.backgroundColor = UIColor(named: "SelectedCell")?.withAlphaComponent(0.3)
            containerView.layer.borderColor = UIColor(named: "SelectedCell")?.cgColor
            containerView.layer.borderWidth = 2
            categoryLabel.textColor = UIColor(named: "DarkText")
        } else {
            containerView.backgroundColor = .clear
            containerView.layer.borderWidth = 0.5
            containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            categoryLabel.textColor = UIColor(named: "TextColor")
        }
    }
    
}
