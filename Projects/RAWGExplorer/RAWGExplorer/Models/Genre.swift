//
//  Genre.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 12.03.2023..
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
    let gamesCount: Int?
    let imageBackgroundUrlString: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name
        case gamesCount = "games_count"
        case imageBackgroundUrlString = "image_background"
    }
}

struct GenresResponse: Codable {
    let count: Int
    let results: [Genre]
}
