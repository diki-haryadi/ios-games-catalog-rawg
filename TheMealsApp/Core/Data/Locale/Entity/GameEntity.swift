//
//  GameEntity.swift
//  TheMealsApp
//
//  Created by Ben on 29/11/22.
//

import Foundation
import RealmSwift

class GameEntity: Object {
  @objc dynamic var id = 0
  @objc dynamic var slug = ""
  @objc dynamic var name = ""
  @objc dynamic var released = ""
  @objc dynamic var backgroundImage = ""
  @objc dynamic var rating = 0.0
  @objc dynamic var ratingTop = 0
  @objc dynamic var ratingsCount = 0
  @objc dynamic var metacritic = 0
  @objc dynamic var playtime = 0
  @objc dynamic var updated = ""
  @objc dynamic var gameDescription = ""
  @objc dynamic var nameOriginal = ""
  @objc dynamic var tba = false
  @objc dynamic var screenshotsCount = 0
  @objc dynamic var moviesCount = 0
  @objc dynamic var creatorsCount = 0
  @objc dynamic var achievementsCount = 0
  @objc dynamic var parentAchievementsCount = 0
  @objc dynamic var redditUrl = ""
  @objc dynamic var redditName = ""
  @objc dynamic var website = ""
  @objc dynamic var metacriticUrl = ""
  @objc dynamic var favorite = false

  override static func primaryKey() -> String {
    return "id"
  }
}
