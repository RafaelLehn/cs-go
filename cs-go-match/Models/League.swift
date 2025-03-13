//
//  League.swift
//  cs-go-match
//
//  Created by Evolua Tech on 10/03/25.
//

import Foundation
struct League: Identifiable, Decodable {
    let id: Int
    let name: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
    }
}

struct Serie: Identifiable, Decodable {
    let id: Int
    let name: String
    let fullName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
    }
}
