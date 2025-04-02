//
//  GameRepository.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
  func getGames() -> AnyPublisher<[GameModel], Error>
  func getGameDetail(id: Int) -> AnyPublisher<GameModel, Error>
  func searchGames(query: String) -> AnyPublisher<[GameModel], Error>
  func getFavoriteGames() -> AnyPublisher<[GameModel], Error>
  func addToFavorite(game: GameModel) -> AnyPublisher<Bool, Error>
  func removeFromFavorite(id: Int) -> AnyPublisher<Bool, Error>
  func checkIsFavorite(id: Int) -> AnyPublisher<Bool, Error>
}

final class GameRepository: NSObject {
  
  typealias GameInstance = (LocaleGameDataSource, RemoteGameDataSource) -> GameRepository
  
  fileprivate let remote: RemoteGameDataSource
  fileprivate let locale: LocaleGameDataSource
  
  private init(locale: LocaleGameDataSource, remote: RemoteGameDataSource) {
    self.locale = locale
    self.remote = remote
  }
  
  static let sharedInstance: GameInstance = { localeRepo, remoteRepo in
    return GameRepository(locale: localeRepo, remote: remoteRepo)
  }
}

extension GameRepository: GameRepositoryProtocol {
  
  func getGames() -> AnyPublisher<[GameModel], Error> {
    return self.remote.getGames()
      .map { $0.map { game in
        var newGame = game
        self.locale.checkIsFavorite(id: game.id)
          .sink(receiveCompletion: { _ in },
                receiveValue: { isFavorite in
            newGame = GameModel(
              id: game.id,
              name: game.name,
              released: game.released,
              backgroundImage: game.backgroundImage,
              rating: game.rating,
              ratingCount: game.ratingCount,
              description: game.description,
              genres: game.genres,
              platforms: game.platforms,
              isFavorite: isFavorite
            )
          })
          .cancel()
        return newGame
      }}
      .eraseToAnyPublisher()
  }
  
  func getGameDetail(id: Int) -> AnyPublisher<GameModel, Error> {
    return self.remote.getGameDetail(id: id)
      .flatMap { game -> AnyPublisher<GameModel, Error> in
        return self.locale.checkIsFavorite(id: game.id)
          .map { isFavorite in
            return GameModel(
              id: game.id,
              name: game.name,
              released: game.released,
              backgroundImage: game.backgroundImage,
              rating: game.rating,
              ratingCount: game.ratingCount,
              description: game.description,
              genres: game.genres,
              platforms: game.platforms,
              isFavorite: isFavorite
            )
          }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  func searchGames(query: String) -> AnyPublisher<[GameModel], Error> {
    return self.remote.searchGames(query: query)
      .map { $0.map { game in
        var newGame = game
        self.locale.checkIsFavorite(id: game.id)
          .sink(receiveCompletion: { _ in },
                receiveValue: { isFavorite in
            newGame = GameModel(
              id: game.id,
              name: game.name,
              released: game.released,
              backgroundImage: game.backgroundImage,
              rating: game.rating,
              ratingCount: game.ratingCount,
              description: game.description,
              genres: game.genres,
              platforms: game.platforms,
              isFavorite: isFavorite
            )
          })
          .cancel()
        return newGame
      }}
      .eraseToAnyPublisher()
  }
  
  func getFavoriteGames() -> AnyPublisher<[GameModel], Error> {
    return self.locale.getFavoriteGames()
      .eraseToAnyPublisher()
  }
  
  func addToFavorite(game: GameModel) -> AnyPublisher<Bool, Error> {
    return self.locale.addToFavorite(from: game)
      .eraseToAnyPublisher()
  }
  
  func removeFromFavorite(id: Int) -> AnyPublisher<Bool, Error> {
    return self.locale.removeFromFavorite(id: id)
      .eraseToAnyPublisher()
  }
  
  func checkIsFavorite(id: Int) -> AnyPublisher<Bool, Error> {
    return self.locale.checkIsFavorite(id: id)
      .eraseToAnyPublisher()
  }
}
