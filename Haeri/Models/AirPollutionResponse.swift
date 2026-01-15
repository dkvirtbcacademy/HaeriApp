//
//  AirPollutionResponse.swift
//  Haeri
//
//  Created by kv on 07.01.26.
//

import Foundation

struct GeoResponse: Codable {
    let name: String
    let local_names: LocalNames?
    let lat: Double
    let lon: Double
    let country: String
    
    struct LocalNames: Codable {
        let ka: String?
    }
}

struct CityAirPollution {
    let city: String
    let localeName: String?
    let response: AirPollutionResponse
}

struct AirPollutionResponse: Codable {
    let coord: Coord
    let list: [AirPollutionItem]
    
    var item: AirPollutionItem? {
        list.first
    }
    
    struct Coord: Codable {
        let lat: Double
        let lon: Double
    }
    
    struct AirPollutionItem: Codable {
        let main: AQI
        let components: Components
        let dt: Int
        
        struct AQI: Codable {
            let aqi: Int
        }
        
        struct Components: Codable {
            let co: Double
            let no: Double
            let no2: Double
            let o3: Double
            let so2: Double
            let pm2_5: Double
            let pm10: Double
        }
    }
    
}

extension AirPollutionResponse.AirPollutionItem {
    enum AQICategory {
        case good
        case moderate
        case unhealthyForSensitive
        case unhealthy
        case veryUnhealthy
        case hazardous
        
        var description: String {
            switch self {
            case .good: return "კარგი"
            case .moderate: return "ზომიერი"
            case .unhealthyForSensitive: return "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის"
            case .unhealthy: return "არაჯანსაღი"
            case .veryUnhealthy: return "ძალიან არაჯანსაღი"
            case .hazardous: return "საშიში"
            }
        }
        
        var color: String {
            switch self {
            case .good: return "Green"
            case .moderate: return "Yellow"
            case .unhealthyForSensitive: return "Orange"
            case .unhealthy: return "Red"
            case .veryUnhealthy: return "Purple"
            case .hazardous: return "Maroon"
            }
        }
        
        var imageName: String {
            switch self {
            case .good: return "cloud-good"
            case .moderate: return "cloud-moderate"
            case .unhealthyForSensitive: return "cloud-sensitive"
            case .unhealthy: return "cloud-unhealthy"
            case .veryUnhealthy: return "cloud-very-unhealthy"
            case .hazardous: return "cloud-hazardous"
            }
        }
        
        var healthImplications: String {
            switch self {
            case .good:
                return "ჰაერის ხარისხი დამაკმაყოფილებელია და ჰაერის დაბინძურება მცირე ან არანაირ რისკს არ უქმნის."
            case .moderate:
                return "ჰაერის ხარისხი მისაღებია. თუმცა, შეიძლება არსებობდეს რისკი ზოგიერთი ადამიანისთვის, განსაკუთრებით მათთვის, ვინც უჩვეულოდ მგრძნობიარეა ჰაერის დაბინძურების მიმართ."
            case .unhealthyForSensitive:
                return "მგრძნობიარე ჯგუფების წარმომადგენლებმა შეიძლება განიცადონ ჯანმრთელობის პრობლემები. ფართო საზოგადოების დაზარალების ალბათობა ნაკლებია."
            case .unhealthy:
                return "ფართო საზოგადოების ზოგიერთმა წევრმა შეიძლება განიცადოს ჯანმრთელობის პრობლემები; მგრძნობიარე ჯგუფების წევრებმა შეიძლება განიცადონ უფრო სერიოზული ჯანმრთელობის პრობლემები."
            case .veryUnhealthy:
                return "ჯანმრთელობის გაფრთხილება: ჯანმრთელობის პრობლემების რისკი გაზრდილია ყველასთვის."
            case .hazardous:
                return "ჯანმრთელობის გაფრთხილება საგანგებო პირობების შესახებ: ყველას მეტად შეუძლია განიცადოს ჯანმრთელობის პრობლემები."
            }
        }
        
        var maxValue: Int {
            return 6
        }
    }
    
