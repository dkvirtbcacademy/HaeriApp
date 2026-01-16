//
//  UserDefaultsManager.swift
//  Haeri
//
//  Created by kv on 16.01.26.
//

import Foundation

final class UserDefaultsManager {
    
    private enum Keys {
        static let cities = "saved_cities"
    }
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func saveCities(_ cities: [String]) {
        defaults.set(cities, forKey: Keys.cities)
    }
    
    func loadCities() -> [String]? {
        return defaults.stringArray(forKey: Keys.cities)
    }
    
    func clearCities() {
        defaults.removeObject(forKey: Keys.cities)
    }
    
    func save<T: Encodable>(_ value: T, forKey key: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        defaults.set(data, forKey: key)
    }
    
    func load<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    func clearAll() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleIdentifier)
        }
    }
}
