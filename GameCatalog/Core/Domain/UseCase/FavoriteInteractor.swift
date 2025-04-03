//
//  FavoriteUseCase.swift
//  GameCatalog
//
//  Created on 03/04/25.
//

import Foundation
import Combine

protocol FavoriteUseCase {
  func getFavoriteGames() -> AnyPublisher<[GameModel], Error>
}

class FavoriteInteractor: FavoriteUseCase {
  
  private let repository: GameRepositoryProtocol
  
  required init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func getFavoriteGames() -> AnyPublisher<[GameModel], Error> {
    return repository.getFavoriteGames()
  }
}
