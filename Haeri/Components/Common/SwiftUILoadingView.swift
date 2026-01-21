//
//  SwiftUILoadingView.swift
//  Haeri
//
//  Created by kv on 09.01.26.
//

import SwiftUI

struct SwiftUILoadingView: View {
    let label: String
    var body: some View {
        VStack(spacing: 16) {
            ExpandingRings()
                .foregroundColor(.text)
            Text("")
                .font(.firago(.medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SwiftUILoadingView(label: "დაელოდეთ ინფორმაცია იტვირთება...")
        .background(.green)
}
