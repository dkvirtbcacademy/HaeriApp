//
//  ExpandingRings.swift
//  Haeri
//
//  Created by kv on 21.01.26.
//

import SwiftUI

struct ExpandingRings: View {
    @State private var animate = false
    var strokeColor: Color = .white
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .stroke(strokeColor, lineWidth: 4)
                    .scaleEffect(animate ? 1 : 0)
                    .opacity(animate ? 0 : 1)
                    .animation(
                        Animation.easeOut(duration: 1.5)
                            .repeatForever(autoreverses: false)
                            .delay(Double(i) * 0.5),
                        value: animate
                    )
            }
        }
        .frame(width: 40, height: 40)
        .onAppear {
            animate = true
        }
    }
}


#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        ExpandingRings()
            .foregroundColor(.white)
    }
}
