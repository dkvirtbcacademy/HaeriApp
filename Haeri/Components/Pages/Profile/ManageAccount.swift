//
//  ManageAccount.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit

class ManageAccount: UIView {
    
    var changeNameTapped: (() -> Void)?
    var changePasswordTapped: (() -> Void)?
    var changeAvatarTapped: (() -> Void)?
    var changeCategoryTapped: (() -> Void)?
    var removeAccountTapped: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "მართე ექაუნთი:"
        label.font = .firagoBold(.medium)
        label.textColor = UIColor(named: "DarkText")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let border: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "PlaceholderColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 2
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    private let changeNameButton: UIButton = {
        let button = UIButton()
        button.setTitle("შეცვალე სახელი", for: .normal)
        button.titleLabel?.font = .firago(.medium)
        button.setTitleColor(UIColor(named: "ButtonBlue"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("შეცვალე პაროლი", for: .normal)
        button.titleLabel?.font = .firago(.medium)
        button.setTitleColor(UIColor(named: "ButtonBlue"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let changeAvatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("შეცვალე ავატარი", for: .normal)
        button.titleLabel?.font = .firago(.medium)
        button.setTitleColor(UIColor(named: "ButtonBlue"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let changeCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("შეცვალე კატეგორია", for: .normal)
        button.titleLabel?.font = .firago(.medium)
        button.setTitleColor(UIColor(named: "ButtonBlue"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let RemoveAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("ექაუნთის გაუქმება", for: .normal)
        button.titleLabel?.font = .firago(.medium)
        button.setTitleColor(UIColor(named: "LogoutRed"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        applyMediumGlass()
        setupUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setTitle()
        setStackView()
    }
    
    private func setActions() {
        changeNameButton.addAction(
            UIAction { [weak self] _ in
                self?.changeNameTapped?()
            },
            for: .touchUpInside
        )
        
        changePasswordButton.addAction(
            UIAction { [weak self] _ in
                self?.changePasswordTapped?()
            },
            for: .touchUpInside
        )
        
        changeAvatarButton.addAction(
            UIAction { [weak self] _ in
                self?.changeAvatarTapped?()
            },
            for: .touchUpInside
        )
        
        changeCategoryButton.addAction(
            UIAction { [weak self] _ in
                self?.changeCategoryTapped?()
            },
            for: .touchUpInside
        )
        
        RemoveAccountButton.addAction(
            UIAction { [weak self] _ in
                self?.removeAccountTapped?()
            },
            for: .touchUpInside
        )
    }
    
    private func setTitle() {
        addSubview(titleLabel)
        addSubview(border)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            border.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            border.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            border.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setStackView() {
        addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(changeNameButton)
        buttonStackView.addArrangedSubview(changePasswordButton)
        buttonStackView.addArrangedSubview(changeAvatarButton)
        buttonStackView.addArrangedSubview(changeCategoryButton)
        buttonStackView.addArrangedSubview(RemoveAccountButton)
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 10),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
