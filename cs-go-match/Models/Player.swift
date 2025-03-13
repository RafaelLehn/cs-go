//
//  Player.swift
//  cs-go-match
//
//  Created by Evolua Tech on 10/03/25.
//

import Foundation

struct Player: Identifiable, Decodable {
    let id: Int
    let name: String
    let firstName: String?
    let lastName: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case imageUrl = "image_url"
    }
    
    var fullName: String {
        if let firstName = firstName, let lastName = lastName {
            return "\(firstName) \(lastName)"
        }
        return name
    }
}

