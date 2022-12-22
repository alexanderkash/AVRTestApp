//
//  TopGames.swift
//  ARVTestApp
//
//  Created by Alexander Kogalovsky on 21.12.22.
//

import Foundation

struct TopGames: Codable {
    let data: [Game]
}

struct Game: Codable {
    let id: String
    let name: String
    let boxArtUrl: String
}
