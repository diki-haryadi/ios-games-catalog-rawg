//
//  LocaleDataStore.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 22/11/22.
//

import Foundation
import RealmSwift
import Combine

protocol LocaleDataSourceProtocol: AnyObject {

  func getCategories() -> AnyPublisher<[CategoryEntity], Error>
  func addCategories(from categories: [CategoryEntity]) -> AnyPublisher<Bool, Error>

  func getMeal(by idMeal: String) -> AnyPublisher<MealEntity, Error>
  func getMeals(by category: String) -> AnyPublisher<[MealEntity], Error>
  func getMealsBy(_ title: String) -> AnyPublisher<[MealEntity], Error>
  func addMeals(by category: String, from meals: [MealEntity]) -> AnyPublisher<Bool, Error>
  func addMealsBy(_ title: String, from meals: [MealEntity]) -> AnyPublisher<Bool, Error>
  func updateMeal(by idMeal: String, meal: MealEntity) -> AnyPublisher<Bool, Error>

  func addIngredients(from ingredients: [IngredientEntity]) -> AnyPublisher<Bool, Error>

  func getFavoriteMeals() -> AnyPublisher<[MealEntity], Error>
  func updateFavoriteMeal(by idMeal: String) -> AnyPublisher<MealEntity, Error>

  func getGame(by id: Int) -> AnyPublisher<GameEntity, Error>
  func getGames(page: Int, pageSize: Int, search: String?) -> AnyPublisher<[GameEntity], Error>
  func addGames(from games: [GameEntity]) -> AnyPublisher<Bool, Error>
  func updateGame(by id: Int, game: GameEntity) -> AnyPublisher<Bool, Error>
  func getFavoriteGames() -> AnyPublisher<[GameEntity], Error>
  func updateFavoriteGame(by id: Int) -> AnyPublisher<GameEntity, Error>

}

final class LocaleDataSource: NSObject {

  private let realm: Realm?

  private init(realm: Realm?) {
    self.realm = realm
  }

  static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDatabase in
    return LocaleDataSource(realm: realmDatabase)
  }

}

extension LocaleDataSource: LocaleDataSourceProtocol {

