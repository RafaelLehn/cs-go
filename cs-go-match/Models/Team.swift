//
//  Team.swift
//  cs-go-match
//
//  Created by Evolua Tech on 10/03/25.
//

import Foundation

struct Team: Identifiable, Decodable {
    let id: Int
    let name: String
    let imageUrl: String?
    let acronym: String?
    let players: [Player]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case acronym
        case players
    }
}

struct Opponent: Decodable {
    let type: String?
    let opponent: Team?
}
