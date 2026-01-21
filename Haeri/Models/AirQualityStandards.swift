//
//  AirQualityStandards.swift
//  Haeri
//
//  Created by kv on 15.01.26.
//

import Foundation

struct PollutantInfo {
    let name: String
    let symbol: String
    let description: String
    let unit: String
    let ranges: [QualityRange]
    
    struct QualityRange {
        let min: Double
        let max: Double?
        let category: String
        let color: String
        let parentSymbol: String?
        
        var rangeText: String {
            if parentSymbol == "AQI" {
                return formatValue(min)
            }
            
            if let max = max {
                return "\(formatValue(min)) - \(formatValue(max))"
            } else {
                return "\(formatValue(min))+"
            }
        }
        
        private func formatValue(_ value: Double) -> String {
            if value.truncatingRemainder(dividingBy: 1) == 0 {
                return String(Int(value))
            } else {
                return String(value)
            }
        }
    }
}

struct PollutantDetail: Identifiable {
    let id = UUID()
    let type: PollutantType
    let value: Double
    let formattedValue: String
    let category: String
    let color: String
    let healthImplications: String
    let imageName: String
    let maxValue: Double
    
    var rangeInfo: String {
        switch type {
        case .aqi: return "1-6"
        case .pm25: return "0-500 μg/m³"
        case .pm10: return "0-604 μg/m³"
        case .co: return "0-50.4 mg/m³"
        case .no2: return "0-2000 μg/m³"
        case .o3: return "0-400 μg/m³"
        case .so2: return "0-1000 μg/m³"
        }
    }
}

