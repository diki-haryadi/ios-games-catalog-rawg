//
//  GamesResponse.swift
//  TheMealsApp
//

import Foundation

struct GamesResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [GameResponse]
}

struct GameResponse: Codable {
    let id: Int
    let slug: String
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let ratingTop: Int
    let ratingsCount: Int
    let metacritic: Int?
    let playtime: Int
    let updated: String
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name, released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratingsCount = "ratings_count"
        case metacritic, playtime, updated
    }
}

struct GameDetailResponse: Codable {
    let id: Int
    let slug: String
    let name: String
    let nameOriginal: String
    let description: String
    let metacritic: Int?
    let released: String?
    let tba: Bool
    let backgroundImage: String?
    let rating: Double
    let ratingTop: Int
    let playtime: Int
    let screenshotsCount: Int
    let moviesCount: Int
    let creatorsCount: Int
    let achievementsCount: Int
    let parentAchievementsCount: Int
    let redditUrl: String?
    let redditName: String?
    let website: String?
    let metacriticUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case nameOriginal = "name_original"
        case description, metacritic, released, tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case playtime
        case screenshotsCount = "screenshots_count"
        case moviesCount = "movies_count"
        case creatorsCount = "creators_count"
        case achievementsCount = "achievements_count"
        case parentAchievementsCount = "parent_achievements_count"
        case redditUrl = "reddit_url"
        case redditName = "reddit_name"
        case website
        case metacriticUrl = "metacritic_url"
    }
}