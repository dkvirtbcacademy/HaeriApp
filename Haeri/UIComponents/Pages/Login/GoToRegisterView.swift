//
//  GoToRegisterView.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class GoToRegisterView: UIStackView {

    var registerTapped: (() -> Void)?
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "შექმენი ექაუნთი"
        label.font = .firago(.xsmall)
        label.textColor = UIColor(named: "TextColor")
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("რეგისტრაცია", for: .normal)
        button.setTitleColor(UIColor(named: "TextColor"), for: .normal)
        button.titleLabel?.font = .firagoBold(.xsmall)
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        spacing = 4
        alignment = .center
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setupNavigationPrompt()
        setupActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNavigationPrompt() {
        addArrangedSubview(label)
        addArrangedSubview(UIView())
        addArrangedSubview(signUpButton)
    }
    
    private func setupActions() {
        signUpButton.addAction(
            UIAction { [weak self] _ in
                self?.registerTapped?()
            },
            for: .touchUpInside
        )
    }

}
