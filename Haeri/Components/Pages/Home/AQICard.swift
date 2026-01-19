//
//  AQICard.swift
//  Haeri
//
//  Created by kv on 15.01.26.
//

import SwiftUI

struct AQICard: View {
    let aqiDetail: PollutantDetail
    let onInfoTapped: () -> Void
    @State private var showingDetail = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: -20) {
                ZStack(alignment: .center) {
                    RoundedProgressBar(progress: aqiDetail.value, maxValue: aqiDetail.maxValue, color: aqiDetail.color)
                    
                    VStack(spacing: 6) {
                        Text(aqiDetail.formattedValue)
                            .font(.firagoBold(.xlarge))
                            .foregroundColor(.darkText)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        Text("ჰაერის ხარისხი")
                            .font(.firagoMedium(.xsmall))
                            .foregroundColor(.darkText)
                            .padding(.bottom, 20)
                        
                    }
                }
                
                VStack(spacing: 8) {
                    Image(aqiDetail.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    
                    Text(aqiDetail.category)
                        .font(.firagoMedium(.xsmall))
                        .foregroundColor(.text)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Color(aqiDetail.color)
                        )
                        .cornerRadius(16)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(30)
            .glassEffect(.roundedRectangle(radius: 16))
            
            Button(action: onInfoTapped) {
                Image(systemName: "info.circle")
                    .font(.firago(.medium))
                    .foregroundColor(.secondaryDarkText)
            }
            .padding(20)
        }
    }
}

#Preview {
    AQICard(
        aqiDetail: PollutantDetail(
            type: .aqi,
            value: 2,
            formattedValue: "2",
            category: "ზომიერი",
            color: "Yellow Air",
            healthImplications: "ჰაერის ხარისხი მისაღებია; თუმცა, ზოგიერთი დამაბინძურებელი შეიძლება იყოს ზომიერი საფრთხე ძალიან მცირე რაოდენობის ადამიანებისთვის.",
            imageName: "cloud-good",
            maxValue: 5
        ),
        onInfoTapped: {
            print(
                "Info tapped"
            )
        })
    .padding()
}