    enum COLevel {
        case good
        case moderate
        case unhealthyForSensitive
        case unhealthy
        case veryUnhealthy
        case hazardous
        
        var description: String {
            switch self {
            case .good: return "კარგი"
            case .moderate: return "ზომიერი"
            case .unhealthyForSensitive: return "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის"
            case .unhealthy: return "არაჯანსაღი"
            case .veryUnhealthy: return "ძალიან არაჯანსაღი"
            case .hazardous: return "საშიში"
            }
        }
         
        var color: String {
            switch self {
            case .good: return "Green"
            case .moderate: return "Yellow"
            case .unhealthyForSensitive: return "Orange"
            case .unhealthy: return "Red"
            case .veryUnhealthy: return "Purple"
            case .hazardous: return "Maroon"
            }
        }
        
        var imageName: String {
            switch self {
            case .good: return "cloud-good"
            case .moderate: return "cloud-moderate"
            case .unhealthyForSensitive: return "cloud-sensitive"
            case .unhealthy: return "cloud-unhealthy"
            case .veryUnhealthy: return "cloud-very-unhealthy"
            case .hazardous: return "cloud-hazardous"
            }
        }
        
        var healthImplications: String {
            switch self {
            case .good:
                return "ნახშირბადის მონოქსიდის დონე ნორმალურია და არ წარმოადგენს საფრთხეს."
            case .moderate:
                return "ნახშირბადის მონოქსიდის დონე მისაღებია, მაგრამ მგრძნობიარე ადამიანებმა შეიძლება განიცადონ სუსტი სიმპტომები."
            case .unhealthyForSensitive:
                return "გულ-სისხლძარღვთა და რესპირატორული დაავადებების მქონე ადამიანებმა შეიძლება განიცადონ სიმპტომების გამწვავება."
            case .unhealthy:
                return "გულ-სისხლძარღვთა სისტემაზე გავლენა შესაძლებელია. შეამცირეთ ინტენსიური ფიზიკური აქტივობა."
            case .veryUnhealthy:
                return "სერიოზული გავლენა გულ-სისხლძარღვთა სისტემაზე. თავიდან აიცილეთ ინტენსიური აქტივობა."
            case .hazardous:
                return "სახიფათო დონე. დარჩით შენობის შიგნით და თავიდან აიცილეთ ნებისმიერი ფიზიკური აქტივობა."
            }
        }
        
        var maxValue: Double {
            return 50.4
        }
    }
    
    enum NO2Level {
        case good
        case moderate
        case unhealthyForSensitive
        case unhealthy
        case veryUnhealthy
        case hazardous
        
        var description: String {
            switch self {
            case .good: return "კარგი"
            case .moderate: return "ზომიერი"
            case .unhealthyForSensitive: return "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის"
            case .unhealthy: return "არაჯანსაღი"
            case .veryUnhealthy: return "ძალიან არაჯანსაღი"
            case .hazardous: return "საშიში"
            }
        }
        
        var color: String {
            switch self {
            case .good: return "Green"
            case .moderate: return "Yellow"
            case .unhealthyForSensitive: return "Orange"
            case .unhealthy: return "Red"
            case .veryUnhealthy: return "Purple"
            case .hazardous: return "Maroon"
            }
        }
        
        var imageName: String {
            switch self {
            case .good: return "cloud-good"
            case .moderate: return "cloud-moderate"
            case .unhealthyForSensitive: return "cloud-sensitive"
            case .unhealthy: return "cloud-unhealthy"
            case .veryUnhealthy: return "cloud-very-unhealthy"
            case .hazardous: return "cloud-hazardous"
            }
        }
        
