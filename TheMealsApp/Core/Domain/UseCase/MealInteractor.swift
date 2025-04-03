//
//  MealInteractor.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 29/11/22.
//
//
//import Foundation
//import Combine
//
//protocol MealUseCase {
//
//  func getMeal() -> AnyPublisher<MealModel, Error>
//  func getMeal() -> MealModel
//  func updateFavoriteMeal() -> AnyPublisher<MealModel, Error>
////  func getGame() -> AnyPublisher<GameDetailModel, Error>
//
//}
//
//class MealInteractor: MealUseCase {
//
//  private let repository: MealRepositoryProtocol
//  private let meal: MealModel
//  private let game: GameModel
//
//  required init(
//    repository: MealRepositoryProtocol,
//    meal: MealModel,
//    game: GameModel
//  ) {
//    self.repository = repository
//    self.meal = meal
//    self.game = game
//  }
//
//  func getMeal() -> AnyPublisher<MealModel, Error> {
//    return repository.getMeal(by: meal.id)
//  }
//
//  func getMeal() -> MealModel {
//    return meal
//  }
//
//  func updateFavoriteMeal() -> AnyPublisher<MealModel, Error> {
//    return repository.updateFavoriteMeal(by: meal.id)
//  }
//    
//
//  func getGame() -> AnyPublisher<GameDetailModel, Error> {
//      return repository.getGameDetail(by: game.id)
//  }
//    
//  func getGame() -> GameModel {
//        return game
//  }
//}
