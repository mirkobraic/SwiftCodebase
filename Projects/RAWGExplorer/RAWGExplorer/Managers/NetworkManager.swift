//
//  NetworkManager.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 12.03.2023..
//

import Foundation
import UIKit

enum RAError: Error {
    case network
    case decoding
    case unknown
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    private let baseUrlString = "https://api.rawg.io/api/"
    private let apiKey = "1a57930852e74d969f774e91ea79a706"
    
    private func constructUrl(fromApiSuffix suffix: String, withQuerryItems querryItems: [URLQueryItem] = []) -> URL? {
        guard var urlComps = URLComponents(string: "https://api.rawg.io/api/\(suffix)") else { return nil }
        urlComps.queryItems = [URLQueryItem(name: "key", value: apiKey)] + querryItems
        return urlComps.url
    }

    func fetchGenres(completion: @escaping (Result<GenresResponse, RAError>) -> Void) {
        guard let url = constructUrl(fromApiSuffix: "genres") else {
            completion(.failure(.network))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(.network))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            if let genresResponse = try? jsonDecoder.decode(GenresResponse.self, from: data) {
                completion(.success(genresResponse))
            } else {
                completion(.failure(.decoding))
            }
        }
        task.resume()
    }
    
    func fetchGames(forGenres genres: [Int], pageSize: Int, completion: @escaping (Result<GamesResponse, RAError>) -> Void) {
        let genreIds = genres.map { String($0) }.joined(separator: ",")
        let querryItems = [URLQueryItem(name: "genres", value: genreIds), URLQueryItem(name: "page_size", value: String(pageSize))]
        guard let url = constructUrl(fromApiSuffix: "games", withQuerryItems: querryItems) else {
            completion(.failure(.network))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(.network))
                return
            }
            let jsonDecoder = JSONDecoder()
            if let gamesResponse = try? jsonDecoder.decode(GamesResponse.self, from: data) {
                completion(.success(gamesResponse))
            } else {
                completion(.failure(.decoding))
            }
        }
        task.resume()
    }
    
    func fetchGames(with nextPageUrl: String, completion: @escaping (Result<GamesResponse, RAError>) -> Void) {
        guard let url = URL(string: nextPageUrl) else {
            completion(.failure(.network))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(.network))
                return
            }
            let jsonDecoder = JSONDecoder()
            if let gamesResponse = try? jsonDecoder.decode(GamesResponse.self, from: data) {
                completion(.success(gamesResponse))
            } else {
                completion(.failure(.decoding))
            }
        }
        task.resume()
    }
    
    func fetchGameDetails(forId id: Int, completion: @escaping (Result<GameDetails, RAError>) -> Void) {
        guard let url = constructUrl(fromApiSuffix: "games/\(String(id))") else {
            completion(.failure(.network))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.network))
                return
            }
            let jsonDecoder = JSONDecoder()
            if let gameDetails = try? jsonDecoder.decode(GameDetails.self, from: data) {
                completion(.success(gameDetails))
            } else {
                completion(.failure(.decoding))
            }
        }
        task.resume()
    }
    
    func fetchImageFrom(urlString: String, completion: @escaping (Result<UIImage, RAError>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                completion(.failure(.network))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure(.decoding))
                return
            }
            
            completion(.success(image))
        }
    }
}
