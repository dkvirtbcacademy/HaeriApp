//
//  LoginStepTwo.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class LoginStepTwo: UIView {
    
    var registerTapped: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ავტორიზაცია"
        label.font = .firagoBold(.xmedium)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "პერსონალიზირებული ინფორმაციისა და რჩევების მისაღებად, გთხოვთ გაიაროთ ავტორიზაცია"
        label.font = .firago(.xxsmall)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameField = NameField(
        label: "ელ. ფოსტის მისამართი:",
        placeholder: "შეიყვანეთ ელ. ფოსტის მისამართი"
    )
    
    private let passwordField = PasswordField(
        label: "პაროლი:",
        placeholder: "შეიყვანეთ პაროლი"
    )
    
    private let goToRegisterView = GoToRegisterView()
    
    private let uikitGoogleButton = UikitGoogleButton()
    
    private lazy var loginStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameField,
            passwordField,
            goToRegisterView,
//            uikitGoogleButton
        ])
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setTitleLabel()
        setDescriptionLabel()
        setUikitGoogleButton()
        setLoginStackView()
    }
    
    private func setupActions() {
        setupKeyboardDismissal()
        
        goToRegisterView.registerTapped = { [weak self] in
            self?.registerTapped?()
        }
    }
    
    private func setTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setDescriptionLabel() {
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setLoginStackView() {
        addSubview(loginStackView)
        
        NSLayoutConstraint.activate([
//            loginStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 45),
            loginStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20),
            loginStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loginStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setUikitGoogleButton() {
        NSLayoutConstraint.activate([
            uikitGoogleButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
