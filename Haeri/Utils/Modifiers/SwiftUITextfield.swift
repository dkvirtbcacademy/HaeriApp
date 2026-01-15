//
//  SwiftUITextfield.swift
//  Haeri
//
//  Created by kv on 15.01.26.
//

import SwiftUI

struct SwiftUITextfield: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.firago(.xsmall))
            .foregroundColor(.text)
            .padding(.horizontal, 16)
            .frame(height: 40)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.text, lineWidth: 1)
            )
            .autocapitalization(.none)
            .autocorrectionDisabled()
    }
}

extension View {
    func customTextFieldStyle() -> some View {
        self.textFieldStyle(SwiftUITextfield())
    }
}
