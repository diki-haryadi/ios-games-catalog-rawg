//
//  SearchUseCase.swift
//  GameCatalog
//
//  Created on 03/04/25.
//

import Foundation
import Combine

protocol SearchUseCase {
  func searchGames(query: String) -> AnyPublisher<[GameModel], Error>
}

class SearchInteractor: SearchUseCase {
  
  private let repository: GameRepositoryProtocol
  
  required init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func searchGames(query: String) -> AnyPublisher<[GameModel], Error> {
    return repository.searchGames(query: query)
  }
}
