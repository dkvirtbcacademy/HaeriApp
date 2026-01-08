//
//  NetworkManager.swift
//  Haeri
//
//  Created by kv on 08.01.26.
//

import Foundation
import Combine

class NetworkManager: ObservableObject {
    func getData<T: Decodable>(url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw NetworkError.noDataAvailable
        }
        
        var urlRequest = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.wrongStatusCode
            }
            
            if httpResponse.statusCode == 404 {
                throw NetworkError.noResultsFound
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Wrong status code: \(httpResponse.statusCode)")
                throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode, data: data)
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                return decodedObject
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            print("API error: \(error.localizedDescription)")
            throw NetworkError.networkError
        }
    }
    
    
}
