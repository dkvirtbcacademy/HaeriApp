//
//  PollutantType.swift
//  Haeri
//
//  Created by kv on 15.01.26.
//

import Foundation

enum PollutantType: String, CaseIterable, Identifiable {
    case aqi = "AQI"
    case pm25 = "PM2.5"
    case pm10 = "PM10"
    case co = "CO"
    case no2 = "NO₂"
    case o3 = "O₃"
    case so2 = "SO₂"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .aqi: return "ჰაერის ხარისხის ინდექსი"
        case .pm25: return "წვრილი ნაწილაკები"
        case .pm10: return "უხეში ნაწილაკები"
        case .co: return "ნახშირბადის მონოქსიდი"
        case .no2: return "აზოტის დიოქსიდი"
        case .o3: return "ოზონი"
        case .so2: return "გოგირდის დიოქსიდი"
        }
    }
    
    var symbol: String { rawValue }
    
    var description: String {
        switch self {
        case .aqi:
            return "AQI (Air Quality Index) არის ჰაერის ხარისხის საერთო მაჩვენებელი, რომელიც ითვალისწინებს ყველა დამაბინძურებელს და აფასებს მათ საერთო გავლენას ჯანმრთელობაზე."
        case .pm25:
            return "PM2.5 არის წვრილი ნაწილაკები, რომლებიც 2.5 მიკრომეტრზე ნაკლებია. ისინი შეიძლება ღრმად შეაღწიონ ფილტვებში და სისხლის ნაკადში, რაც იწვევს სერიოზულ ჯანმრთელობის პრობლემებს."
        case .pm10:
            return "PM10 არის უხეში ნაწილაკები, რომლებიც 10 მიკრომეტრზე ნაკლებია. ისინი შეიძლება გაღიზიანონ თვალები, ცხვირი და ყელი, და გამოიწვიონ რესპირატორული პრობლემები."
        case .co:
            return "ნახშირბადის მონოქსიდი არის უფერო, უსუნო გაზი, რომელიც წარმოიქმნება არასრული წვის დროს. აფერხებს ჟანგბადის მიწოდებას ორგანიზმში."
        case .no2:
            return "აზოტის დიოქსიდი წარმოიქმნება საწვავის წვის დროს. იწვევს რესპირატორული სისტემის გაღიზიანებას და ასთმის გამწვავებას."
        case .o3:
            return "ოზონი არის გაზი, რომელიც იქმნება მზის სინათლისა და დამაბინძურებლების რეაქციის შედეგად. მაღალ დონეზე იწვევს სუნთქვის პრობლემებს და ასთმის გამწვავებას."
        case .so2:
            return "გოგირდის დიოქსიდი გამოიყოფა გოგირდშემცველი საწვავის წვის დროს. იწვევს სუნთქვის პრობლემებს, განსაკუთრებით ასთმით დაავადებულებში."
        }
    }
    
    var unit: String {
        switch self {
        case .aqi: return ""
        case .co: return "mg/m³"
        default: return "μg/m³"
        }
    }
}

extension AirPollutionResponse.AirPollutionItem {
    
    func getPollutantDetail(for type: PollutantType) -> PollutantDetail {
        switch type {
        case .aqi:
            let category = aqiCategory
            return PollutantDetail(
                type: type,
                value: Double(main.aqi),
                formattedValue: "\(main.aqi)",
                category: category.description,
                color: category.color,
                healthImplications: category.healthImplications,
                imageName: category.imageName,
                maxValue: Double(category.maxValue)
            )
            
        case .pm25:
            let level = pm25Level
            return PollutantDetail(
                type: type,
                value: components.pm2_5,
                formattedValue: String(format: "%.1f μg/m³", components.pm2_5),
                category: level.description,
                color: level.color,
                healthImplications: level.healthImplications,
                imageName: level.imageName,
                maxValue: level.maxValue
            )
            
        case .pm10:
            let level = pm10Level
            return PollutantDetail(
                type: type,
                value: components.pm10,
                formattedValue: String(format: "%.1f μg/m³", components.pm10),
                category: level.description,
                color: level.color,
                healthImplications: level.healthImplications,
                imageName: level.imageName,
                maxValue: level.maxValue
            )
            
        case .co:
            let level = coLevel
            let coInMg = components.co / 1000
            return PollutantDetail(
                type: type,
                value: coInMg,
                formattedValue: String(format: "%.1f mg/m³", coInMg),
                category: level.description,
                color: level.color,
                healthImplications: level.healthImplications,
                imageName: level.imageName,
                maxValue: level.maxValue
            )
            
        case .no2:
            let level = no2Level
            return PollutantDetail(
                type: type,
                value: components.no2,
                formattedValue: String(format: "%.1f μg/m³", components.no2),
                category: level.description,
                color: level.color,
                healthImplications: level.healthImplications,
                imageName: level.imageName,
                maxValue: level.maxValue
            )
            
        case .o3:
            let level = o3Level
            return PollutantDetail(
                type: type,
                value: components.o3,
                formattedValue: String(format: "%.1f μg/m³", components.o3),
                category: level.description,
                color: level.color,
                healthImplications: level.healthImplications,
                imageName: level.imageName,
                maxValue: level.maxValue
            )
            
        case .so2:
            let level = so2Level
            return PollutantDetail(
                type: type,
                value: components.so2,
                formattedValue: String(format: "%.1f μg/m³", components.so2),
                category: level.description,
                color: level.color,
                healthImplications: level.healthImplications,
                imageName: level.imageName,
                maxValue: level.maxValue
            )
        }
    }
    
    func getAllPollutantDetails() -> [PollutantDetail] {
        PollutantType.allCases.map { getPollutantDetail(for: $0) }
    }
}
