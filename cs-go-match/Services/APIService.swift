//
//  APIService.swift
//  cs-go-match
//
//  Created by Evolua Tech on 07/03/25.
//

import Foundation
import Combine

class APIService: ObservableObject {
    private let baseURL = "https://api.pandascore.co/csgo"
    private let apiKey: String
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchMatches() -> AnyPublisher<[Match], Error> {
        // Try a simpler approach without the range parameter
        var urlComponents = URLComponents(string: "\(baseURL)/matches")!
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "50"), // Get more matches
            URLQueryItem(name: "token", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print("Request URL: \(url.absoluteString)")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                // Print the raw JSON for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString.prefix(500))") // Print first 500 chars to avoid console overflow
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    
                    // Check for error responses
                    if httpResponse.statusCode != 200 {
                        // Try to decode the error message
                        if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                            throw NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [
                                NSLocalizedDescriptionKey: apiError.message
                            ])
                        } else {
                            throw NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [
                                NSLocalizedDescriptionKey: "Unknown error occurred"
                            ])
                        }
                    }
                }
                
                return data
            }
            .decode(type: [Match].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchMatchDetails(matchId: Int) -> AnyPublisher<Match, Error> {
        var urlComponents = URLComponents(string: "\(baseURL)/matches/\(matchId)")!
        urlComponents.queryItems = [
            URLQueryItem(name: "token", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print("Match Details Request URL: \(url.absoluteString)")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                // Print the raw JSON for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Match Details Raw JSON: \(jsonString.prefix(500))")
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    
                    // Check for error responses
                    if httpResponse.statusCode != 200 {
                        // Try to decode the error message
                        if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                            throw NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [
                                NSLocalizedDescriptionKey: apiError.message
                            ])
                        } else {
                            throw NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [
                                NSLocalizedDescriptionKey: "Unknown error occurred"
                            ])
                        }
                    }
                }
                
                return data
            }
            .decode(type: Match.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchTeamDetails(teamId: Int) -> AnyPublisher<Team, Error> {
        var urlComponents = URLComponents(string: "https://api.pandascore.co/teams/\(teamId)")!
        urlComponents.queryItems = [
            URLQueryItem(name: "token", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print("Team Details Request URL: \(url.absoluteString)")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                // Print the raw JSON for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Team Details Raw JSON: \(jsonString.prefix(500))")
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    
                    // Check for error responses
                    if httpResponse.statusCode != 200 {
                        // Try to decode the error message
                        if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                            throw NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [
                                NSLocalizedDescriptionKey: apiError.message
                            ])
                        } else {
                            throw NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [
                                NSLocalizedDescriptionKey: "Unknown error occurred"
                            ])
                        }
                    }
                }
                
                return data
            }
            .decode(type: Team.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

