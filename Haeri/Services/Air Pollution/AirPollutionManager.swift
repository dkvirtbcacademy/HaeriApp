//
//  AirPollutionManager.swift
//  Haeri
//
//  Created by kv on 07.01.26.
//

import Foundation
import Combine

@MainActor
final class AirPollutionManager: ObservableObject, AlertHandler {
    
    @Published private var cities = ["Tbilisi", "Rustavi"]
    @Published var airPollutionData: [CityAirPollution] = []
    @Published var currentCityData: CityAirPollution?
    @Published var searchResults: [GeoResponse] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    
    private let networkManager: NetworkManager
    private let apiKey = "0d42305cce9b217d3a28f376eb166e2d"
    private let baseURL = "https://api.openweathermap.org/data/2.5/air_pollution"
    private let geoURL = "https://api.openweathermap.org/geo/1.0"
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchChoosenCitiesData() async {
        isLoading = true
        defer { isLoading = false }
        
        for city in cities {
            do {
                if let coord = try await fetchCoordinates(city: city) {
                    try await fetchNewCity(
                        lat: String(coord.lat),
                        long: String(coord.lon),
                        cityName: city
                    )
                }
            } catch let error as AirPollutionError {
                handleAirPollutionError(error)
            } catch let error as NetworkError {
                handleNetworkError(error, context: city)
            } catch {
                handleNetworkError(.networkError)
            }
        }
    }
    
    func fetchCoordinates(city: String) async throws -> (lat: Double, lon: Double)? {
        let urlString = "\(geoURL)/direct?q=\(city)&limit=1&appid=\(apiKey)"
        
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidURL
        }
        
        let results: [GeoResponse] = try await networkManager.getData(url: encodedString)
        
        guard let first = results.first else {
            throw AirPollutionError.coordinatesNotFound(cityName: city)
        }
        
        return (first.lat, first.lon)
    }
    
    func fetchNewCity(lat: String, long: String, cityName: String) async throws {
        if let existingCity = airPollutionData.first(where: { $0.city == cityName }) {
            if currentCityData?.city != existingCity.city {
                currentCityData = existingCity
            }
            return
        }
        
        let urlString = "\(baseURL)?lat=\(lat)&lon=\(long)&appid=\(apiKey)"
        
        let pollutionResponse: AirPollutionResponse = try await networkManager.getData(url: urlString)
        
        let cityData = CityAirPollution(
            city: cityName,
            response: pollutionResponse
        )
        
        currentCityData = cityData
        airPollutionData.append(cityData)
    }
    
    func findCity(city: String) async {
        isLoading = true
        defer { isLoading = false }
        
        let urlString = "\(geoURL)/direct?q=\(city)&limit=5&appid=\(apiKey)"
        
        do {
            guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                throw NetworkError.invalidURL
            }
            
            let results: [GeoResponse] = try await networkManager.getData(url: encodedString)
            
            if results.isEmpty {
                throw NetworkError.noResultsFound
            }
            
            searchResults = results
            
        } catch let error as NetworkError {
            handleNetworkError(error, context: city)
        } catch {
            handleNetworkError(.networkError)
        }
    }
    
    func addChoosenCity(city: String, lat: Double, lon: Double) async {
        if !cities.contains(city) {
            cities.append(city)
            
            do {
                try await fetchNewCity(
                    lat: String(lat),
                    long: String(lon),
                    cityName: city
                )
            } catch let error as NetworkError {
                handleNetworkError(error, context: city)
                cities.removeAll { $0 == city }
            } catch let error as AirPollutionError {
                handleAirPollutionError(error)
                cities.removeAll { $0 == city }
            } catch {
                handleNetworkError(.networkError)
                cities.removeAll { $0 == city }
            }
        }
    }
    
    func removeChoosenCity(index: Int) {
        guard index < cities.count else { return }
        let cityName = cities[index]
        cities.remove(at: index)
        airPollutionData.removeAll(where: { $0.city == cityName })
    }
}
