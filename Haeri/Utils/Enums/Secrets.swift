//
//  Secrets.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import Foundation

enum Secrets {
    static var pollutionApiKey: String {
        guard let PollutionKey = Bundle.main.infoDictionary?["POLLUTION_API_KEY"] as? String else {
            fatalError(
                "Missing Pollution API Key"
            )
        }
        return PollutionKey
    }
    
    static var AIApiKey: String {
        guard let AIDevKey = Bundle.main.infoDictionary?["AI_API_KEY"] as? String else {
            fatalError(
                "Missing AI Dev Key"
            )
        }
        return AIDevKey
    }
}
