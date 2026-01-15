//
//  Textfield+ext.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//
import UIKit

extension UITextField {
    @objc func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        
        if let containerView = rightView,
           let button = containerView.viewWithTag(999) as? UIButton {
            button.isSelected = !isSecureTextEntry
        }
    }
}
