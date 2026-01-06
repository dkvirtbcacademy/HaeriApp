//
//  Color+Ext.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI
import UIKit

private struct AirQualityKey: EnvironmentKey {
    static let defaultValue: Int = 25
}

extension EnvironmentValues {
    var airQuality: Int {
        get { self[AirQualityKey.self] }
        set { self[AirQualityKey.self] = newValue }
    }
}

extension View {
    func adaptiveBackground(value: Int? = nil) -> some View {
        AdaptiveBackgroundView(content: self, value: value)
    }
}

private struct AdaptiveBackgroundView<Content: View>: View {
    let content: Content
    let value: Int?
    @Environment(\.airQuality) private var environmentValue
    
    private var effectiveValue: Int {
        value ?? environmentValue
    }
    
    var body: some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: gradientColors(for: effectiveValue)),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.8), value: effectiveValue)
            )
    }
    
    private func gradientColors(for value: Int) -> [Color] {
        switch value {
        case ..<50:
            return [Color("Light Gradient 1"), Color("Light Gradient 2")]
        case 50..<100:
            return [Color("Moderate Gradient 1"), Color("Moderate Gradient 2")]
        default:
            return [Color("Dark Gradient 1"), Color("Dark Gradient 2")]
        }
    }
}

extension UIViewController {
    func addAdaptiveBackground(value: Int, animated: Bool = true) {
        let gradientLayer: CAGradientLayer
        
        if let existingLayer = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer = existingLayer
        } else {
            gradientLayer = CAGradientLayer()
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        gradientLayer.frame = view.bounds
        
        let newColors = gradientColors(for: value)
        
        if animated {
            gradientLayer.removeAnimation(forKey: "colorChange")
            
            let animation = CABasicAnimation(keyPath: "colors")
            animation.fromValue = gradientLayer.colors ?? gradientLayer.colors
            animation.toValue = newColors
            animation.duration = 0.8
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            gradientLayer.colors = newColors
            
            gradientLayer.add(animation, forKey: "colorChange")
        } else {
            gradientLayer.colors = newColors
        }
    }
    
    func updateGradientFrame() {
        if let gradientLayer = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            gradientLayer.frame = view.bounds
        }
    }
    
    private func gradientColors(for value: Int) -> [CGColor] {
        let colorPair: (String, String)
        
        switch value {
        case ..<50:
            colorPair = ("Light Gradient 1", "Light Gradient 2")
        case 50..<100:
            colorPair = ("Moderate Gradient 1", "Moderate Gradient 2")
        default:
            colorPair = ("Dark Gradient 1", "Dark Gradient 2")
        }
        
        return [
            UIColor(named: colorPair.0)?.cgColor ?? UIColor.systemGray.cgColor,
            UIColor(named: colorPair.1)?.cgColor ?? UIColor.systemGray.cgColor
        ]
    }
}
