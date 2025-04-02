//
//  HomeInteractor.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 22/11/22.
//

import Foundation
import Combine

protocol HomeUseCase {

  func getCategories() -> AnyPublisher<[CategoryModel], Error>
  func getGames(page: Int, pageSize: Int, search: String?) -> AnyPublisher<[GameModel], Error>

}

class HomeInteractor: HomeUseCase {

  private let repository: MealRepositoryProtocol

  required init(repository: MealRepositoryProtocol) {
    self.repository = repository
  }

  func getCategories() -> AnyPublisher<[CategoryModel], Error> {
    return repository.getCategories()
  }

  func getGames(page: Int = 1, pageSize: Int = 10, search: String? = nil) -> AnyPublisher<[GameModel], Error> {
    return repository.getGames(page: page, pageSize: pageSize, search: search)
  }

}
