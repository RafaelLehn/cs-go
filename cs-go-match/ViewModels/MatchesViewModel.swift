//
//  MatchesViewModel.swift
//  cs-go-match
//
//  Created by Evolua Tech on 07/03/25.
//
import Foundation
import Combine

class MatchesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var apiService: APIService
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIService = APIService(apiKey: "v7fBmZOryI15ZcIIb-L_rRiH3riGqsSdNgXxGQkEuZlF6qFF5e0")) {
        self.apiService = apiService
    }
    
    func loadMatches() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchMatches()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Error loading matches: \(error)")
                }
            }, receiveValue: { [weak self] matches in
                self?.matches = self?.sortMatches(matches) ?? []
                print("Successfully loaded \(matches.count) matches")
            })
            .store(in: &cancellables)
    }
    
    private func sortMatches(_ matches: [Match]) -> [Match] {
        return matches.sorted { match1, match2 in
            // Live matches first
            if match1.isLive && !match2.isLive {
                return true
            }
            if !match1.isLive && match2.isLive {
                return false
            }
            
            if let date1 = match1.beginAt, let date2 = match2.beginAt {
                return date1 < date2
            }
            
            return false
        }
    }
}