        var healthImplications: String {
            switch self {
            case .good:
                return "აზოტის დიოქსიდის დონე ნორმალურია და არ წარმოადგენს საფრთხეს."
            case .moderate:
                return "აზოტის დიოქსიდის დონე მისაღებია, მაგრამ ასთმით დაავადებულებმა შეიძლება განიცადონ სუსტი სიმპტომები."
            case .unhealthyForSensitive:
                return "ასთმით და რესპირატორული დაავადებების მქონე ადამიანებმა შეიძლება განიცადონ სუნთქვის სირთულეები."
            case .unhealthy:
                return "რესპირატორული სისტემის გაღიზიანება. ასთმით დაავადებულებმა შეამცირეთ გარე აქტივობები."
            case .veryUnhealthy:
                return "სერიოზული რესპირატორული პრობლემები. თავიდან აიცილეთ გარე აქტივობები."
            case .hazardous:
                return "სახიფათო დონე. დარჩით შენობის შიგნით და გამოიყენეთ ჰაერის გამწმენდი."
            }
        }
        
        var maxValue: Double {
            return 2000
        }
    }
    
    enum O3Level {
        case good
        case moderate
        case unhealthyForSensitive
        case unhealthy
        case veryUnhealthy
        case hazardous
        
        var description: String {
            switch self {
            case .good: return "კარგი"
            case .moderate: return "ზომიერი"
            case .unhealthyForSensitive: return "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის"
            case .unhealthy: return "არაჯანსაღი"
            case .veryUnhealthy: return "ძალიან არაჯანსაღი"
            case .hazardous: return "საშიში"
            }
        }
        
        var color: String {
            switch self {
            case .good: return "Green"
            case .moderate: return "Yellow"
            case .unhealthyForSensitive: return "Orange"
            case .unhealthy: return "Red"
            case .veryUnhealthy: return "Purple"
            case .hazardous: return "Maroon"
            }
        }
        
        var imageName: String {
            switch self {
            case .good: return "cloud-good"
            case .moderate: return "cloud-moderate"
            case .unhealthyForSensitive: return "cloud-sensitive"
            case .unhealthy: return "cloud-unhealthy"
            case .veryUnhealthy: return "cloud-very-unhealthy"
            case .hazardous: return "cloud-hazardous"
            }
        }
        
        var healthImplications: String {
            switch self {
            case .good:
                return "ოზონის დონე ნორმალურია და არ წარმოადგენს საფრთხეს."
            case .moderate:
                return "ოზონის დონე მისაღებია. მგრძნობიარე ადამიანებმა შეამცირეთ ხანგრძლივი გარე აქტივობები."
            case .unhealthyForSensitive:
                return "ასთმით და რესპირატორული დაავადებების მქონე ადამიანებმა შეამცირეთ ინტენსიური გარე აქტივობები."
            case .unhealthy:
                return "სუნთქვის პრობლემები შესაძლებელია. შეამცირეთ ხანგრძლივი ან ინტენსიური გარე აქტივობები."
            case .veryUnhealthy:
                return "სერიოზული რესპირატორული პრობლემები. თავიდან აიცილეთ გარე აქტივობები."
            case .hazardous:
                return "სახიფათო დონე. დარჩით შენობის შიგნით და თავიდან აიცილეთ ფიზიკური დატვირთვა."
            }
        }
        
        var maxValue: Double {
            return 400
        }
    }
    
    enum SO2Level {
        case good
        case moderate
        case unhealthyForSensitive
        case unhealthy
        case veryUnhealthy
        case hazardous
        
        var description: String {
            switch self {
            case .good: return "კარგი"
            case .moderate: return "ზომიერი"
            case .unhealthyForSensitive: return "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის"
            case .unhealthy: return "არაჯანსაღი"
            case .veryUnhealthy: return "ძალიან არაჯანსაღი"
            case .hazardous: return "საშიში"
            }
        }
        
        var color: String {
            switch self {
            case .good: return "Green"
            case .moderate: return "Yellow"
            case .unhealthyForSensitive: return "Orange"
            case .unhealthy: return "Red"
            case .veryUnhealthy: return "Purple"
            case .hazardous: return "Maroon"
            }
        }
        
        var imageName: String {
            switch self {
            case .good: return "cloud-good"
            case .moderate: return "cloud-moderate"
            case .unhealthyForSensitive: return "cloud-sensitive"
            case .unhealthy: return "cloud-unhealthy"
            case .veryUnhealthy: return "cloud-very-unhealthy"
            case .hazardous: return "cloud-hazardous"
            }
        }
        
