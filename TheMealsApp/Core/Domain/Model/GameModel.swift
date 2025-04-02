//
//  GameModel.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import Foundation

struct GameModel: Equatable, Identifiable {
  let id: Int
  let name: String
  let released: String
  let backgroundImage: String
  let rating: Double
  let ratingCount: Int
  let description: String
  let genres: [String]
  let platforms: [String]
  let isFavorite: Bool
  
  init(
    id: Int,
    name: String,
    released: String,
    backgroundImage: String,
    rating: Double,
    ratingCount: Int,
    description: String,
    genres: [String],
    platforms: [String],
    isFavorite: Bool = false
  ) {
    self.id = id
    self.name = name
    self.released = released
    self.backgroundImage = backgroundImage
    self.rating = rating
    self.ratingCount = ratingCount
    self.description = description
    self.genres = genres
    self.platforms = platforms
    self.isFavorite = isFavorite
  }
}
