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
            let nh3: Double
        }
    }
}
