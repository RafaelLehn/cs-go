//
//  MatchDetailViewModel.swift
//  cs-go-match
//
//  Created by Evolua Tech on 07/03/25.
//

import Foundation
import Combine

class MatchDetailViewModel: ObservableObject {
    @Published var match: Match?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var team1: Team?
    @Published var team2: Team?
    
    var apiService: APIService
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func loadTeamDetails() {
        guard let match = match,
              let opponents = match.opponents,
              opponents.count >= 2,
              let team1Id = opponents[0].opponent?.id,
              let team2Id = opponents[1].opponent?.id else {
            return
        }
        
        apiService.fetchTeamDetails(teamId: team1Id)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching team 1: \(error)")
                }
            }, receiveValue: { [weak self] team in
                self?.team1 = team
                print("Successfully loaded team 1")
            })
            .store(in: &cancellables)
        
        apiService.fetchTeamDetails(teamId: team2Id)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching team 2: \(error)")
                }
            }, receiveValue: { [weak self] team in
                self?.team2 = team
                print("Successfully loaded team 2")
            })
            .store(in: &cancellables)
    }
    
    func loadMatchDetails(matchId: Int, preloadedMatch: Match? = nil) {
        isLoading = true
        errorMessage = nil
        
        if let preloadedMatch = preloadedMatch {
            self.match = preloadedMatch
            self.isLoading = false
            self.loadTeamDetails()
            return
        }
        
        apiService.fetchMatchDetails(matchId: matchId)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Error loading match details: \(error)")
                }
            }, receiveValue: { [weak self] match in
                self?.match = match
                print("Successfully loaded match details")
                self?.loadTeamDetails()
            })
            .store(in: &cancellables)
    }
}

