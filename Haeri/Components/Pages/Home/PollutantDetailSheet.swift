//
//  PollutantDetailSheet.swift
//  Haeri
//
//  Created by kv on 15.01.26.
//

import SwiftUI

struct PollutantDetailSheet: View {
    let pollutantDetail: PollutantDetail
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    mainCard
                    
                    InfoSection(
                        icon: "info.circle.fill",
                        iconColor: Color(pollutantDetail.color),
                        title: "რა არის \(pollutantDetail.type.symbol)?"
                    ) {
                        Text(pollutantDetail.type.description)
                            .font(.firago(.medium))
                            .foregroundColor(.secondaryDarkText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    InfoSection(
                        icon: "heart.text.square.fill",
                        iconColor: Color(pollutantDetail.color),
                        title: "ჯანმრთელობაზე გავლენა"
                    ) {
                        Text(pollutantDetail.healthImplications)
                            .font(.firago(.medium))
                            .foregroundColor(.secondaryDarkText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    InfoSection(
                        icon: "chart.bar.fill",
                        iconColor: .blue,
                        title: "საზომი შკალა"
                    ) {
                        HStack(alignment: .top) {
                            Text("დიაპაზონი:")
                                .font(.firago(.medium))
                            Spacer()
                            Text(pollutantDetail.rangeInfo)
                                .font(.firago(.medium))
                                .foregroundColor(.secondaryDarkText)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    if let standards = getStandardsForPollutant() {
                        InfoSection(
                            icon: "list.bullet.rectangle.fill",
                            iconColor: .green,
                            title: "ხარისხის კატეგორიები"
                        ) {
                            VStack(spacing: 8) {
                                ForEach(standards.ranges, id: \.category) { range in
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(Color(range.color))
                                            .frame(width: 12, height: 12)
                                        
                                        Text(range.category)
                                            .font(.firago(.xxsmall))
                                        
                                        Spacer()
                                        
                                        Text(range.rangeText)
                                            .font(.firagoMedium(.xxsmall))
                                            .foregroundColor(.secondaryDarkText)
                                    }
                                    .padding(.vertical, 4)
                                    
                                    if range.category != standards.ranges.last?.category {
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(pollutantDetail.type.symbol)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("დახურვა") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var mainCard: some View {
        VStack(spacing: 20) {
            Image(pollutantDetail.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .accessibilityLabel(pollutantDetail.type.displayName)
            
            VStack(spacing: 8) {
                Text(pollutantDetail.type.displayName)
                    .font(.firagoBold(.large))
                    .foregroundColor(.darkText)
                    .multilineTextAlignment(.center)
                
                Text(pollutantDetail.type.symbol)
                    .font(.firagoMedium(.large))
                    .foregroundColor(.secondaryDarkText)
            }
            
            VStack(spacing: 8) {
                Text(pollutantDetail.formattedValue)
                    .font(.firagoBold(.large))
                    .foregroundColor(Color(pollutantDetail.color))
                
                Text(pollutantDetail.category)
                    .font(.firago(.medium))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Color(pollutantDetail.color)
                            .opacity(0.15)
                    )
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func getStandardsForPollutant() -> PollutantInfo? {
        switch pollutantDetail.type {
        case .aqi:
            return AirQualityStandards.generalAQI
        case .pm25:
            return AirQualityStandards.pollutants.first { $0.symbol == "PM2.5" }
        case .pm10:
            return AirQualityStandards.pollutants.first { $0.symbol == "PM10" }
        case .co:
            return AirQualityStandards.pollutants.first { $0.symbol == "CO" }
        case .no2:
            return AirQualityStandards.pollutants.first { $0.symbol == "NO₂" }
        case .o3:
            return AirQualityStandards.pollutants.first { $0.symbol == "O₃" }
        case .so2:
            return AirQualityStandards.pollutants.first { $0.symbol == "SO₂" }
        }
    }
}

struct InfoSection<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    let content: Content
    
    init(
        icon: String,
        iconColor: Color,
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 18))
                
                Text(title)
                    .font(.firagoMedium(.medium))
            }
            
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

#Preview {
    PollutantDetailSheet(pollutantDetail: PollutantDetail(
        type: .aqi,
        value: 2,
        formattedValue: "2",
        category: "ზომიერი",
        color: "Yellow",
        healthImplications: "ჰაერის ხარისხი მისაღებია; თუმცა, ზოგიერთი დამაბინძურებელი შეიძლება იყოს ზომიერი საფრთხე ძალიან მცირე რაოდენობის ადამიანებისთვის.",
        imageName: "cloud-good",
        maxValue: 5
    ))
}
