//
//  RemoteGameDataSource.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import Foundation
import Combine

protocol RemoteGameDataSourceProtocol {
  func getGames() -> AnyPublisher<[GameModel], Error>
  func getGameDetail(id: Int) -> AnyPublisher<GameModel, Error>
  func searchGames(query: String) -> AnyPublisher<[GameModel], Error>
}

final class RemoteGameDataSource: NSObject {
  
  private override init() { }
  
  static let sharedInstance: RemoteGameDataSource = RemoteGameDataSource()
  
  private let baseUrl = "https://api.rawg.io/api"
  private let apiKey = "YOUR_API_KEY" // Add your RAWG API key
  
  private func createRequest(endpoint: String, queryParams: [String: String] = [:]) -> URLRequest {
    var components = URLComponents(string: "\(baseUrl)/\(endpoint)")!
    var queryItems = [URLQueryItem(name: "key", value: apiKey)]
    
    for (key, value) in queryParams {
      queryItems.append(URLQueryItem(name: key, value: value))
    }
    
    components.queryItems = queryItems
    
    return URLRequest(url: components.url!)
  }
}

extension RemoteGameDataSource: RemoteGameDataSourceProtocol {
  
  func getGames() -> AnyPublisher<[GameModel], Error> {
    let request = createRequest(endpoint: "games")
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: GamesResponse.self, decoder: JSONDecoder())
      .map { response in
        GameMapper.mapGameResponsesToDomainModels(input: response.results)
      }
      .eraseToAnyPublisher()
  }
  
  func getGameDetail(id: Int) -> AnyPublisher<GameModel, Error> {
    let request = createRequest(endpoint: "games/\(id)")
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: GameDetailResponse.self, decoder: JSONDecoder())
      .map { response in
        GameMapper.mapDetailResponseToDomainModel(input: response)
      }
      .eraseToAnyPublisher()
  }
  
  func searchGames(query: String) -> AnyPublisher<[GameModel], Error> {
    let request = createRequest(endpoint: "games", queryParams: ["search": query])
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: GamesResponse.self, decoder: JSONDecoder())
      .map { response in
        GameMapper.mapGameResponsesToDomainModels(input: response.results)
      }
      .eraseToAnyPublisher()
  }
}
