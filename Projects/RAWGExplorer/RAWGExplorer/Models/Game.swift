//
//  Game.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 12.03.2023..
//

import Foundation

struct Game: Codable {
    let id: Int
    let name: String
    let backgroundImageUrlString: String
    let genres: [Genre]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, genres
        case backgroundImageUrlString = "background_image"
    }
}

struct GamesResponse: Codable {
    let count: Int
    let next: String
    let results: [Game]
}
