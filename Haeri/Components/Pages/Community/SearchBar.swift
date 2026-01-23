//
//  SearchBar.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.darkText.opacity(0.6))
                    .font(.firagoMedium(.xxsmall))
                
                TextField("მოძებნე პოსტი", text: $searchText)
                    .foregroundColor(.darkText)
                    .autocorrectionDisabled()
                    .characterLimit($searchText, limit: 40)
                
                if !searchText.isEmpty {
                    clearButton
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                searchBarBG
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: searchText.isEmpty)
            
        }
    }
    
    var clearButton: some View {
        Button(action: {
            searchText = ""
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 16))
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    var searchBarBG: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.3),
                                    .white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.15),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
        }
    }
}

#Preview {
    @Previewable @State var searchText: String = "Hello, World!"
    
    SearchBar(searchText: $searchText)
        .background(Color.green)
}
