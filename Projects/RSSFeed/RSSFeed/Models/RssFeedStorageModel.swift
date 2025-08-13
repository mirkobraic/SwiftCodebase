//
//  RssFeedStorageModel.swift
//  RSSFeed
//
//  Created by Mirko Braic on 25.12.2023..
//

import Foundation

struct RssFeedStorageModel: Codable {
    var isFavorite: Bool
    var url: String
    var title: String?
    var description: String?
    var imageUrl: String?

    var readArticles: [String] = []

    init(from feed: RssFeed) {
        url = feed.url
        isFavorite = feed.isFavorite
        title = feed.title
        description = feed.description
        imageUrl = feed.imageUrl

        readArticles = feed.items?.filter { $0.isSeen == true }.compactMap { $0.link } ?? []
    }
}
