//
//  Stream.swift
//  ARVTestApp
//
//  Created by Alexander Kogalovsky on 21.12.22.
//

import Foundation

struct Streams: Codable {
    let data: [Stream]
}

struct Stream: Codable {
    let title: String
    let thumbnailUrl: String
}
