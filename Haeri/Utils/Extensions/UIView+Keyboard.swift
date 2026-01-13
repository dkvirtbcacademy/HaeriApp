//
//  UIView+Keyboard.swift
//  Haeri
//
//  Created by kv on 11.01.26.
//

import UIKit

extension UIView {
    
    func setupKeyboardDismissal(excludingTextFields: Bool = true) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDismissal))
        tapGesture.cancelsTouchesInView = false
        
        if excludingTextFields {
            tapGesture.delegate = KeyboardDismissalGestureDelegate.shared
        }
        
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleKeyboardDismissal() {
        endEditing(true)
    }
}

private class KeyboardDismissalGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    static let shared = KeyboardDismissalGestureDelegate()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UITextField)
    }
}
