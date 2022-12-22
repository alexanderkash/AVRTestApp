//
//  MainService.swift
//  ARVTestApp
//
//  Created by Alexander Kogalovsky on 21.12.22.
//

import Foundation

final class ContentLoader {
    
    static let shared = ContentLoader()
    
    enum Keys {
        static let topGames = "topGames"
    }
    
    private init() {}
    
    func loadGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        NetworkService.shared.fetchGames { result in
            switch result {
            case .success(let topGames):
                completion(.success(topGames.data))
                RealmStorageService.shared.update(object: TopGamesRealm(topGames: topGames, id: Keys.topGames))
            case .failure:
                guard let topGamesRealm = RealmStorageService.shared.object(byId: Keys.topGames,
                                                                            type: TopGamesRealm.self) as? TopGamesRealm
                else {
                    completion(.failure(RealmStorageError.retrievingError))
                    return
                }
                let games = topGamesRealm.getGames()
                completion(.success(games))
            }
        }
    }
    
    func loadStreams(gameId: String, completion: @escaping (Result<[Stream], Error>) -> Void) {
        NetworkService.shared.fetchStreams(gameId: gameId) { result in
            switch result {
            case .success(let streams):
                completion(.success(streams.data))
                RealmStorageService.shared.update(object: StreamsRealm(streams: streams, id: gameId))
            case .failure:
                guard let streamsRealm = RealmStorageService.shared.object(byId: gameId,
                                                                           type: StreamsRealm.self) as? StreamsRealm
                else {
                    completion(.failure(RealmStorageError.retrievingError))
                    return
                }
                let streams = streamsRealm.getStreams()
                completion(.success(streams))
            }
        }
    }
}
