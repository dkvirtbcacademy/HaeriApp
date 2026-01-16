//
//  SwiftUIButton.swift
//  Haeri
//
//  Created by kv on 15.01.26.
//

import SwiftUI

struct SwiftUIButton: View {
    let label: String
    var isDisabled: Bool = false
    var fontColor: String = "Green"
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.firagoMedium(.xmedium))
                .foregroundStyle(isDisabled ? Color.text.opacity(0.5) : Color(fontColor))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(isDisabled ? Color.text.opacity(0.3) : Color.text)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
        }
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: 20) {
        SwiftUIButton(label: "გამოქვეყნება") {
            print("Button tapped")
        }
        
        SwiftUIButton(label: "გამოქვეყნება", isDisabled: true) {
            print("Button tapped")
        }
    }
    .padding()
    .adaptiveBackground()
}
