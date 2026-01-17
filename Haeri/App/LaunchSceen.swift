//
//  LaunchScreen.swift
//  Haeri
//
//  Created by kv on 18.01.26.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color("Green Air")
                .ignoresSafeArea()
            
            VStack {
                CloudMarqueeView(imageName: "clouds2", height: 300, duration: 20)
                Spacer()
                CloudMarqueeView(imageName: "clouds3", height: 200, duration: 10, reversed: true)
                    .padding(.bottom, 90)
            }
            
            VStack(spacing: 40) {
                Image("Haeri Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                
                ProgressView()
                    .tint(.text)
                    .scaleEffect(1.7)
            }
        }
    }
}

struct CloudMarqueeView: View {
    let imageName: String
    let height: CGFloat
    let duration: Double
    var reversed: Bool = false
    
    @State private var xOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0..<2, id: \.self) { _ in
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: height)
                    }
                }
                .offset(x: reversed ? -xOffset : xOffset)
            }
            .disabled(true)
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    xOffset = reversed ? screenWidth : -screenWidth
                }
            }
        }
        .frame(height: height)
        .clipped()
    }
}

#Preview {
    LaunchScreen()
}
