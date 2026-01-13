//
//  UIView+Glassmorphism.swift
//  Haeri
//
//  Created by kv on 12.01.26.
//

import UIKit

extension UIView {
    func applyGlassmorphism(
        style: UIBlurEffect.Style = .systemThinMaterialLight,
        tintColor: UIColor? = nil,
        cornerRadius: CGFloat = 16,
        borderWidth: CGFloat = 0.5,
        borderColor: UIColor = UIColor.white.withAlphaComponent(0.3)
    ) {
        removeGlassmorphism()
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = cornerRadius
        blurView.clipsToBounds = true
        blurView.tag = 9999 // Tag for easy identification and removal
        
        // Force light mode for the blur view
        blurView.overrideUserInterfaceStyle = .light
        
        insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        if let tintColor = tintColor {
            backgroundColor = tintColor
        }
        
        // Apply corner radius and border
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    func removeGlassmorphism() {
        subviews.first(where: { $0.tag == 9999 })?.removeFromSuperview()
        layer.borderWidth = 0
    }
}

// MARK: - Preset Styles
extension UIView {
    
    /// Apply a light glass effect
    func applyLightGlass(cornerRadius: CGFloat = 16) {
        applyGlassmorphism(
            style: .systemUltraThinMaterialLight,
            tintColor: UIColor.white.withAlphaComponent(0.1),
            cornerRadius: cornerRadius
        )
    }
    
    /// Apply a medium glass effect
    func applyMediumGlass(cornerRadius: CGFloat = 16) {
        applyGlassmorphism(
            style: .systemThinMaterialLight,
            tintColor: UIColor(named: "TextColor")?.withAlphaComponent(0.2),
            cornerRadius: cornerRadius
        )
    }
    
    /// Apply a heavy glass effect
    func applyHeavyGlass(cornerRadius: CGFloat = 16) {
        applyGlassmorphism(
            style: .systemMaterialLight,
            tintColor: UIColor(named: "TextColor")?.withAlphaComponent(0.3),
            cornerRadius: cornerRadius,
            borderWidth: 1.0
        )
    }
    
    /// Apply a dark glass effect
    func applyDarkGlass(cornerRadius: CGFloat = 16) {
        applyGlassmorphism(
            style: .systemThickMaterialLight,
            tintColor: UIColor.black.withAlphaComponent(0.3),
            cornerRadius: cornerRadius,
            borderWidth: 0.5,
            borderColor: UIColor.white.withAlphaComponent(0.2)
        )
    }
}
