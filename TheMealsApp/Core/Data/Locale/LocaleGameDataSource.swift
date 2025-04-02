//
//  LocaleGameDataSource.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import Foundation
import RealmSwift
import Combine

protocol LocaleGameDataSourceProtocol {
  func getFavoriteGames() -> AnyPublisher<[GameModel], Error>
  func addToFavorite(from game: GameModel) -> AnyPublisher<Bool, Error>
  func removeFromFavorite(id: Int) -> AnyPublisher<Bool, Error>
  func checkIsFavorite(id: Int) -> AnyPublisher<Bool, Error>
}

final class LocaleGameDataSource: NSObject {
  
  private let realm: Realm?
  
  private init(realm: Realm?) {
    self.realm = realm
  }
  
  static let sharedInstance: (Realm?) -> LocaleGameDataSource = { realmDatabase in
    return LocaleGameDataSource(realm: realmDatabase)
  }
}

extension LocaleGameDataSource: LocaleGameDataSourceProtocol {
  
  func getFavoriteGames() -> AnyPublisher<[GameModel], Error> {
    return Future<[GameModel], Error> { completion in
      if let realm = self.realm {
        let games: Results<GameEntity> = {
          realm.objects(GameEntity.self)
        }()
        
        let gameModels = GameMapper.mapGameEntitiesToDomainModels(
          input: Array(games)
        )
        
        completion(.success(gameModels))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }
  
  func addToFavorite(from game: GameModel) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        do {
          let gameEntity = GameMapper.mapGameModelToEntity(input: game)
          try realm.write {
            realm.add(gameEntity, update: .modified)
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
  
  func removeFromFavorite(id: Int) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        do {
          if let game = realm.object(ofType: GameEntity.self, forPrimaryKey: id) {
            try realm.write {
              realm.delete(game)
            }
            completion(.success(true))
          } else {
            completion(.failure(DatabaseError.requestFailed))
          }
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }
  
  func checkIsFavorite(id: Int) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let realm = self.realm {
        let game = realm.object(ofType: GameEntity.self, forPrimaryKey: id)
        completion(.success(game != nil))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }
}
//
//enum DatabaseError: LocalizedError {
//  case invalidInstance
//  case requestFailed
//  
//  var errorDescription: String? {
//    switch self {
//    case .invalidInstance: return "Database can't instance."
//    case .requestFailed: return "Your request failed."
//    }
//  }
//}
