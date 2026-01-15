//
//  PollutantGridCard.swift
//  Haeri
//
//  Created by kv on 15.01.26.
//

import SwiftUI

struct PollutantGridCard: View {
    let detail: PollutantDetail
    @State private var showingDetail = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 8) {
                Image(detail.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                Text(detail.type.symbol)
                    .font(.firagoBold(.medium))
                    .foregroundColor(.darkText)
                
                Text(detail.formattedValue)
                    .font(.firago(.large))
                    .foregroundColor(.secondaryDarkText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(detail.category)
                    .font(.firagoMedium(.xsmall))
                    .foregroundColor(.text)
                    .lineLimit(0)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Color(detail.color)
                    )
                    .cornerRadius(16)
            }
            .frame(maxWidth: .infinity)
            .padding(30)
            .glassEffect(.roundedRectangle(radius: 16))
            
            Button {
                showingDetail = true
            } label: {
                Image(systemName: "info.circle")
                    .font(.firago(.medium))
                    .foregroundColor(.secondaryDarkText)
            }
            .padding(12)
        }
        .sheet(isPresented: $showingDetail) {
            PollutantDetailSheet(pollutantDetail: detail)
        }
    }
}

#Preview {
    PollutantGridCard(detail: PollutantDetail(
        type: .aqi,
        value: 2,
        formattedValue: "2",
        category: "არაჯანსაღი მგრძნობიარე ასფასფასასფასფასფას",
        color: "Yellow",
        healthImplications: "ჰაერის ხარისხი მისაღებია; თუმცა, ზოგიერთი დამაბინძურებელი შეიძლება იყოს ზომიერი საფრთხე ძალიან მცირე რაოდენობის ადამიანებისთვის.",
        imageName: "cloud-good",
        maxValue: 5
    ))
    .padding()
}
