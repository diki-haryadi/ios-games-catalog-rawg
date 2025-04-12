//
//  DetailUseCase.swift
//  GameCatalog
//
//  Created on 03/04/25.
//

import Foundation
import Combine

protocol DetailUseCase {
  func getGameDetail() -> AnyPublisher<GameModel, Error>
  func addToFavorite() -> AnyPublisher<Bool, Error>
  func removeFromFavorite() -> AnyPublisher<Bool, Error>
  func checkIsFavorite() -> AnyPublisher<Bool, Error>
  func getGameId() -> Int
}

class DetailInteractor: DetailUseCase {
  private let repository: GameRepositoryProtocol
  private let gameId: Int
  
  required init(repository: GameRepositoryProtocol, gameId: Int) {
    self.repository = repository
    self.gameId = gameId
  }
  
  func getGameDetail() -> AnyPublisher<GameModel, Error> {
    return repository.getGameDetail(id: gameId)
  }
  
  func addToFavorite() -> AnyPublisher<Bool, Error> {
    return repository.getGameDetail(id: gameId)
      .flatMap { game in
        self.repository.addToFavorite(game: game)
      }
      .eraseToAnyPublisher()
  }
  
  func removeFromFavorite() -> AnyPublisher<Bool, Error> {
    return repository.removeFromFavorite(id: gameId)
  }
  
  func checkIsFavorite() -> AnyPublisher<Bool, Error> {
    return repository.checkIsFavorite(id: gameId)
  }
  
  func getGameId() -> Int {
    return gameId
  }
}