struct AirQualityStandards {
    static let pollutants: [PollutantInfo] = [
        PollutantInfo(
            name: "წვრილი ნაწილაკები (PM2.5)",
            symbol: "PM2.5",
            description: "PM2.5 არის წვრილი ნაწილაკები, რომლებიც 2.5 მიკრომეტრზე ნაკლებია. ისინი შეიძლება ღრმად შეაღწიონ ფილტვებში და სისხლის ნაკადში, რაც იწვევს სერიოზულ ჯანმრთელობის პრობლემებს.",
            unit: "μg/m³",
            ranges: [
                .init(min: 0, max: 12, category: "კარგი", color: "Green Air", parentSymbol: "PM2.5"),
                .init(min: 12.1, max: 35.4, category: "ზომიერი", color: "Yellow Air", parentSymbol: "PM2.5"),
                .init(min: 35.5, max: 55.4, category: "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის", color: "Orange Air", parentSymbol: "PM2.5"),
                .init(min: 55.5, max: 150.4, category: "არაჯანსაღი", color: "Red Air", parentSymbol: "PM2.5"),
                .init(min: 150.5, max: 250.4, category: "ძალიან არაჯანსაღი", color: "Purple Air", parentSymbol: "PM2.5"),
                .init(min: 250.5, max: nil, category: "საშიში", color: "Maroon Air", parentSymbol: "PM2.5")
            ]
        ),
        
        PollutantInfo(
            name: "უხეში ნაწილაკები (PM10)",
            symbol: "PM10",
            description: "PM10 არის უხეში ნაწილაკები, რომლებიც 10 მიკრომეტრზე ნაკლებია. ისინი შეიძლება გაღიზიანონ თვალები, ცხვირი და ყელი, და გამოიწვიონ რესპირატორული პრობლემები.",
            unit: "μg/m³",
            ranges: [
                .init(min: 0, max: 54, category: "კარგი", color: "Green Air", parentSymbol: "PM10"),
                .init(min: 55, max: 154, category: "ზომიერი", color: "Yellow Air", parentSymbol: "PM10"),
                .init(min: 155, max: 254, category: "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის", color: "Orange Air", parentSymbol: "PM10"),
                .init(min: 255, max: 354, category: "არაჯანსაღი", color: "Red Air", parentSymbol: "PM10"),
                .init(min: 355, max: 424, category: "ძალიან არაჯანსაღი", color: "Purple Air", parentSymbol: "PM10"),
                .init(min: 425, max: nil, category: "საშიში", color: "Maroon Air", parentSymbol: "PM10")
            ]
        ),
        
        PollutantInfo(
            name: "ოზონი (O₃)",
            symbol: "O₃",
            description: "ოზონი არის გაზი, რომელიც იქმნება მზის სინათლისა და დამაბინძურებლების რეაქციის შედეგად. მაღალ დონეზე იწვევს სუნთქვის პრობლემებს და ასთმის გამწვავებას.",
            unit: "μg/m³",
            ranges: [
                .init(min: 0, max: 54, category: "კარგი", color: "Green Air", parentSymbol: "O₃"),
                .init(min: 55, max: 70, category: "ზომიერი", color: "Yellow Air", parentSymbol: "O₃"),
                .init(min: 71, max: 85, category: "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის", color: "Orange Air", parentSymbol: "O₃"),
                .init(min: 86, max: 105, category: "არაჯანსაღი", color: "Red Air", parentSymbol: "O₃"),
                .init(min: 106, max: 200, category: "ძალიან არაჯანსაღი", color: "Purple Air", parentSymbol: "O₃"),
                .init(min: 201, max: nil, category: "საშიში", color: "Maroon Air", parentSymbol: "O₃")
            ]
        ),
        
        PollutantInfo(
            name: "აზოტის დიოქსიდი (NO₂)",
            symbol: "NO₂",
            description: "აზოტის დიოქსიდი წარმოიქმნება საწვავის წვის დროს. იწვევს რესპირატორული სისტემის გაღიზიანებას და ასთმის გამწვავებას.",
            unit: "μg/m³",
            ranges: [
                .init(min: 0, max: 53, category: "კარგი", color: "Green Air", parentSymbol: "NO₂"),
                .init(min: 54, max: 100, category: "ზომიერი", color: "Yellow Air", parentSymbol: "NO₂"),
                .init(min: 101, max: 360, category: "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის", color: "Orange Air", parentSymbol: "NO₂"),
                .init(min: 361, max: 649, category: "არაჯანსაღი", color: "Red Air", parentSymbol: "NO₂"),
                .init(min: 650, max: 1249, category: "ძალიან არაჯანსაღი", color: "Purple Air", parentSymbol: "NO₂"),
                .init(min: 1250, max: nil, category: "საშიში", color: "Maroon Air", parentSymbol: "NO₂")
            ]
        ),
        
        PollutantInfo(
            name: "გოგირდის დიოქსიდი (SO₂)",
            symbol: "SO₂",
            description: "გოგირდის დიოქსიდი გამოიყოფა გოგირდშემცველი საწვავის წვის დროს. იწვევს სუნთქვის პრობლემებს, განსაკუთრებით ასთმით დაავადებულებში.",
            unit: "μg/m³",
            ranges: [
                .init(min: 0, max: 35, category: "კარგი", color: "Green Air", parentSymbol: "SO₂"),
                .init(min: 36, max: 75, category: "ზომიერი", color: "Yellow Air", parentSymbol: "SO₂"),
                .init(min: 76, max: 185, category: "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის", color: "Orange Air", parentSymbol: "SO₂"),
                .init(min: 186, max: 304, category: "არაჯანსაღი", color: "Red Air", parentSymbol: "SO₂"),
                .init(min: 305, max: 604, category: "ძალიან არაჯანსაღი", color: "Purple Air", parentSymbol: "SO₂"),
                .init(min: 605, max: nil, category: "საშიში", color: "Maroon Air", parentSymbol: "SO₂")
            ]
        ),
        
        PollutantInfo(
            name: "ნახშირბადის მონოქსიდი (CO)",
            symbol: "CO",
            description: "ნახშირბადის მონოქსიდი არის უფერო, უსუნო გაზი, რომელიც წარმოიქმნება არასრული წვის დროს. აფერხებს ჟანგბადის მიწოდებას ორგანიზმში.",
            unit: "mg/m³",
            ranges: [
                .init(min: 0, max: 4.4, category: "კარგი", color: "Green Air", parentSymbol: "CO"),
                .init(min: 4.5, max: 9.4, category: "ზომიერი", color: "Yellow Air", parentSymbol: "CO"),
                .init(min: 9.5, max: 12.4, category: "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის", color: "Orange Air", parentSymbol: "CO"),
                .init(min: 12.5, max: 15.4, category: "არაჯანსაღი", color: "Red Air", parentSymbol: "CO"),
                .init(min: 15.5, max: 30.4, category: "ძალიან არაჯანსაღი", color: "Purple Air", parentSymbol: "CO"),
                .init(min: 30.5, max: nil, category: "საშიში", color: "Maroon Air", parentSymbol: "CO")
            ]
        ),
        
        PollutantInfo(
            name: "ამიაკი (NH₃)",
            symbol: "NH₃",
            description: "ამიაკი არის გაზი მძაფრი სუნით, რომელიც ძირითადად წარმოიქმნება სოფლის მეურნეობიდან. მაღალ კონცენტრაციაში იწვევს თვალებისა და რესპირატორული სისტემის გაღიზიანებას.",
            unit: "μg/m³",
            ranges: [
                .init(min: 0, max: 200, category: "კარგი", color: "Green Air", parentSymbol: "NH₃"),
                .init(min: 201, max: 400, category: "ზომიერი", color: "Yellow Air", parentSymbol: "NH₃"),
                .init(min: 401, max: 800, category: "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის", color: "Orange Air", parentSymbol: "NH₃"),
                .init(min: 801, max: 1200, category: "არაჯანსაღი", color: "Red Air", parentSymbol: "NH₃"),
                .init(min: 1201, max: 1800, category: "ძალიან არაჯანსაღი", color: "Purple Air", parentSymbol: "NH₃"),
                .init(min: 1801, max: nil, category: "საშიში", color: "Maroon Air", parentSymbol: "NH₃")
            ]
        )
    ]
    
    static let generalAQI = PollutantInfo(
        name: "საერთო ჰაერის ხარისხის ინდექსი",
        symbol: "AQI",
        description: "AQI (Air Quality Index) არის ჰაერის ხარისხის საერთო მაჩვენებელი, რომელიც ითვალისწინებს ყველა დამაბინძურებელს და აფასებს მათ საერთო გავლენას ჯანმრთელობაზე.",
        unit: "",
        ranges: [
            .init(min: 1, max: 1, category: "კარგი", color: "Green Air", parentSymbol: "AQI"),
            .init(min: 2, max: 2, category: "ზომიერი", color: "Yellow Air", parentSymbol: "AQI"),
            .init(min: 3, max: 3, category: "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის", color: "Orange Air", parentSymbol: "AQI"),
            .init(min: 4, max: 4, category: "არაჯანსაღი", color: "Red Air", parentSymbol: "AQI"),
            .init(min: 5, max: 5, category: "ძალიან არაჯანსაღი", color: "Purple Air", parentSymbol: "AQI"),
            .init(min: 6, max: nil, category: "საშიში", color: "Maroon Air", parentSymbol: "AQI")
        ]
    )
}
