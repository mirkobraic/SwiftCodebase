//
//  RoomDetails.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 25.01.2022..
//

import Foundation

struct WholeRoomDetails: Codable {
    let id: String
    let type: String
    let metadata: String
}

struct RoomDetails {
    var key: String
    var value: String
}
