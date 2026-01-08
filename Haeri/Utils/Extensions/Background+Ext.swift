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
                backgroundColor(for: effectiveValue)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.8), value: effectiveValue)
            )
    }
    
    private func backgroundColor(for value: Int) -> Color {
        switch value {
        case ..<50:
            return Color("Background Light")
        case 50..<100:
            return Color("Background Moderate")
        default:
            return Color("Background Dark")
        }
    }
}

extension UIViewController {
    func addAdaptiveBackground(value: Int, animated: Bool = true) {
        let colorView: UIView
        
        if let existingView = view.subviews.first(where: { $0.tag == 999 }) {
            colorView = existingView
        } else {
            colorView = UIView()
            colorView.tag = 999
            view.insertSubview(colorView, at: 0)
        }
        
        colorView.frame = view.bounds
        
        let newColor = backgroundColor(for: value)
        
        if animated {
            UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseInOut], animations: {
                colorView.backgroundColor = newColor
            })
        } else {
            colorView.backgroundColor = newColor
        }
    }
    
    func updateBackgroundFrame() {
        if let colorView = view.subviews.first(where: { $0.tag == 999 }) {
            colorView.frame = view.bounds
        }
    }
    
    private func backgroundColor(for value: Int) -> UIColor {
        switch value {
        case ..<50:
            return UIColor(named: "Background Light") ?? UIColor.systemGreen
        case 50..<100:
            return UIColor(named: "Background Moderate") ?? UIColor.systemOrange
        default:
            return UIColor(named: "Background Dark") ?? UIColor.systemRed
        }
    }
}
