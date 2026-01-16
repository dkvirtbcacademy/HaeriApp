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
        blurView.tag = 9999
        
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

extension UIView {
    func applyLightGlass(cornerRadius: CGFloat = 16) {
        applyGlassmorphism(
            style: .systemUltraThinMaterialLight,
            tintColor: UIColor.white.withAlphaComponent(0.1),
            cornerRadius: cornerRadius
        )
    }
    
    func applyMediumGlass(cornerRadius: CGFloat = 16) {
        applyGlassmorphism(
            style: .systemThinMaterialLight,
            tintColor: UIColor(named: "TextColor")?.withAlphaComponent(0.2),
            cornerRadius: cornerRadius
        )
    }
    
    func applyHeavyGlass(cornerRadius: CGFloat = 16) {
        applyGlassmorphism(
            style: .systemMaterialLight,
            tintColor: UIColor(named: "TextColor")?.withAlphaComponent(0.3),
            cornerRadius: cornerRadius,
            borderWidth: 1.0
        )
    }
    
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

extension UIButton {
    func applyGlassEffect() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.isUserInteractionEnabled = false
        blurView.layer.cornerRadius = layer.cornerRadius
        blurView.clipsToBounds = true
        
        insertSubview(blurView, at: 0)
    }
}
