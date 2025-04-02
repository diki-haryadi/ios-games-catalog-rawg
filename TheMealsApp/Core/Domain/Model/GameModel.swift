//
//  GameModel.swift
//  TheMealsApp
//
//  Created by Ben on 11/01/24.
//

import Foundation

struct GameModel: Equatable, Identifiable {
  let id: Int
  let slug: String
  let name: String
  let released: String
  let backgroundImage: String
  let rating: Double
  let ratingTop: Int
  let ratingsCount: Int
  let metacritic: Int
  let playtime: Int
  let updated: String
  var description: String = ""
  var nameOriginal: String = ""
  var tba: Bool = false
  var screenshotsCount: Int = 0
  var moviesCount: Int = 0
  var creatorsCount: Int = 0
  var achievementsCount: Int = 0
  var parentAchievementsCount: Int = 0
  var redditUrl: String = ""
  var redditName: String = ""
  var website: String = ""
  var metacriticUrl: String = ""
  var favorite: Bool = false
}