        var healthImplications: String {
            switch self {
            case .good:
                return "გოგირდის დიოქსიდის დონე ნორმალურია და არ წარმოადგენს საფრთხეს."
            case .moderate:
                return "გოგირდის დიოქსიდის დონე მისაღებია. ასთმით დაავადებულებმა იყავით ფრთხილად."
            case .unhealthyForSensitive:
                return "ასთმით დაავადებულებს შეუძლიათ განიცადონ სუნთქვის სირთულეები ინტენსიური აქტივობის დროს."
            case .unhealthy:
                return "რესპირატორული პრობლემები. ასთმით დაავადებულებმა შეამცირეთ გარე აქტივობები."
            case .veryUnhealthy:
                return "სერიოზული რესპირატორული პრობლემები. თავიდან აიცილეთ გარე აქტივობები."
            case .hazardous:
                return "სახიფათო დონე. დარჩით შენობის შიგნით, განსაკუთრებით ასთმით დაავადებულებმა."
            }
        }
        
        var maxValue: Double {
            return 1000
        }
    }
    
    enum PM25Level {
        case good
        case moderate
        case unhealthyForSensitive
        case unhealthy
        case veryUnhealthy
        case hazardous
        
        var description: String {
            switch self {
            case .good: return "კარგი"
            case .moderate: return "ზომიერი"
            case .unhealthyForSensitive: return "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის"
            case .unhealthy: return "არაჯანსაღი"
            case .veryUnhealthy: return "ძალიან არაჯანსაღი"
            case .hazardous: return "საშიში"
            }
        }
        
        var color: String {
            switch self {
            case .good: return "Green"
            case .moderate: return "Yellow"
            case .unhealthyForSensitive: return "Orange"
            case .unhealthy: return "Red"
            case .veryUnhealthy: return "Purple"
            case .hazardous: return "Maroon"
            }
        }
        
        var imageName: String {
            switch self {
            case .good: return "cloud-good"
            case .moderate: return "cloud-moderate"
            case .unhealthyForSensitive: return "cloud-sensitive"
            case .unhealthy: return "cloud-unhealthy"
            case .veryUnhealthy: return "cloud-very-unhealthy"
            case .hazardous: return "cloud-hazardous"
            }
        }
        
        var healthImplications: String {
            switch self {
            case .good:
                return "წვრილი ნაწილაკების დონე ნორმალურია და არ წარმოადგენს საფრთხეს."
            case .moderate:
                return "წვრილი ნაწილაკების დონე მისაღებია. განსაკუთრებით მგრძნობიარე ადამიანებმა განიხილეთ გარე აქტივობების შემცირება."
            case .unhealthyForSensitive:
                return "გულ-სისხლძარღვთა და რესპირატორული დაავადებების მქონე ადამიანებმა შეამცირეთ ინტენსიური გარე აქტივობები."
            case .unhealthy:
                return "ყველამ შეამცირეთ ხანგრძლივი ან ინტენსიური გარე აქტივობები. მგრძნობიარე ჯგუფებმა თავიდან აიცილეთ."
            case .veryUnhealthy:
                return "ყველამ თავიდან აიცილოთ ხანგრძლივი ან ინტენსიური გარე აქტივობები. დარჩით შენობის შიგნით."
            case .hazardous:
                return "სახიფათო დონე. ყველამ დარჩით შენობის შიგნით და გამოიყენეთ ჰაერის გამწმენდი."
            }
        }
        
        var maxValue: Double {
            return 500
        }
    }
    
    enum PM10Level {
        case good
        case moderate
        case unhealthyForSensitive
        case unhealthy
        case veryUnhealthy
        case hazardous
        
        var description: String {
            switch self {
            case .good: return "კარგი"
            case .moderate: return "ზომიერი"
            case .unhealthyForSensitive: return "არაჯანსაღი მგრძნობიარე ჯგუფებისთვის"
            case .unhealthy: return "არაჯანსაღი"
            case .veryUnhealthy: return "ძალიან არაჯანსაღი"
            case .hazardous: return "საშიში"
            }
        }
        
