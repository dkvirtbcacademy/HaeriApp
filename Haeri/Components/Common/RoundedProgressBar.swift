//
//  RoundedProgressBar.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import SwiftUI

struct RoundedProgressBar: View {
    var progress: Double
    var maxValue: Double = 500
    var color: String
    
    private var normalizedProgress: Double {
        min(max(progress / maxValue, 0), 1)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(
                    Color.text.opacity(0.5),
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(144))
            
            Circle()
                .trim(from: 0, to: 0.7 * normalizedProgress)
                .stroke(
                    Color(color),
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(144))
                .animation(.linear, value: progress)
            
            GeometryReader { geometry in
                let radius = geometry.size.width / 2
                
                Text("0")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.text)
                    .position(
                        x: radius - 60,
                        y: geometry.size.height - 10
                    )
                
                Text("\(maxValue.formatted())")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.text)
                    .position(
                        x: radius + 60,
                        y: geometry.size.height - 10
                    )
            }
        }
        .frame(width: 170, height: 170)
    }
}
#Preview {
    RoundedProgressBar(progress: 60, color: "Green Air")
}
