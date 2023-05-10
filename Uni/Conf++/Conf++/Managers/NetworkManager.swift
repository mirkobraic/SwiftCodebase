//
//  NetworkManager.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 26.01.2022..
//

//import Alamofire
import UIKit

enum NetworkError: Error {
    case badURL
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "http://192.168.174.152:8080/api/"
    
    private init() { }
    
    func postUserEntered(location locationID: String, userID: String) {
        //Request Body
        let json: [String: Any] = ["locationId": locationID,
                                  "userId": userID]
         
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
         
        // create post request
        let url = URL(string: baseURL + "userPerLocation/connect")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
         
        // insert json data to the request
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()

    }
    
    func postUserLeft(location locationID: String, userID: String) {
        //Request Body
        let json: [String: Any] = ["locationId": locationID,
                                  "userId": userID]
         
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
         
        // create post request
        let url = URL(string: baseURL + "userPerLocation/disconnect")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
         
        // insert json data to the request
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }
    
    func getLocationMetadata(locationID: String, completion: ((Result<[RoomDetails], NetworkError>) -> Void)?) {
        let url = URL(string: baseURL + "/location/\(locationID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let wholeRoom = try? jsonDecoder.decode(WholeRoomDetails.self, from: data) else {
                print("COULDNT DECODE WHOLE ROOM")
                return;
            }
            
            guard let metadataData = wholeRoom.metadata.data(using: .utf8) else {
                print("COULDNT CREATE METADATA DATA")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: metadataData, options: [])
            
            print(responseJSON as! [String: Any])
            if let responseJSON = responseJSON as? [String: String] {
                var roomDetails: [RoomDetails] = []
                
                roomDetails.append(RoomDetails(key: "Type", value: wholeRoom.type))
                
                let sortedKeys = Array(responseJSON.keys).sorted(by: <)
                for key in sortedKeys {
                    roomDetails.append(RoomDetails(key: key, value: responseJSON[key] ?? ""))
                }
                print(responseJSON)
                completion?(.success(roomDetails))
            }
            
        }
        task.resume()
    }
    
    func getCurrentNumberOfUsers(for locationID: String, completion: ((Result<Int, NetworkError>) -> Void)?) {
        // TODO: ne triba
    }
}
