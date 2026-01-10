//
//  Fonts+Ext.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI
import UIKit

// Shared font size enum
enum FontSize {
    case small
    case xsmall
    case xxsmall
    case medium
    case xmedium
    case large
    case xlarge
    case xxlarge
    case custom(CGFloat)
    
    var value: CGFloat {
        switch self {
        case .small:
            return 10
        case .xsmall:
            return 14
        case .xxsmall:
            return 16
        case .medium:
            return 18
        case .xmedium:
            return 21
        case .large:
            return 24
        case .xlarge:
            return 30
        case .xxlarge:
            return 64
        case .custom(let size):
            return size
        }
    }
}

// Shared font names
private enum FontName {
    static let regular = "FiraGO-Regular"
    static let medium = "FiraGO-Medium"
    static let bold = "FiraGO-SemiBold"
}

extension Font {
    static func firago(_ size: FontSize) -> Font {
        return Font.custom(FontName.regular, size: size.value)
    }
    
    static func firagoMedium(_ size: FontSize) -> Font {
        return Font.custom(FontName.medium, size: size.value)
    }
    
    static func firagoBold(_ size: FontSize) -> Font {
        return Font.custom(FontName.bold, size: size.value)
    }
}

extension UIFont {
    static func firago(_ size: FontSize) -> UIFont {
        return UIFont(name: FontName.regular, size: size.value) ?? UIFont.systemFont(ofSize: size.value)
    }
    
    static func firagoMedium(_ size: FontSize) -> UIFont {
        return UIFont(name: FontName.medium, size: size.value) ?? UIFont.systemFont(ofSize: size.value, weight: .medium)
    }
    
    static func firagoBold(_ size: FontSize) -> UIFont {
        return UIFont(name: FontName.bold, size: size.value) ?? UIFont.systemFont(ofSize: size.value, weight: .semibold)
    }
}
