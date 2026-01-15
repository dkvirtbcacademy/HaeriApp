//
//  GlassEffectModifier.swift
//  Haeri
//
//  Created by kv on 15.01.26.
//

import SwiftUI

struct GlassEffectModifier: ViewModifier {
    let shape: GlassShape
    
    func body(content: Content) -> some View {
        Group {
            switch shape {
            case .circle(let size):
                content
                    .frame(width: size, height: size)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            case .capsule:
                content
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
            case .roundedRectangle(let radius):
                content
                    .background(
                        RoundedRectangle(cornerRadius: radius)
                            .fill(.ultraThinMaterial)
                    )
            }
        }
        .preferredColorScheme(.light)
    }
}

enum GlassShape {
    case circle(size: CGFloat)
    case capsule
    case roundedRectangle(radius: CGFloat)
}

extension View {
    func glassEffect(_ shape: GlassShape = .circle(size: 44)) -> some View {
        self.modifier(GlassEffectModifier(shape: shape))
    }
}
