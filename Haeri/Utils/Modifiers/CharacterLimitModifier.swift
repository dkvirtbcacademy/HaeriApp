//
//  CharacterLimitModifier.swift
//  Haeri
//
//  Created by kv on 21.01.26.
//

import SwiftUI

struct CharacterLimitModifier: ViewModifier {
    @Binding var text: String
    let limit: Int
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { oldValue, newValue in
                if newValue.count > limit {
                    text = String(newValue.prefix(limit))
                }
            }
    }
}

extension View {
    func characterLimit(_ text: Binding<String>, limit: Int) -> some View {
        self.modifier(CharacterLimitModifier(text: text, limit: limit))
    }
}
