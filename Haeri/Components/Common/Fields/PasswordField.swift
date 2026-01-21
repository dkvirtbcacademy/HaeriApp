//
//  PasswordField.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class PasswordField: UIStackView {
    var onTextChanged: ((String) -> Void)?
    var characterLimit: Int = 20
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.font = .firago(.xsmall)
        label.textColor = UIColor(named: "TextColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textfield = UITextField()
        textfield.font = .firago(.xsmall)
        textfield.textColor = UIColor(named: "TextColor")
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.isSecureTextEntry = true
        textfield.isUserInteractionEnabled = true
        textfield.textContentType = .oneTimeCode
        
        textfield.layer.cornerRadius = 8
        textfield.layer.masksToBounds = true
        textfield.layer.borderWidth = 2
        textfield.layer.borderColor = UIColor(named: "TextColor")?.cgColor
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 52))
        let imageView = UIImageView(frame: CGRect(x: 12, y: 16, width: 20, height: 20))
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.tintColor = UIColor(named: "TextColor")
        imageView.contentMode = .scaleAspectFit
        leftView.addSubview(imageView)
        
        textfield.leftView = leftView
        textfield.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 52))
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        button.tintColor = UIColor(named: "TextColor")
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 52)
        button.tag = 999
        button.addTarget(textfield, action: #selector(UITextField.togglePasswordVisibility), for: .touchUpInside)
        rightView.addSubview(button)
        
        textfield.rightView = rightView
        textfield.rightViewMode = .always
        
        return textfield
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .firago(.xsmall)
        label.textColor = UIColor(named: "ErrorColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.isHidden = true
        label.alpha = 0.0
        return label
    }()
    
    init(label: String, placeholder: String) {
        
        fieldLabel.text = label
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor(named: "TextColor") ?? UIColor.white,
                .font: UIFont.firago(.xsmall)
            ]
        )
        
        super.init(frame: .zero)
        
        axis = .vertical
        spacing = 8
        distribution = .fill
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setUI()
        setConstraints()
        setupTextFieldDelegate()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addArrangedSubview(fieldLabel)
        addArrangedSubview(textField)
        addArrangedSubview(errorLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupTextFieldDelegate() {
        textField.delegate = self
        textField.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.onTextChanged?(self.textField.text ?? "")
        }, for: .editingChanged)
    }
    
    func setError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.errorLabel.alpha = 1.0
            self.textField.layer.borderColor = UIColor(named: "ErrorColor")?.cgColor
        }
    }
    
    func clearError() {
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.alpha = 0.0
            self.textField.layer.borderColor = UIColor(named: "TextColor")?.cgColor
        }) { _ in
            self.errorLabel.text = nil
            self.errorLabel.isHidden = true
        }
    }
    
    func getInputText() -> String? {
        return textField.text
    }
}

extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= characterLimit
    }
}
