//
//  GroqAPIResponse.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import Foundation

struct GroqAPIRequest: Codable {
    let model: String
    let messages: [GroqMessage]
    let temperature: Double
    let topP: Double
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case topP = "top_p"
    }
}

struct GroqMessage: Codable {
    let role: String
    let content: String
}

struct GroqAPIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String?
    }
}
