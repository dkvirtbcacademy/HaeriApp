//
//  UIViewController+Keyboard.swift
//  Haeri
//
//  Created by kv on 11.01.26.
//

import UIKit

extension UIViewController {
    
    func setupKeyboardHandling(dismissOnTap: Bool = true) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        if dismissOnTap {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        guard let activeField = findFirstResponder(in: view) else {
            return
        }
        
        let fieldFrame = activeField.convert(activeField.bounds, to: view.window)
        
        let visibleHeight = view.frame.height - keyboardFrame.height
        
        let fieldBottom = fieldFrame.maxY
        let overlap = fieldBottom - visibleHeight
        
        if overlap > 0 {
            UIView.animate(withDuration: duration) {
                self.view.frame.origin.y = -(overlap + 20)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func findFirstResponder(in view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        
        for subview in view.subviews {
            if let firstResponder = findFirstResponder(in: subview) {
                return firstResponder
            }
        }
        
        return nil
    }
}
