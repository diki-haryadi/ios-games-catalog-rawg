//
//  GameDetailResponse.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import Foundation

// This struct matches the structure of the game detail API response
struct GameDetailResponse: Decodable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let ratingsCount: Int
    let description: String?
    let genres: [GenreResponse]
    let platforms: [PlatformWrapper]
    let developers: [DeveloperResponse]?
    let publishers: [PublisherResponse]?
    let tags: [TagResponse]?
    let esrbRating: ESRBRating?
    
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
        case developers
        case publishers
        case tags
        case esrbRating = "esrb_rating"
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

// Additional response types for game detail data
struct DeveloperResponse: Decodable {
    let id: Int
    let name: String
}

struct PublisherResponse: Decodable {
    let id: Int
    let name: String
}

struct TagResponse: Decodable {
    let id: Int
    let name: String
}

struct ESRBRating: Decodable {
    let id: Int
    let name: String
}

// These response types were already defined in GameResponse.swift
// Included here for reference in case you need to add them
/*
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
*/

// List response type for the games list endpoint
struct GamesResponse: Decodable {
    let results: [GameResponse]
    let count: Int?
    let next: String?
    let previous: String?
}
