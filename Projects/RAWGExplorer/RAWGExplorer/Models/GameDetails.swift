//
//  GameDetails.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 13.03.2023..
//

import Foundation
import UIKit

struct GameDetails: Codable {
    let id: Int
    let name: String
    let description: String
    let releaseDate: String
    let backgroundImageUrlString: String
    let websiteUrlString: String
    let rating: Float
    
    var backgroundImage: UIImage? = nil
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, rating
        case releaseDate = "released"
        case websiteUrlString = "website"
        case backgroundImageUrlString = "background_image"
    }
}
