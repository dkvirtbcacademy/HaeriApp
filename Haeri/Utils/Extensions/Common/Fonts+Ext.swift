//
//  Fonts+Ext.swift
//  Haeri
//
//  Created by kv on 06.01.26.
//

import SwiftUI
import UIKit

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
            return 36
        case .xxlarge:
            return 64
        case .custom(let size):
            return size
        }
    }
}

private enum FontName {
    static let regular = "FiraGO-Regular"
    static let medium = "FiraGO-SemiBold"
    static let bold = "FiraGO-Bold"
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
