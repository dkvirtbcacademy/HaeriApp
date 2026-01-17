//
//  Color+Ext.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI
import UIKit

private struct AirQualityKey: EnvironmentKey {
    static let defaultValue: Int = 1
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
//    
//    private func backgroundColor(for value: Int) -> Color {
//        switch value {
//        case ..<3:
//            return Color("Background Light")
//        case 3..<4:
//            return Color("Background Moderate")
//        default:
//            return Color("Background Dark")
//        }
//    }
    
    private func backgroundColor(for value: Int) -> Color {
        switch value {
        case 1:
            return Color("Green Air")
        case 2:
            return Color("Yellow Air")
        case 3:
            return Color("Orange Air")
        case 4:
            return Color("Red Air")
        case 5:
            return Color("Purple Air")
        default:
            return Color("Maroon Air")
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
    
//    private func backgroundColor(for value: Int) -> UIColor {
//        switch value {
//        case ..<3:
//            return UIColor(named: "Background Light") ?? UIColor.systemGreen
//        case 3..<4:
//            return UIColor(named: "Background Moderate") ?? UIColor.systemOrange
//        default:
//            return UIColor(named: "Background Dark") ?? UIColor.systemRed
//        }
//    }
    
    private func backgroundColor(for value: Int) -> UIColor {
        switch value {
        case 1:
            return UIColor(named: "Green Air") ?? UIColor.systemGreen
        case 2:
            return UIColor(named: "Yellow Air") ?? UIColor.systemYellow
        case 3:
            return UIColor(named: "Orange Air") ?? UIColor.systemOrange
        case 4:
            return UIColor(named: "Red Air") ?? UIColor.systemRed
        case 5:
            return UIColor(named: "Purple Air") ?? UIColor.systemPurple
        default:
            return UIColor(named: "Maroon Air") ?? UIColor.systemRed
        }
    }
}
