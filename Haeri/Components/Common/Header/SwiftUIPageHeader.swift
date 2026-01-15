//
//  SwiftUIPageHeader.swift
//  Haeri
//
//  Created by kv on 15.01.26.
//

import SwiftUI

struct SwiftUIPageHeader: View {
    let pageName: String
    let onBackTapped: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBackTapped) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20))
                    .foregroundStyle(.darkText)
                    .glassEffect(.circle(size: 44))
            }
            
            Spacer()
            
            Text(pageName)
                .font(.firagoBold(.medium))
                .foregroundStyle(.darkText)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .glassEffect(.roundedRectangle(radius: 20))
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
    }
}

#Preview {
    SwiftUIPageHeader(pageName: "Test Page") {
        print("Back tapped")
    }
}
