//
//  Match.swift
//  cs-go-match
//
//  Created by Evolua Tech on 07/03/25.
//
import Foundation

struct Match: Identifiable, Decodable {
    let id: Int
    let beginAt: Date?
    let name: String?
    let status: MatchStatus
    let league: League?
    let serie: Serie?
    let opponents: [Opponent]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case beginAt = "begin_at"
        case name
        case status
        case league
        case serie
        case opponents
    }
    
    var isLive: Bool {
        return status == .running
    }
    
    var isScheduled: Bool {
        return status == .notStarted
    }
    
    var isEnded: Bool {
        return status == .finished
    }
    
    var leagueName: String {
        return league?.name ?? serie?.name ?? "Unknown League"
    }
}

enum MatchStatus: String, Decodable {
    case notStarted = "not_started"
    case running = "running"
    case finished = "finished"
    case canceled = "canceled"
    case postponed = "postponed"
    
    case unknown = ""
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let status = try container.decode(String.self)
        
        self = MatchStatus(rawValue: status) ?? .unknown
    }
    
    var displayText: String {
        switch self {
        case .notStarted:
            return "Agendado"
        case .running:
            return "AGORA"
        case .finished:
            return "Finalizado"
        case .canceled:
            return "Cancelado"
        case .postponed:
            return "Adiado"
        case .unknown:
            return "Desconhecido"
        }
    }
}




