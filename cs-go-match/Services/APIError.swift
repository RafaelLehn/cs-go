//
//  APIError.swift
//  cs-go-match
//
//  Created by Evolua Tech on 10/03/25.
//

import Foundation

struct APIError: Codable {
    let error: String
    let message: String
}