  func getGame(by id: Int) -> AnyPublisher<GameEntity, Error> {
    return Future<GameEntity, Error> { completion in
      if let realm = self.realm {
        let games: Results<GameEntity> = {
          realm.objects(GameEntity.self)
            .filter("id = %@", id)
        }()

        guard let game = games.first else {
          completion(.failure(DatabaseError.requestFailed))
          return
        }

        completion(.success(game))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func getGames(page: Int = 1, pageSize: Int = 10, search: String? = nil) -> AnyPublisher<[GameEntity], Error> {
    return Future<[GameEntity], Error> { completion in
      if let realm = self.realm {
        var games: Results<GameEntity>
        if let searchQuery = search {
          games = realm.objects(GameEntity.self)
            .filter("title contains[c] %@", searchQuery)
            .sorted(byKeyPath: "title", ascending: true)
        } else {
          games = realm.objects(GameEntity.self)
            .sorted(byKeyPath: "title", ascending: true)
        }
        
        let startIndex = (page - 1) * pageSize
        let endIndex = min(startIndex + pageSize, games.count)
        let paginatedGames = Array(games[startIndex..<endIndex])
        completion(.success(paginatedGames))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func addGames(from games: [GameEntity]) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        do {
          try realm.write {
            for game in games {
              realm.add(game, update: .modified)
            }
            completion(.success(true))
          }
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func updateGame(by id: Int, game: GameEntity) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm, let gameEntity = {
        realm.objects(GameEntity.self).filter("id = %@", id)
      }().first {
        do {
          try realm.write {
            gameEntity.setValue(game.name, forKey: "title")
            gameEntity.setValue(game.released, forKey: "released")
            gameEntity.setValue(game.backgroundImage, forKey: "backgroundImage")
            gameEntity.setValue(game.rating, forKey: "rating")
            gameEntity.setValue(game.ratingTop, forKey: "ratingTop")
            gameEntity.setValue(game.favorite, forKey: "favorite")
          }
          completion(.success(true))
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func getFavoriteGames() -> AnyPublisher<[GameEntity], Error> {
    return Future<[GameEntity], Error> { completion in
      if let realm = self.realm {
        let gameEntities = {
          realm.objects(GameEntity.self)
            .filter("favorite = %@", true)
            .sorted(byKeyPath: "title", ascending: true)
        }()
        completion(.success(gameEntities.toArray(ofType: GameEntity.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func updateFavoriteGame(by id: Int) -> AnyPublisher<GameEntity, Error> {
    return Future<GameEntity, Error> { completion in
      if let realm = self.realm, let gameEntity = {
        realm.objects(GameEntity.self).filter("id = %@", id)
      }().first {
        do {
          try realm.write {
            gameEntity.setValue(!gameEntity.favorite, forKey: "favorite")
          }
          completion(.success(gameEntity))
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }


  func getCategories() -> AnyPublisher<[CategoryEntity], Error> {
    return Future<[CategoryEntity], Error> { completion in
      if let realm = self.realm {
        let categories: Results<CategoryEntity> = {
          realm.objects(CategoryEntity.self)
            .sorted(byKeyPath: "title", ascending: true)
        }()
        completion(.success(categories.toArray(ofType: CategoryEntity.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func addCategories(
    from categories: [CategoryEntity]
  ) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        do {
          try realm.write {
            for category in categories {
              realm.add(category, update: .all)
            }
            completion(.success(true))
          }
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func getMeal(
    by idMeal: String
  ) -> AnyPublisher<MealEntity, Error> {
    return Future<MealEntity, Error> { completion in
      if let realm = self.realm {
        let meals: Results<MealEntity> = {
          realm.objects(MealEntity.self)
            .filter("id = '\(idMeal)'")
        }()

        guard let meal = meals.first else {
          completion(.failure(DatabaseError.requestFailed))
          return
        }

        completion(.success(meal))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func getMeals(
    by category: String
  ) -> AnyPublisher<[MealEntity], Error> {
    return Future<[MealEntity], Error> { completion in
      if let realm = self.realm {
        let meals: Results<MealEntity> = {
          realm.objects(MealEntity.self)
            .filter("category = '\(category)'")
            .sorted(byKeyPath: "title", ascending: true)
        }()
        completion(.success(meals.toArray(ofType: MealEntity.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func getMealsBy(
    _ title: String
  ) -> AnyPublisher<[MealEntity], Error> {
    return Future<[MealEntity], Error> { completion in
      if let realm = self.realm {
        let meals: Results<MealEntity> = {
          realm.objects(MealEntity.self)
            .filter("title contains[c] %@", title)
            .sorted(byKeyPath: "title", ascending: true)
        }()
        completion(.success(meals.toArray(ofType: MealEntity.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func addMeals(
    by category: String,
    from meals: [MealEntity]
  ) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        do {
          try realm.write {
            for meal in meals {
              realm.add(meal, update: .all)
            }
            completion(.success(true))
          }
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func addMealsBy(
    _ title: String,
    from meals: [MealEntity]
  ) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        do {
          try realm.write {
            for meal in meals {
              if let mealEntity = realm.object(ofType: MealEntity.self, forPrimaryKey: meal.id) {
                if mealEntity.title == meal.title {
                  meal.favorite = mealEntity.favorite
                  realm.add(meal, update: .all)
                } else {
                  realm.add(meal)
                }
              } else {
                realm.add(meal)
              }
            }
          }
          completion(.success(true))
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func updateMeal(
    by idMeal: String,
    meal: MealEntity
  ) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm, let mealEntity = {
        realm.objects(MealEntity.self).filter("id = '\(idMeal)'")
      }().first {
        do {
          try realm.write {
            mealEntity.setValue(meal.area, forKey: "area")
            mealEntity.setValue(meal.instructions, forKey: "instructions")
            mealEntity.setValue(meal.tag, forKey: "tag")
            mealEntity.setValue(meal.youtube, forKey: "youtube")
            mealEntity.setValue(meal.source, forKey: "source")
            mealEntity.setValue(meal.favorite, forKey: "favorite")
            mealEntity.setValue(meal.ingredients, forKey: "ingredients")
          }
          completion(.success(true))

        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func addIngredients(
    from ingredients: [IngredientEntity]
  ) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        do {
          try realm.write {
            for ingredient in ingredients {
              realm.add(ingredient)
            }
            completion(.success(true))
          }
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func getFavoriteMeals() -> AnyPublisher<[MealEntity], Error> {
    return Future<[MealEntity], Error> { completion in
      if let realm = self.realm {
        let mealEntities = {
          realm.objects(MealEntity.self)
            .filter("favorite = \(true)")
            .sorted(byKeyPath: "title", ascending: true)
        }()
        completion(.success(mealEntities.toArray(ofType: MealEntity.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func updateFavoriteMeal(
    by idMeal: String
  ) -> AnyPublisher<MealEntity, Error> {
    return Future<MealEntity, Error> { completion in
      if let realm = self.realm, let mealEntity = {
        realm.objects(MealEntity.self).filter("id = '\(idMeal)'")
      }().first {
        do {
          try realm.write {
            mealEntity.setValue(!mealEntity.favorite, forKey: "favorite")
          }
          completion(.success(mealEntity))
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

}

extension Results {

  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }

}
