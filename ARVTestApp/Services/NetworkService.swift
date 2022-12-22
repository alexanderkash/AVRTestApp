//
//  NetworkManager.swift
//  ARVTestApp
//
//  Created by Alexander Kogalovsky on 21.12.22.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    func fetchGames(completion: @escaping (Result<TopGames, Error>) -> Void) {
        
        let urlString = "https://api.twitch.tv/helix/games/top"
        guard let url = URL(string: urlString) else { return }
        
        let headers: [String: String] = ["Client-Id": "dqa46yk7jedbmjwpk35hyj4isv3dqb",
                                         "Authorization": "Bearer fpwtd30kkaa5lsjgoe9814dra5nxc4"]
       
        fetchData(url: url, httpMethod: .get, headers: headers) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let topGames = try decoder.decode(TopGames.self, from: data)
                    completion(.success(topGames))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchStreams(gameId: String, completion: @escaping (Result<Streams, Error>) -> Void) {
        
        let urlString = "https://api.twitch.tv/helix/streams"
        guard var components = URLComponents(string: urlString) else { return }
        components.queryItems = [URLQueryItem(name: "game_id", value: gameId)]
        
        guard let url = components.url else { return }
        
        let headers: [String: String] = ["Client-Id": "dqa46yk7jedbmjwpk35hyj4isv3dqb",
                                         "Authorization": "Bearer fpwtd30kkaa5lsjgoe9814dra5nxc4"]
        
        fetchData(url: url, httpMethod: .get, headers: headers) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let streams = try decoder.decode(Streams.self, from: data)
                    completion(.success(streams))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchData(url: URL,
                           httpMethod: HTTPMethod,
                           headers: [String: String],
                           completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.connectionError(error)))
                }
                return
            }
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200
            else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case connectionError(Error)
    case noData
}
