//
//  GameResponse.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import Foundation

struct GameResponse: Decodable {
  let id: Int
  let name: String
  let released: String?
  let backgroundImage: String?
  let rating: Double
  let ratingsCount: Int
  let description: String?
  let genres: [GenreResponse]
  let platforms: [PlatformWrapper]
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case released
    case backgroundImage = "background_image"
    case rating
    case ratingsCount = "ratings_count"
    case description = "description_raw"
    case genres
    case platforms
  }
  
  func toGameModel() -> GameModel {
    return GameModel(
      id: id,
      name: name,
      released: released ?? "Unknown",
      backgroundImage: backgroundImage ?? "",
      rating: rating,
      ratingCount: ratingsCount,
      description: description ?? "No description available",
      genres: genres.map { $0.name },
      platforms: platforms.map { $0.platform.name },
      isFavorite: false
    )
  }
}

struct GenreResponse: Decodable {
  let id: Int
  let name: String
}

struct PlatformWrapper: Decodable {
  let platform: PlatformResponse
}

struct PlatformResponse: Decodable {
  let id: Int
  let name: String
}

struct GamesListResponse: Decodable {
  let results: [GameResponse]
}