        var color: String {
            switch self {
            case .good: return "Green"
            case .moderate: return "Yellow"
            case .unhealthyForSensitive: return "Orange"
            case .unhealthy: return "Red"
            case .veryUnhealthy: return "Purple"
            case .hazardous: return "Maroon"
            }
        }
        
        var imageName: String {
            switch self {
            case .good: return "cloud-good"
            case .moderate: return "cloud-moderate"
            case .unhealthyForSensitive: return "cloud-sensitive"
            case .unhealthy: return "cloud-unhealthy"
            case .veryUnhealthy: return "cloud-very-unhealthy"
            case .hazardous: return "cloud-hazardous"
            }
        }
        
        var healthImplications: String {
            switch self {
            case .good:
                return "უხეში ნაწილაკების დონე ნორმალურია და არ წარმოადგენს საფრთხეს."
            case .moderate:
                return "უხეში ნაწილაკების დონე მისაღებია. განსაკუთრებით მგრძნობიარე ადამიანებმა იყავით ფრთხილად."
            case .unhealthyForSensitive:
                return "რესპირატორული დაავადებების მქონე ადამიანებმა შეამცირეთ ინტენსიური გარე აქტივობები."
            case .unhealthy:
                return "რესპირატორული პრობლემები შესაძლებელია. შეამცირეთ ინტენსიური გარე აქტივობები."
            case .veryUnhealthy:
                return "თავიდან აიცილეთ ხანგრძლივი ან ინტენსიური გარე აქტივობები. დარჩით შენობის შიგნით."
            case .hazardous:
                return "სახიფათო დონე. დარჩით შენობის შიგნით და შეამცირეთ ფიზიკური აქტივობა."
            }
        }
        
        var maxValue: Double {
            return 604
        }
    }
    
    var aqiCategory: AQICategory {
        let aqi = main.aqi
        switch aqi {
        case 1: return .good
        case 2: return .moderate
        case 3: return .unhealthyForSensitive
        case 4: return .unhealthy
        case 5: return .veryUnhealthy
        default: return .hazardous
        }
    }
    
    var coLevel: COLevel {
        let co = components.co / 1000
        switch co {
        case 0...4.4: return .good
        case 4.5...9.4: return .moderate
        case 9.5...12.4: return .unhealthyForSensitive
        case 12.5...15.4: return .unhealthy
        case 15.5...30.4: return .veryUnhealthy
        default: return .hazardous
        }
    }
    
    var no2Level: NO2Level {
        let no2 = components.no2
        switch no2 {
        case 0...53: return .good
        case 54...100: return .moderate
        case 101...360: return .unhealthyForSensitive
        case 361...649: return .unhealthy
        case 650...1249: return .veryUnhealthy
        default: return .hazardous
        }
    }
    
    var o3Level: O3Level {
        let o3 = components.o3
        switch o3 {
        case 0...54: return .good
        case 55...70: return .moderate
        case 71...85: return .unhealthyForSensitive
        case 86...105: return .unhealthy
        case 106...200: return .veryUnhealthy
        default: return .hazardous
        }
    }
    
    var so2Level: SO2Level {
        let so2 = components.so2
        switch so2 {
        case 0...35: return .good
        case 36...75: return .moderate
        case 76...185: return .unhealthyForSensitive
        case 186...304: return .unhealthy
        case 305...604: return .veryUnhealthy
        default: return .hazardous
        }
    }
    
    var pm25Level: PM25Level {
        let pm25 = components.pm2_5
        switch pm25 {
        case 0...12: return .good
        case 12.1...35.4: return .moderate
        case 35.5...55.4: return .unhealthyForSensitive
        case 55.5...150.4: return .unhealthy
        case 150.5...250.4: return .veryUnhealthy
        default: return .hazardous
        }
    }
    
    var pm10Level: PM10Level {
        let pm10 = components.pm10
        switch pm10 {
        case 0...54: return .good
        case 55...154: return .moderate
        case 155...254: return .unhealthyForSensitive
        case 255...354: return .unhealthy
        case 355...424: return .veryUnhealthy
        default: return .hazardous
        }
    }
    
    var formattedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ka_GE")
        return formatter.string(from: date)
    }
}

