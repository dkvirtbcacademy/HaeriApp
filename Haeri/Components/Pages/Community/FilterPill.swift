//
//  FilterPill.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import SwiftUI
struct FilterPill: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.firago(.xsmall))
            .foregroundColor(.darkText)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isSelected
                ? Color("SelectedCell").opacity(0.6)
                : Color("TextColor").opacity(0.6)
            )
            .clipShape(Capsule())
            .foregroundColor(.white)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}


#Preview {
    FilterPill(title: "შენახული", isSelected: false)
        .background(Color.green)
}
