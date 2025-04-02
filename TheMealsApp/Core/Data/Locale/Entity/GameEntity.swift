//
//  GameEntity.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import Foundation
import RealmSwift

class GameEntity: Object {
    @Persisted(primaryKey: true) var id: Int
      @Persisted var name: String = ""
      @Persisted var released: String = ""
      @Persisted var backgroundImage: String = ""
      @Persisted var rating: Double = 0.0
      @Persisted var ratingCount: Int = 0
      @Persisted var desc: String = ""
      @Persisted var genres: List<String> = List<String>()
      @Persisted var platforms: List<String> = List<String>()
  
  func toGameModel() -> GameModel {
    return GameModel(
      id: id,
      name: name,
      released: released,
      backgroundImage: backgroundImage,
      rating: rating,
      ratingCount: ratingCount,
      description: desc,
      genres: genres.map { $0 },
      platforms: platforms.map { $0 },
      isFavorite: true
    )
  }
  
  static func fromGameModel(_ model: GameModel) -> GameEntity {
    let entity = GameEntity()
    entity.id = model.id
    entity.name = model.name
    entity.released = model.released
    entity.backgroundImage = model.backgroundImage
    entity.rating = model.rating
    entity.ratingCount = model.ratingCount
    entity.desc = model.description
    
    let genresList = List<String>()
    model.genres.forEach { genresList.append($0) }
    entity.genres = genresList
    
    let platformsList = List<String>()
    model.platforms.forEach { platformsList.append($0) }
    entity.platforms = platformsList
    
    return entity
  }
}
