//
//  AddCityButton.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import SwiftUI

struct AddCityButton: View {
    let isVisible: Bool
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus")
                    .font(.firago(.large))
                    .foregroundColor(.darkText)
                Text(label)
                    .font(.firago(.medium))
                    .foregroundColor(.darkText)
            }
        }
        .padding(.horizontal, 6)
        .frame(width: 200, height: 50)
        .glassEffect(.capsule)
        .offset(y: isVisible ? 0 : 100)
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: isVisible)
    }
}

#Preview {
    ZStack {
        Color.blue.opacity(0.3)
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            AddCityButton(isVisible: true, label: "დაამატე ქალაქი") {
                print("Button tapped")
            }
            .padding(.bottom, 10)
        }
    }
}
