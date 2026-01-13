//
//  RegistrationStepOne.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class RegistrationStepOne: UIView {
    
    private let nameField = NameField(
        label: "სახელი:",
        placeholder: "შეიყვანეთ სახელი"
    )
    
    private let mailField = NameField(
        label: "ელ. ფოსტის მისამართი:",
        placeholder: "შეიყვანეთ ელ. ფოსტის მისამართი"
    )
    
    private let passwordField = PasswordField(
        label: "პაროლი:",
        placeholder: "********"
    )
    
    private let confirmPasswordField = PasswordField(
        label: "გაიმეორეთ პაროლი:",
        placeholder: "********"
    )
    
    private lazy var stackview: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameField,
            mailField,
            passwordField,
            confirmPasswordField,
            UIView()
        ])
        
        stack.axis = .vertical
//        stack.alignment = .center
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
        addSubview(stackview)
        
        NSLayoutConstraint.activate([
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupActions() {
        setupKeyboardDismissal()
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
}
