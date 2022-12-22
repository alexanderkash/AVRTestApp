//
//  TopGamesRealm.swift
//  ARVTestApp
//
//  Created by Alexander Kogalovsky on 22.12.22.
//

import Foundation
import RealmSwift

class TopGamesRealm: Object {
    @Persisted(primaryKey: true) var id: String?
    @Persisted var data: List<GameRealm> = List<GameRealm>()
    
    override init() {
        super.init()
    }
    
    convenience init(topGames: TopGames, id: String) {
        self.init()
        self.id = id
        self.data.append(objectsIn: topGames.data.map { GameRealm(game: $0)})
    }
    
    func getGames() -> [Game] {
        return data.map { $0.getGame() }
    }
}

class GameRealm: Object {
    @Persisted var id: String = ""
    @Persisted var name: String = ""
    @Persisted var boxArtUrl: String = ""
    
    override init() {
        super.init()
    }
    
    convenience init(game: Game) {
        self.init()
        self.id = game.id
        self.name = game.name
        self.boxArtUrl = game.boxArtUrl
    }
    
    func getGame() -> Game {
        return Game(id: id, name: name, boxArtUrl: boxArtUrl)
    }
}
